/**
 * Prayer Data Types
 * Defines the structure for prayer data from source.json
 */

// Raw prayer item as stored in source.json
export interface RawPrayerItem {
  id: string;
  number: string;
  title: string;
  content: string;
  isPrayer: boolean;
  prayDateID: string | string[] | null;
  children: RawPrayerItem[];
}

// Flattened prayer item for display and search
export interface PrayerItem {
  id: string;
  number: string;
  title: string;
  content: string;
  isPrayer: boolean;
  prayDateID: string[];
  parentId: string | null;
  depth: number;
}

// Prayer category (top-level items)
export interface PrayerCategory {
  id: string;
  number: string;
  title: string;
  childCount: number;
}

// Prayer package (group of related prayers)
export interface PrayerPackage {
  id: string;
  number: string;
  title: string;
  items: PrayerItem[];
}

// Search result
export interface SearchResult {
  item: PrayerItem;
  matchType: 'title' | 'content';
  snippet: string;
}
