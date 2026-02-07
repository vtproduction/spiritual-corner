/**
 * Spiritual Corner App (Góc Tâm Linh)
 * Main entry point with navigation, theme, and splash screen
 */

import React, { useCallback, useState } from 'react';
import { StatusBar } from 'react-native';
import { NavigationContainer, DefaultTheme, DarkTheme } from '@react-navigation/native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { GestureHandlerRootView } from 'react-native-gesture-handler';

import { RootNavigator } from './src/navigation';
import { ThemeProvider, useTheme } from './src/hooks';
import { SplashScreen } from './src/components';

function AppContent(): React.JSX.Element {
  const { theme, isDark } = useTheme();
  const [showSplash, setShowSplash] = useState(true);

  const handleSplashFinish = useCallback(() => {
    setShowSplash(false);
  }, []);

  // Create React Navigation theme from our theme
  const navigationTheme = {
    ...(isDark ? DarkTheme : DefaultTheme),
    colors: {
      ...(isDark ? DarkTheme.colors : DefaultTheme.colors),
      primary: theme.colors.primary,
      background: theme.colors.background,
      card: theme.colors.surface,
      text: theme.colors.text,
      border: theme.colors.border,
    },
  };

  if (showSplash) {
    return <SplashScreen onFinish={handleSplashFinish} duration={2000} />;
  }

  return (
    <NavigationContainer theme={navigationTheme}>
      <StatusBar barStyle={isDark ? 'light-content' : 'dark-content'} />
      <RootNavigator />
    </NavigationContainer>
  );
}

function App(): React.JSX.Element {
  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <SafeAreaProvider>
        <ThemeProvider>
          <AppContent />
        </ThemeProvider>
      </SafeAreaProvider>
    </GestureHandlerRootView>
  );
}

export default App;
