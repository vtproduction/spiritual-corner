/**
 * Splash Screen Component
 * Calm, ceremonial design - no animations or flashy effects
 */

import React, { useEffect } from 'react';
import { StyleSheet, Text, View, StatusBar } from 'react-native';

import { useTheme } from '../hooks';

interface SplashScreenProps {
  onFinish: () => void;
  duration?: number;
}

export const SplashScreen: React.FC<SplashScreenProps> = ({ onFinish, duration = 2000 }) => {
  const { theme, isDark } = useTheme();

  useEffect(() => {
    const timer = setTimeout(() => {
      onFinish();
    }, duration);

    return () => clearTimeout(timer);
  }, [duration, onFinish]);

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <StatusBar barStyle={isDark ? 'light-content' : 'dark-content'} />
      <View style={styles.content}>
        <Text style={[styles.title, { color: theme.colors.textPrimary }]}>Góc Tâm Linh</Text>
        <Text style={[styles.subtitle, { color: theme.colors.textSecondary }]}>
          Văn khấn & Lịch âm
        </Text>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  content: {
    alignItems: 'center',
  },
  title: {
    fontSize: 28,
    fontWeight: '600',
    marginBottom: 8,
    letterSpacing: 0.5,
  },
  subtitle: {
    fontSize: 14,
    fontWeight: '400',
  },
});
