/**
 * Application-wide constants
 */

export * from './theme';

// App metadata
export const APP_NAME = 'Góc Tâm Linh';
export const APP_VERSION = '0.0.1';

// Storage keys
export const STORAGE_KEYS = {
  THEME: '@spiritual_corner/theme',
  SETTINGS: '@spiritual_corner/settings',
  FAVORITES: '@spiritual_corner/favorites',
} as const;

// Teleprompter defaults
export const TELEPROMPTER = {
  MIN_SPEED: 0.5,
  MAX_SPEED: 5.0,
  DEFAULT_SPEED: 1.0,
  SPEED_STEP: 0.1,
} as const;

// UI constants
export const UI = {
  ANIMATION_DURATION: 300,
  TAB_BAR_HEIGHT: 60,
  HEADER_HEIGHT: 56,
} as const;
