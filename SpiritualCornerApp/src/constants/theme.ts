/**
 * Vietnamese Spiritual App Design System
 * Color palette and theme definitions
 * 
 * Design Philosophy: Calm, respectful, ceremonial tone
 * Clean Material-style UI with soft neutral colors
 */

// Warm color palette
const warmColors = {
  50: '#FDFCFB',
  100: '#F9F7F4',
  200: '#F3F0EB',
  300: '#E8E4DC',
  400: '#D4CFC6',
  500: '#A39E94',
  600: '#7A756C',
  700: '#5C584F',
  800: '#3D3A34',
  900: '#2A2824',
};

// Accent colors (spiritual/ceremonial tan)
const accentColors = {
  light: '#B8997D',
  main: '#9B7A5C',
  dark: '#7D604A',
};

export interface ThemeColors {
  // Backgrounds
  background: string;
  backgroundSecondary: string;
  card: string;
  
  // Text
  textPrimary: string;
  textSecondary: string;
  textTertiary: string;
  textMuted: string;
  
  // Accent
  accent: string;
  accentLight: string;
  accentDark: string;
  
  // UI Elements
  border: string;
  borderLight: string;
  divider: string;
  
  // Tab Bar
  tabActive: string;
  tabInactive: string;
  tabBar: string;
  tabBarBorder: string;
  
  // Status
  error: string;
  success: string;
  
  // Legacy (for compatibility)
  primary: string;
  primaryLight: string;
  secondary: string;
  text: string;
  surface: string;
}

export interface Theme {
  dark: boolean;
  colors: ThemeColors;
}

export const lightTheme: Theme = {
  dark: false,
  colors: {
    // Backgrounds
    background: warmColors[50],        // #FDFCFB
    backgroundSecondary: warmColors[100], // #F9F7F4
    card: warmColors[100],             // #F9F7F4
    
    // Text
    textPrimary: warmColors[800],      // #3D3A34
    textSecondary: warmColors[600],    // #7A756C
    textTertiary: warmColors[500],     // #A39E94
    textMuted: warmColors[400],        // #D4CFC6
    
    // Accent
    accent: accentColors.main,         // #9B7A5C
    accentLight: accentColors.light,   // #B8997D
    accentDark: accentColors.dark,     // #7D604A
    
    // UI Elements
    border: `${warmColors[200]}80`,    // 50% opacity
    borderLight: `${warmColors[200]}40`, // 25% opacity
    divider: warmColors[200],
    
    // Tab Bar
    tabActive: accentColors.main,
    tabInactive: warmColors[400],
    tabBar: warmColors[50],
    tabBarBorder: `${warmColors[200]}B3`, // 70% opacity
    
    // Status
    error: '#DC2626',
    success: '#16A34A',
    
    // Legacy
    primary: accentColors.main,
    primaryLight: accentColors.light,
    secondary: warmColors[600],
    text: warmColors[800],
    surface: warmColors[100],
  },
};

export const darkTheme: Theme = {
  dark: true,
  colors: {
    // Backgrounds
    background: warmColors[900],       // #2A2824
    backgroundSecondary: warmColors[800], // #3D3A34
    card: warmColors[800],             // #3D3A34
    
    // Text
    textPrimary: warmColors[100],      // #F9F7F4
    textSecondary: warmColors[400],    // #D4CFC6
    textTertiary: warmColors[500],     // #A39E94
    textMuted: warmColors[600],        // #7A756C
    
    // Accent
    accent: accentColors.main,         // #9B7A5C (same as light)
    accentLight: accentColors.light,
    accentDark: accentColors.dark,
    
    // UI Elements
    border: `${warmColors[700]}66`,    // 40% opacity
    borderLight: `${warmColors[700]}33`,
    divider: warmColors[700],
    
    // Tab Bar
    tabActive: accentColors.main,
    tabInactive: warmColors[600],
    tabBar: warmColors[800],
    tabBarBorder: `${warmColors[700]}66`,
    
    // Status
    error: '#F87171',
    success: '#4ADE80',
    
    // Legacy
    primary: accentColors.main,
    primaryLight: accentColors.light,
    secondary: warmColors[500],
    text: warmColors[100],
    surface: warmColors[800],
  },
};

// Spacing constants
export const spacing = {
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 20,
  xxl: 24,
  xxxl: 32,
};

// Border radius
export const borderRadius = {
  sm: 8,
  md: 12,
  lg: 16,    // Cards (rounded-2xl)
  xl: 20,
  full: 9999,
};

// Typography sizes
export const fontSize = {
  xs: 10,
  sm: 12,
  md: 14,
  lg: 16,
  xl: 18,
  xxl: 20,
  xxxl: 24,
  display: 28,
};
