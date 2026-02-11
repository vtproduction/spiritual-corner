/**
 * Prayer Data Service
 * Loads, validates, and provides access to the normalized prayer data.
 *
 * Data is loaded once from the bundled JSON and memoized.
 * A search index is built at first access.
 */

import {
  Category,
  EventItem,
  Prayer,
  PrayersData,
  SearchResult,
} from '../types/prayer';

// Import the bundled prayer data
import rawData from '../assets/data/prayers.json';

// ─── Schema Validation ──────────────────────────────────────────

class SchemaValidationError extends Error {
  constructor(message: string) {
    super(`[PrayerData] Schema validation failed: ${message}`);
    this.name = 'SchemaValidationError';
  }
}

function validateSchema(data: unknown): asserts data is PrayersData {
  const d = data as PrayersData;

  if (!d || typeof d !== 'object') {
    throw new SchemaValidationError('root must be an object');
  }
  if (!Array.isArray(d.categories)) {
    throw new SchemaValidationError('categories must be an array');
  }
  if (!Array.isArray(d.items)) {
    throw new SchemaValidationError('items must be an array');
  }

  // Build category ID set for referential integrity check
  const categoryIds = new Set(d.categories.map(c => c.id));

  for (const cat of d.categories) {
    if (!cat.id || !cat.name) {
      throw new SchemaValidationError(`category missing id or name: ${JSON.stringify(cat)}`);
    }
  }

  for (const item of d.items) {
    if (!item.id || !item.name || !item.categoryId) {
      throw new SchemaValidationError(`item missing id/name/categoryId: ${item.id}`);
    }
    if (!categoryIds.has(item.categoryId)) {
      throw new SchemaValidationError(
        `item "${item.name}" references unknown categoryId: ${item.categoryId}`,
      );
    }
    if (!Array.isArray(item.prayDateIDs)) {
      throw new SchemaValidationError(
        `item "${item.name}" prayDateIDs must be an array`,
      );
    }
    for (const pid of item.prayDateIDs) {
      if (typeof pid !== 'string') {
        throw new SchemaValidationError(
          `item "${item.name}" prayDateIDs contains non-string: ${pid}`,
        );
      }
    }
    if (!Array.isArray(item.prayers) || item.prayers.length === 0) {
      throw new SchemaValidationError(
        `item "${item.name}" must have at least one prayer`,
      );
    }
    for (const prayer of item.prayers) {
      if (!prayer.id || !prayer.name || !prayer.content) {
        throw new SchemaValidationError(
          `prayer in "${item.name}" missing id/name/content: ${prayer.id}`,
        );
      }
    }
  }
}

// ─── Memoized Data Store ────────────────────────────────────────

let _data: PrayersData | null = null;
let _eventMap: Map<string, EventItem> | null = null;
let _eventsByCategoryMap: Map<string, EventItem[]> | null = null;
let _prayerToEventMap: Map<string, string> | null = null;

// Search index
let _searchTokens: Array<{
  eventId: string;
  eventNameLower: string;
  prayers: Array<{
    prayerId: string;
    nameLower: string;
    contentLower: string;
  }>;
}> | null = null;

/**
 * Load and validate data. Called once, result memoized.
 */
function loadData(): PrayersData {
  if (_data) {
    return _data;
  }

  validateSchema(rawData);
  _data = rawData as PrayersData;

  // Build lookup maps
  _eventMap = new Map<string, EventItem>();
  _eventsByCategoryMap = new Map<string, EventItem[]>();
  _prayerToEventMap = new Map<string, string>();

  for (const item of _data.items) {
    _eventMap.set(item.id, item);

    const existing = _eventsByCategoryMap.get(item.categoryId) || [];
    existing.push(item);
    _eventsByCategoryMap.set(item.categoryId, existing);

    for (const prayer of item.prayers) {
      _prayerToEventMap.set(prayer.id, item.id);
    }
  }

  return _data;
}

/**
 * Build search index (lazy, on first search call)
 */
function getSearchIndex() {
  if (_searchTokens) {
    return _searchTokens;
  }

  const data = loadData();
  _searchTokens = data.items.map(item => ({
    eventId: item.id,
    eventNameLower: item.name.toLowerCase(),
    prayers: item.prayers.map(p => ({
      prayerId: p.id,
      nameLower: p.name.toLowerCase(),
      contentLower: p.content.toLowerCase(),
    })),
  }));

  return _searchTokens;
}

// ─── Public API ─────────────────────────────────────────────────

/**
 * Get all categories
 */
export function getCategories(): Category[] {
  return loadData().categories;
}

/**
 * Get events filtered by category ID
 */
export function getEventsByCategory(categoryId: string): EventItem[] {
  loadData();
  return _eventsByCategoryMap?.get(categoryId) || [];
}

/**
 * Get a single event by ID
 */
export function getEvent(eventId: string): EventItem | null {
  loadData();
  return _eventMap?.get(eventId) || null;
}

/**
 * Get a specific prayer from an event
 */
export function getPrayer(eventId: string, prayerId: string): Prayer | null {
  const event = getEvent(eventId);
  if (!event) {
    return null;
  }
  return event.prayers.find(p => p.id === prayerId) || null;
}

/**
 * Get all items (used for home screen quick actions etc.)
 */
export function getAllEvents(): EventItem[] {
  return loadData().items;
}

/**
 * Search across event names, prayer names, and prayer content.
 * Returns results grouped by event.
 */
export function searchEvents(query: string): SearchResult[] {
  const trimmed = query.trim();
  if (!trimmed) {
    return [];
  }

  const q = trimmed.toLowerCase();
  const index = getSearchIndex();
  const results: SearchResult[] = [];

  for (const entry of index) {
    const event = _eventMap?.get(entry.eventId);
    if (!event) {
      continue;
    }

    // Check event name
    if (entry.eventNameLower.includes(q)) {
      results.push({
        event,
        matchingPrayerIds: event.prayers.map(p => p.id),
        matchType: 'eventName',
      });
      continue;
    }

    // Check prayer names and content
    const matchingIds: string[] = [];
    let matched: 'prayerName' | 'prayerContent' | null = null;

    for (const p of entry.prayers) {
      if (p.nameLower.includes(q)) {
        matchingIds.push(p.prayerId);
        matched = matched || 'prayerName';
      } else if (p.contentLower.includes(q)) {
        matchingIds.push(p.prayerId);
        matched = matched || 'prayerContent';
      }
    }

    if (matchingIds.length > 0 && matched) {
      results.push({
        event,
        matchingPrayerIds: matchingIds,
        matchType: matched,
      });
    }
  }

  return results;
}

// ─── Initialization (fail fast) ─────────────────────────────────

// Validate data at module load time so errors surface immediately
loadData();
