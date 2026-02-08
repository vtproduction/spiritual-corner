/**
 * Home Screen
 * Main landing screen with today's date and quick actions
 */

import React from 'react';
import { StyleSheet, Text, View, SafeAreaView, StatusBar, ScrollView } from 'react-native';

import { useTheme } from '../hooks';
import { spacing, borderRadius, fontSize } from '../constants/theme';

export const HomeScreen: React.FC = () => {
  const { theme, isDark } = useTheme();

  // Get current date formatted
  const now = new Date();
  const dateString = now.toLocaleDateString('vi-VN', {
    weekday: 'long',
    day: 'numeric',
    month: 'long',
  });

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <StatusBar barStyle={isDark ? 'light-content' : 'dark-content'} />
      
      {/* Header */}
      <View style={styles.header}>
        <View>
          <Text style={[styles.dateLabel, { color: theme.colors.textTertiary }]}>
            {dateString.toUpperCase()}
          </Text>
          <Text style={[styles.title, { color: theme.colors.textPrimary }]}>
            Góc Tâm Linh
          </Text>
        </View>
      </View>

      <ScrollView 
        style={styles.content}
        contentContainerStyle={styles.contentContainer}
        showsVerticalScrollIndicator={false}
      >
        {/* Today Card */}
        <View style={[styles.card, { 
          backgroundColor: theme.colors.card,
          borderColor: theme.colors.border,
        }]}>
          <Text style={[styles.cardLabel, { color: theme.colors.textTertiary }]}>
            HÔM NAY
          </Text>
          <Text style={[styles.cardTitle, { color: theme.colors.textPrimary }]}>
            Ngày bình thường
          </Text>
          <Text style={[styles.cardBody, { color: theme.colors.textSecondary }]}>
            Không có ngày lễ đặc biệt
          </Text>
        </View>

        {/* Quick Actions */}
        <View style={[styles.card, { 
          backgroundColor: theme.colors.card,
          borderColor: theme.colors.border,
        }]}>
          <Text style={[styles.sectionTitle, { color: theme.colors.textPrimary }]}>
            Văn khấn thường dùng
          </Text>
          
          <View style={styles.actionList}>
            <View style={[styles.actionItem, { borderBottomColor: theme.colors.divider }]}>
              <Text style={[styles.actionTitle, { color: theme.colors.textPrimary }]}>Khấn Thổ Công</Text>
              <Text style={[styles.chevron, { color: theme.colors.textMuted }]}>›</Text>
            </View>
            <View style={[styles.actionItem, { borderBottomColor: theme.colors.divider }]}>
              <Text style={[styles.actionTitle, { color: theme.colors.textPrimary }]}>Khấn Gia tiên</Text>
              <Text style={[styles.chevron, { color: theme.colors.textMuted }]}>›</Text>
            </View>
            <View style={styles.actionItem}>
              <Text style={[styles.actionTitle, { color: theme.colors.textPrimary }]}>Khấn Thần Tài</Text>
              <Text style={[styles.chevron, { color: theme.colors.textMuted }]}>›</Text>
            </View>
          </View>
        </View>
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
  dateLabel: {
    fontSize: fontSize.xs,
    fontWeight: '500',
    letterSpacing: 1,
    marginBottom: 2,
  },
  title: {
    fontSize: fontSize.xxl,
    fontWeight: '600',
  },
  content: {
    flex: 1,
  },
  contentContainer: {
    padding: spacing.xl,
    gap: spacing.lg,
  },
  card: {
    borderRadius: borderRadius.lg,
    padding: spacing.xl,
    borderWidth: 1,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 2,
    elevation: 1,
  },
  cardLabel: {
    fontSize: fontSize.xs,
    fontWeight: '500',
    letterSpacing: 1,
    marginBottom: spacing.xs,
  },
  cardTitle: {
    fontSize: fontSize.lg,
    fontWeight: '600',
    marginBottom: spacing.xs,
  },
  cardBody: {
    fontSize: fontSize.sm,
    lineHeight: 20,
  },
  sectionTitle: {
    fontSize: fontSize.lg,
    fontWeight: '600',
    marginBottom: spacing.md,
  },
  actionList: {
    marginTop: spacing.sm,
  },
  actionItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: spacing.md,
    borderBottomWidth: 1,
  },
  actionTitle: {
    fontSize: fontSize.md,
    fontWeight: '400',
  },
  chevron: {
    fontSize: 20,
    fontWeight: '300',
  },
});
