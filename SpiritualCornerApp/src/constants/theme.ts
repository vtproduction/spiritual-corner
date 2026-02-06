/**
 * Theme definitions for Spiritual Corner App
 * Supports Light and Dark mode
 */

export interface ThemeColors {
  background: string;
  surface: string;
  primary: string;
  primaryLight: string;
  secondary: string;
  text: string;
  textSecondary: string;
  border: string;
  tabBar: string;
  tabBarBorder: string;
  error: string;
  success: string;
}

export interface Theme {
  dark: boolean;
  colors: ThemeColors;
}

export const lightTheme: Theme = {
  dark: false,
  colors: {
    background: '#f8f9fa',
    surface: '#ffffff',
    primary: '#8b5cf6',
    primaryLight: '#c4b5fd',
    secondary: '#06b6d4',
    text: '#1f2937',
    textSecondary: '#6b7280',
    border: '#e5e7eb',
    tabBar: '#ffffff',
    tabBarBorder: '#e9ecef',
    error: '#ef4444',
    success: '#10b981',
  },
};

export const darkTheme: Theme = {
  dark: true,
  colors: {
    background: '#111827',
    surface: '#1f2937',
    primary: '#a78bfa',
    primaryLight: '#7c3aed',
    secondary: '#22d3ee',
    text: '#f9fafb',
    textSecondary: '#9ca3af',
    border: '#374151',
    tabBar: '#1f2937',
    tabBarBorder: '#374151',
    error: '#f87171',
    success: '#34d399',
  },
};
