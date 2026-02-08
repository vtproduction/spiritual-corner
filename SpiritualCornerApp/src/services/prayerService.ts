/**
 * Prayer Data Service
 * Loads and parses prayer data from the bundled JSON file
 */

import {
  RawPrayerItem,
  PrayerItem,
  PrayerCategory,
  PrayerPackage,
} from '../types/prayer';

// Import the bundled prayer data
import prayerData from '../assets/data/prayers.json';

/**
 * Get all raw prayer data
 */
export const getRawPrayerData = (): RawPrayerItem[] => {
  return prayerData as RawPrayerItem[];
};

/**
 * Normalize prayDateID to always be an array
 */
const normalizePrayDateID = (prayDateID: string | string[] | null): string[] => {
  if (prayDateID === null) {
    return [];
  }
  if (Array.isArray(prayDateID)) {
    return prayDateID;
  }
  return [prayDateID];
};

/**
 * Flatten the hierarchical prayer data into a flat array
 */
export const flattenPrayers = (
  items: RawPrayerItem[],
  parentId: string | null = null,
  depth: number = 0,
): PrayerItem[] => {
  const result: PrayerItem[] = [];

  for (const item of items) {
    result.push({
      id: item.id,
      number: item.number,
      title: item.title,
      content: item.content,
      isPrayer: item.isPrayer,
      prayDateID: normalizePrayDateID(item.prayDateID),
      parentId,
      depth,
    });

    if (item.children && item.children.length > 0) {
      result.push(...flattenPrayers(item.children, item.id, depth + 1));
    }
  }

  return result;
};

/**
 * Get prayer categories (top-level items)
 */
export const getPrayerCategories = (): PrayerCategory[] => {
  const rawData = getRawPrayerData();

  return rawData.map(item => ({
    id: item.id,
    number: item.number,
    title: item.title,
    childCount: countDescendants(item),
  }));
};

/**
 * Count all descendants of a prayer item
 */
const countDescendants = (item: RawPrayerItem): number => {
  let count = item.children?.length || 0;
  for (const child of item.children || []) {
    count += countDescendants(child);
  }
  return count;
};

/**
 * Get a specific prayer item by ID
 */
export const getPrayerById = (id: string): PrayerItem | null => {
  const allPrayers = flattenPrayers(getRawPrayerData());
  return allPrayers.find(p => p.id === id) || null;
};

/**
 * Get children of a prayer item by parent ID
 */
export const getChildrenByParentId = (parentId: string): PrayerItem[] => {
  const rawData = getRawPrayerData();
  const parent = findRawItemById(rawData, parentId);

  if (!parent || !parent.children) {
    return [];
  }

  return parent.children.map(child => ({
    id: child.id,
    number: child.number,
    title: child.title,
    content: child.content,
    isPrayer: child.isPrayer,
    prayDateID: normalizePrayDateID(child.prayDateID),
    parentId,
    depth: getItemDepth(rawData, child.id),
  }));
};

/**
 * Find a raw item by ID in the hierarchy
 */
const findRawItemById = (
  items: RawPrayerItem[],
  id: string,
): RawPrayerItem | null => {
  for (const item of items) {
    if (item.id === id) {
      return item;
    }
    if (item.children && item.children.length > 0) {
      const found = findRawItemById(item.children, id);
      if (found) {
        return found;
      }
    }
  }
  return null;
};

/**
 * Get the depth of an item in the hierarchy
 */
const getItemDepth = (items: RawPrayerItem[], id: string, depth: number = 0): number => {
  for (const item of items) {
    if (item.id === id) {
      return depth;
    }
    if (item.children && item.children.length > 0) {
      const found = getItemDepth(item.children, id, depth + 1);
      if (found >= 0) {
        return found;
      }
    }
  }
  return -1;
};

/**
 * Get all prayers (actual prayer content, where isPrayer is true)
 */
export const getAllPrayers = (): PrayerItem[] => {
  const allItems = flattenPrayers(getRawPrayerData());
  return allItems.filter(item => item.isPrayer);
};

/**
 * Search prayers by title or content
 */
export const searchPrayers = (query: string): PrayerItem[] => {
  if (!query.trim()) {
    return [];
  }

  const normalizedQuery = query.toLowerCase().trim();
  const allItems = flattenPrayers(getRawPrayerData());

  return allItems.filter(
    item =>
      item.title.toLowerCase().includes(normalizedQuery) ||
      item.content.toLowerCase().includes(normalizedQuery),
  );
};
