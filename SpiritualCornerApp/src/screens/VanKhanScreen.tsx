/**
 * Văn Khấn Screen
 * Prayer categories list following design system
 */

import React from 'react';
import {
  StyleSheet,
  Text,
  View,
  SafeAreaView,
  StatusBar,
  ScrollView,
  TouchableOpacity,
} from 'react-native';

import { useTheme, usePrayers } from '../hooks';
import { spacing, borderRadius, fontSize } from '../constants/theme';

export const VanKhanScreen: React.FC = () => {
  const { theme, isDark } = useTheme();
  const { categories, isLoading } = usePrayers();

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <StatusBar barStyle={isDark ? 'light-content' : 'dark-content'} />

      {/* Header */}
      <View style={styles.header}>
        <View style={styles.headerContent}>
          <View>
            <Text style={[styles.title, { color: theme.colors.textPrimary }]}>
              Văn khấn
            </Text>
            <Text style={[styles.subtitle, { color: theme.colors.textSecondary }]}>
              Chọn loại văn khấn bạn cần
            </Text>
          </View>
          {/* Search icon placeholder */}
          <View style={[styles.searchButton, { backgroundColor: theme.colors.backgroundSecondary }]}>
            <Text style={{ color: theme.colors.textTertiary, fontSize: 18 }}>⌕</Text>
          </View>
        </View>
      </View>

      <ScrollView
        style={styles.content}
        contentContainerStyle={styles.contentContainer}
        showsVerticalScrollIndicator={false}
      >
        {isLoading ? (
          <Text style={[styles.loadingText, { color: theme.colors.textSecondary }]}>
            Đang tải...
          </Text>
        ) : (
          <View style={[styles.listCard, { 
            backgroundColor: theme.colors.card,
            borderColor: theme.colors.border,
          }]}>
            {categories.map((category, index) => (
              <TouchableOpacity
                key={category.id}
                style={[
                  styles.listItem,
                  index < categories.length - 1 && {
                    borderBottomWidth: 1,
                    borderBottomColor: theme.colors.divider,
                  },
                ]}
                activeOpacity={0.6}
              >
                <View style={styles.listItemContent}>
                  <Text style={[styles.itemTitle, { color: theme.colors.textPrimary }]}>
                    {category.title}
                  </Text>
                  <Text style={[styles.itemSubtitle, { color: theme.colors.textSecondary }]}>
                    {category.childCount} bài khấn
                  </Text>
                </View>
                <Text style={[styles.chevron, { color: theme.colors.textMuted }]}>›</Text>
              </TouchableOpacity>
            ))}
          </View>
        )}
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    paddingHorizontal: spacing.xl,
    paddingTop: spacing.lg,
    paddingBottom: spacing.md,
  },
  headerContent: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
  },
  title: {
    fontSize: fontSize.xxl,
    fontWeight: '600',
  },
  subtitle: {
    fontSize: fontSize.sm,
    marginTop: 2,
  },
  searchButton: {
    width: 40,
    height: 40,
    borderRadius: borderRadius.full,
    justifyContent: 'center',
    alignItems: 'center',
  },
  content: {
    flex: 1,
  },
  contentContainer: {
    padding: spacing.xl,
  },
  loadingText: {
    textAlign: 'center',
    fontSize: fontSize.sm,
  },
  listCard: {
    borderRadius: borderRadius.lg,
    borderWidth: 1,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 2,
    elevation: 1,
  },
  listItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: spacing.lg,
    paddingHorizontal: spacing.xl,
  },
  listItemContent: {
    flex: 1,
    marginRight: spacing.md,
  },
  itemTitle: {
    fontSize: fontSize.lg,
    fontWeight: '500',
  },
  itemSubtitle: {
    fontSize: fontSize.sm,
    marginTop: 2,
  },
  chevron: {
    fontSize: 24,
    fontWeight: '300',
  },
});
