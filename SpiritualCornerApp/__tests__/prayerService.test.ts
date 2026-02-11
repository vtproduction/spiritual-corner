/**
 * Prayer Service – Unit Tests
 * Validates schema integrity and data lookup functions.
 */

import {
  getCategories,
  getEventsByCategory,
  getEvent,
  getPrayer,
  getAllEvents,
  searchEvents,
} from '../src/services/prayerService';

describe('prayerService', () => {
  // ── Schema & Loading ──────────────────────────────────────────

  test('loads data without validation errors', () => {
    expect(() => getCategories()).not.toThrow();
  });

  test('returns 4 categories', () => {
    const categories = getCategories();
    expect(categories.length).toBe(4);
  });

  test('each category has id and name', () => {
    for (const cat of getCategories()) {
      expect(typeof cat.id).toBe('string');
      expect(cat.id.length).toBeGreaterThan(0);
      expect(typeof cat.name).toBe('string');
      expect(cat.name.length).toBeGreaterThan(0);
    }
  });

  // ── Category → Events ────────────────────────────────────────

  test('getEventsByCategory returns items for the first category', () => {
    const firstCat = getCategories()[0];
    const events = getEventsByCategory(firstCat.id);
    expect(events.length).toBeGreaterThan(0);
    events.forEach(e => expect(e.categoryId).toBe(firstCat.id));
  });

  test('getEventsByCategory returns empty for unknown category', () => {
    expect(getEventsByCategory('unknown-cat-id')).toEqual([]);
  });

  test('sum of events across categories equals total items', () => {
    const allEvents = getAllEvents();
    const sumFromCategories = getCategories().reduce(
      (sum, cat) => sum + getEventsByCategory(cat.id).length,
      0,
    );
    expect(sumFromCategories).toBe(allEvents.length);
  });

  // ── Event Fields ──────────────────────────────────────────────

  test('every event has valid required fields', () => {
    for (const event of getAllEvents()) {
      expect(event.id).toBeTruthy();
      expect(event.name).toBeTruthy();
      expect(event.categoryId).toBeTruthy();
      expect(Array.isArray(event.prayDateIDs)).toBe(true);
      expect(typeof event.isDaily).toBe('boolean');
      expect(typeof event.isMonthly).toBe('boolean');
      expect(Array.isArray(event.prayers)).toBe(true);
      expect(event.prayers.length).toBeGreaterThan(0);
    }
  });

  test('every prayer has id, name, and content', () => {
    for (const event of getAllEvents()) {
      for (const prayer of event.prayers) {
        expect(prayer.id).toBeTruthy();
        expect(prayer.name).toBeTruthy();
        expect(prayer.content).toBeTruthy();
      }
    }
  });

  // ── Lookup ────────────────────────────────────────────────────

  test('getEvent retrieves an event by ID', () => {
    const first = getAllEvents()[0];
    const found = getEvent(first.id);
    expect(found).not.toBeNull();
    expect(found!.id).toBe(first.id);
    expect(found!.name).toBe(first.name);
  });

  test('getEvent returns null for unknown ID', () => {
    expect(getEvent('nonexistent')).toBeNull();
  });

  test('getPrayer retrieves a prayer by eventId + prayerId', () => {
    const event = getAllEvents()[0];
    const prayer = event.prayers[0];
    const found = getPrayer(event.id, prayer.id);
    expect(found).not.toBeNull();
    expect(found!.id).toBe(prayer.id);
    expect(found!.content.length).toBeGreaterThan(0);
  });

  test('getPrayer returns null for unknown IDs', () => {
    expect(getPrayer('fake-event', 'fake-prayer')).toBeNull();
  });

  // ── Search ────────────────────────────────────────────────────

  test('searchEvents returns results for "khấn"', () => {
    const results = searchEvents('khấn');
    expect(results.length).toBeGreaterThan(0);
    for (const r of results) {
      expect(r.event).toBeDefined();
      expect(r.matchingPrayerIds.length).toBeGreaterThan(0);
      expect(['eventName', 'prayerName', 'prayerContent']).toContain(r.matchType);
    }
  });

  test('searchEvents returns empty for gibberish query', () => {
    expect(searchEvents('xyzqwerty123')).toEqual([]);
  });

  test('searchEvents returns empty for empty query', () => {
    expect(searchEvents('')).toEqual([]);
    expect(searchEvents('   ')).toEqual([]);
  });
});
