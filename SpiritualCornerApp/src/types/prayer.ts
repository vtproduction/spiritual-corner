/**
 * Prayer Data Types
 * Defines the structure for the normalized prayer data schema.
 *
 * Schema: { categories: Category[], items: EventItem[] }
 * Navigation flow: Category -> EventItem -> Prayer
 */

// ─── New Normalized Schema Types ──────────────────────────────────

/** Top-level grouping (e.g. "VĂN KHẤN THẦN LINH TẠI GIA") */
export interface Category {
  id: string;
  name: string;
}

/** A single prayer/chant within an Event */
export interface Prayer {
  id: string;
  name: string;
  /** Optional per-prayer introduction or description */
  intro?: string;
  /** Full prayer/chant text (preserve \n line breaks) */
  content: string;
}

/** An event or ceremony containing one or more prayers */
export interface EventItem {
  id: string;
  /** References Category.id */
  categoryId: string;
  name: string;
  /** Always an array (can be empty). References lunar calendar date IDs. */
  prayDateIDs: string[];
  isDaily: boolean;
  isMonthly: boolean;
  /** Merged "Xuất Xứ" (origin/history) at Event level */
  detail?: string;
  /** Merged "Sắm Lễ" (offerings/preparations) at Event level */
  prepare?: string;
  /** Non-empty array of prayers */
  prayers: Prayer[];
}

/** Root data shape from the JSON file */
export interface PrayersData {
  categories: Category[];
  items: EventItem[];
}

// ─── Search ──────────────────────────────────────────────────────

export interface SearchResult {
  event: EventItem;
  matchingPrayerIds: string[];
  matchType: 'eventName' | 'prayerName' | 'prayerContent';
}

// ─── Legacy Types (deprecated – kept only for backward compat) ──

/** @deprecated Use EventItem instead */
export interface RawPrayerItem {
  id: string;
  number: string;
  title: string;
  content: string;
  isPrayer: boolean;
  prayDateID: string | string[] | null;
  children: RawPrayerItem[];
}

/** @deprecated Use EventItem instead */
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

/** @deprecated Use Category instead */
export interface PrayerCategory {
  id: string;
  number: string;
  title: string;
  childCount: number;
}

/** @deprecated No longer used */
export interface PrayerPackage {
  id: string;
  number: string;
  title: string;
  items: PrayerItem[];
}
