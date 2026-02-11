/**
 * Teleprompter Screen
 * Core prayer reading feature with auto-scroll functionality
 *
 * Features:
 * - Large readable text
 * - Auto-scroll with adjustable speed
 * - Play/Pause controls
 * - Speed adjustment (0.5x - 2x)
 * - Auto-hide controls
 */

import React, { useState, useRef, useEffect, useCallback } from 'react';
import {
  StyleSheet,
  Text,
  View,
  SafeAreaView,
  StatusBar,
  ScrollView,
  TouchableOpacity,
  Animated,
  Dimensions,
  NativeScrollEvent,
  NativeSyntheticEvent,
} from 'react-native';
import { useNavigation, useRoute, RouteProp } from '@react-navigation/native';

import { useTheme, usePrayers } from '../hooks';
import { spacing, borderRadius, fontSize } from '../constants/theme';
import { VanKhanStackParamList } from '../navigation/VanKhanNavigator';

type TeleprompterRouteProp = RouteProp<VanKhanStackParamList, 'Teleprompter'>;

const SCROLL_SPEEDS = [0.5, 1, 1.5, 2];
const { height: SCREEN_HEIGHT } = Dimensions.get('window');

export const TeleprompterScreen: React.FC = () => {
  const { theme, isDark } = useTheme();
  const navigation = useNavigation();
  const route = useRoute<TeleprompterRouteProp>();
  const { eventId, prayerId, prayerName } = route.params;
  const { getPrayer } = usePrayers();

  // Get prayer data
  const prayer = getPrayer(eventId, prayerId);
  const prayerContent = prayer?.content || '';
  const prayerIntro = prayer?.intro || '';

  // State
  const [isPlaying, setIsPlaying] = useState(false);
  const [speedIndex, setSpeedIndex] = useState(1); // Default 1x
  const [showControls, setShowControls] = useState(true);
  const [scrollProgress, setScrollProgress] = useState(0);

  // Refs
  const scrollViewRef = useRef<ScrollView>(null);
  const scrollY = useRef(0);
  const contentHeight = useRef(0);
  const scrollInterval = useRef<ReturnType<typeof setInterval> | null>(null);
  const controlsTimeout = useRef<ReturnType<typeof setTimeout> | null>(null);
  const controlsOpacity = useRef(new Animated.Value(1)).current;

  // Current speed
  const currentSpeed = SCROLL_SPEEDS[speedIndex];

  // Auto-scroll logic
  useEffect(() => {
    if (isPlaying) {
      scrollInterval.current = setInterval(() => {
        const newY = scrollY.current + currentSpeed;
        scrollViewRef.current?.scrollTo({ y: newY, animated: false });
      }, 50); // 20fps for smooth scrolling
    } else {
      if (scrollInterval.current) {
        clearInterval(scrollInterval.current);
        scrollInterval.current = null;
      }
    }

    return () => {
      if (scrollInterval.current) {
        clearInterval(scrollInterval.current);
      }
    };
  }, [isPlaying, currentSpeed]);

  // Auto-hide controls
  const resetControlsTimer = useCallback(() => {
    if (controlsTimeout.current) {
      clearTimeout(controlsTimeout.current);
    }

    setShowControls(true);
    Animated.timing(controlsOpacity, {
      toValue: 1,
      duration: 200,
      useNativeDriver: true,
    }).start();

    if (isPlaying) {
      controlsTimeout.current = setTimeout(() => {
        Animated.timing(controlsOpacity, {
          toValue: 0,
          duration: 500,
          useNativeDriver: true,
        }).start(() => setShowControls(false));
      }, 3000);
    }
  }, [isPlaying, controlsOpacity]);

  useEffect(() => {
    resetControlsTimer();
    return () => {
      if (controlsTimeout.current) {
        clearTimeout(controlsTimeout.current);
      }
    };
  }, [isPlaying, resetControlsTimer]);

  // Handle scroll events
  const handleScroll = (event: NativeSyntheticEvent<NativeScrollEvent>) => {
    scrollY.current = event.nativeEvent.contentOffset.y;
    const { contentSize, layoutMeasurement } = event.nativeEvent;
    const maxScroll = contentSize.height - layoutMeasurement.height;
    setScrollProgress(maxScroll > 0 ? scrollY.current / maxScroll : 0);
  };

  const handleContentSizeChange = (_: number, height: number) => {
    contentHeight.current = height;
  };

  // Controls
  const handleBack = () => {
    navigation.goBack();
  };

  const togglePlay = () => {
    setIsPlaying(!isPlaying);
    resetControlsTimer();
  };

  const cycleSpeed = () => {
    setSpeedIndex((prev) => (prev + 1) % SCROLL_SPEEDS.length);
    resetControlsTimer();
  };

  const handleScreenPress = () => {
    resetControlsTimer();
  };

  // Parse prayer content into paragraphs, preserving line breaks
  const paragraphs = prayerContent.split('\n').filter(p => p.trim());

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <StatusBar barStyle={isDark ? 'light-content' : 'dark-content'} />

      {/* Header */}
      <Animated.View style={[styles.header, { opacity: controlsOpacity }]}>
        <TouchableOpacity onPress={handleBack} style={styles.closeButton} activeOpacity={0.6}>
          <Text style={[styles.closeIcon, { color: theme.colors.textSecondary }]}>✕</Text>
        </TouchableOpacity>
        <View style={styles.headerCenter}>
          <Text style={[styles.headerTitle, { color: theme.colors.textPrimary }]} numberOfLines={1}>
            {prayerName}
          </Text>
        </View>
        <TouchableOpacity style={styles.settingsButton} activeOpacity={0.6}>
          <Text style={[styles.settingsIcon, { color: theme.colors.textSecondary }]}>☰</Text>
        </TouchableOpacity>
      </Animated.View>

      {/* Content */}
      <TouchableOpacity
        activeOpacity={1}
        onPress={handleScreenPress}
        style={styles.contentWrapper}
      >
        <ScrollView
          ref={scrollViewRef}
          style={styles.scrollView}
          contentContainerStyle={styles.scrollContent}
          onScroll={handleScroll}
          onContentSizeChange={handleContentSizeChange}
          scrollEventThrottle={16}
          showsVerticalScrollIndicator={false}
        >
          {/* Prayer Title */}
          <Text style={[styles.prayerTitle, { color: theme.colors.textPrimary }]}>
            {prayerName}
          </Text>

          {/* Prayer Intro (if exists) */}
          {prayerIntro ? (
            <Text style={[styles.introText, { color: theme.colors.textSecondary }]}>
              {prayerIntro}
            </Text>
          ) : null}

          {/* Prayer Content — preserve line breaks */}
          {paragraphs.map((paragraph, index) => (
            <Text
              key={index}
              style={[styles.paragraph, { color: theme.colors.textPrimary }]}
            >
              {paragraph}
            </Text>
          ))}

          {/* Bottom padding for scrolling past end */}
          <View style={{ height: SCREEN_HEIGHT * 0.5 }} />
        </ScrollView>
      </TouchableOpacity>

      {/* Progress Bar */}
      <View style={[styles.progressBar, { backgroundColor: theme.colors.border }]}>
        <View
          style={[
            styles.progressFill,
            {
              backgroundColor: theme.colors.accent,
              width: `${scrollProgress * 100}%`,
            },
          ]}
        />
      </View>

      {/* Bottom Controls */}
      <Animated.View
        style={[
          styles.controls,
          {
            backgroundColor: theme.colors.card,
            borderTopColor: theme.colors.border,
            opacity: controlsOpacity,
          },
        ]}
      >
        <TouchableOpacity style={styles.controlButton} activeOpacity={0.6}>
          <Text style={[styles.controlIcon, { color: theme.colors.textSecondary }]}>A↓</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.controlButton} activeOpacity={0.6}>
          <Text style={[styles.controlIcon, { color: theme.colors.textSecondary }]}>A↑</Text>
        </TouchableOpacity>

        {/* Play/Pause Button */}
        <TouchableOpacity
          style={[styles.playButton, { backgroundColor: theme.colors.accent }]}
          onPress={togglePlay}
          activeOpacity={0.7}
        >
          <Text style={styles.playIcon}>
            {isPlaying ? '⏸' : '▶'}
          </Text>
        </TouchableOpacity>

        {/* Speed Button */}
        <TouchableOpacity style={styles.controlButton} onPress={cycleSpeed} activeOpacity={0.6}>
          <Text style={[styles.speedText, { color: theme.colors.textSecondary }]}>
            {currentSpeed}x
          </Text>
        </TouchableOpacity>

        {/* Timer placeholder */}
        <TouchableOpacity style={styles.controlButton} activeOpacity={0.6}>
          <Text style={[styles.controlIcon, { color: theme.colors.textSecondary }]}>⏱</Text>
        </TouchableOpacity>
      </Animated.View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
  },
  closeButton: {
    width: 40,
    height: 40,
    borderRadius: borderRadius.full,
    justifyContent: 'center',
    alignItems: 'center',
  },
  closeIcon: {
    fontSize: 18,
    fontWeight: '300',
  },
  headerCenter: {
    flex: 1,
    alignItems: 'center',
  },
  headerTitle: {
    fontSize: fontSize.md,
    fontWeight: '500',
  },
  settingsButton: {
    width: 40,
    height: 40,
    borderRadius: borderRadius.full,
    justifyContent: 'center',
    alignItems: 'center',
  },
  settingsIcon: {
    fontSize: 18,
  },
  contentWrapper: {
    flex: 1,
  },
  scrollView: {
    flex: 1,
  },
  scrollContent: {
    paddingHorizontal: spacing.xl,
    paddingTop: spacing.xl,
  },
  prayerTitle: {
    fontSize: 24,
    fontWeight: '600',
    textAlign: 'center',
    marginBottom: spacing.sm,
  },
  introText: {
    fontSize: 16,
    fontStyle: 'italic',
    textAlign: 'center',
    lineHeight: 24,
    marginBottom: spacing.lg,
    paddingHorizontal: spacing.lg,
  },
  paragraph: {
    fontSize: 20,
    lineHeight: 36,
    marginBottom: spacing.lg,
  },
  progressBar: {
    height: 2,
    width: '100%',
  },
  progressFill: {
    height: '100%',
  },
  controls: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-around',
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.xl,
    borderTopWidth: 1,
  },
  controlButton: {
    width: 44,
    height: 44,
    justifyContent: 'center',
    alignItems: 'center',
  },
  controlIcon: {
    fontSize: 16,
  },
  playButton: {
    width: 56,
    height: 56,
    borderRadius: 28,
    justifyContent: 'center',
    alignItems: 'center',
  },
  playIcon: {
    fontSize: 20,
    color: '#FFFFFF',
  },
  speedText: {
    fontSize: fontSize.sm,
    fontWeight: '600',
  },
});
