/**
 * Settings Screen
 * App settings and preferences
 */

import React from 'react';
import {
  StyleSheet,
  Text,
  View,
  SafeAreaView,
  StatusBar,
  ScrollView,
  Switch,
} from 'react-native';

import { useTheme } from '../hooks';
import { spacing, borderRadius, fontSize } from '../constants/theme';

export const SettingsScreen: React.FC = () => {
  const { theme, isDark } = useTheme();

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <StatusBar barStyle={isDark ? 'light-content' : 'dark-content'} />

      {/* Header */}
      <View style={styles.header}>
        <Text style={[styles.title, { color: theme.colors.textPrimary }]}>
          Cài đặt
        </Text>
      </View>

      <ScrollView
        style={styles.content}
        contentContainerStyle={styles.contentContainer}
        showsVerticalScrollIndicator={false}
      >
        {/* Display Settings */}
        <View style={[styles.card, { 
          backgroundColor: theme.colors.card,
          borderColor: theme.colors.border,
        }]}>
          <Text style={[styles.sectionLabel, { color: theme.colors.textTertiary }]}>
            HIỂN THỊ
          </Text>
          
          <View style={[styles.settingRow, { borderBottomColor: theme.colors.divider }]}>
            <View style={styles.settingContent}>
              <Text style={[styles.settingTitle, { color: theme.colors.textPrimary }]}>
                Chế độ tối
              </Text>
              <Text style={[styles.settingSubtitle, { color: theme.colors.textSecondary }]}>
                Tự động theo hệ thống
              </Text>
            </View>
            <Switch
              value={isDark}
              disabled
              trackColor={{ false: theme.colors.border, true: theme.colors.accent }}
              thumbColor={theme.colors.card}
            />
          </View>

          <View style={styles.settingRow}>
            <View style={styles.settingContent}>
              <Text style={[styles.settingTitle, { color: theme.colors.textPrimary }]}>
                Cỡ chữ văn khấn
              </Text>
              <Text style={[styles.settingSubtitle, { color: theme.colors.textSecondary }]}>
                Vừa
              </Text>
            </View>
            <Text style={[styles.chevron, { color: theme.colors.textMuted }]}>›</Text>
          </View>
        </View>

        {/* About */}
        <View style={[styles.card, { 
          backgroundColor: theme.colors.card,
          borderColor: theme.colors.border,
        }]}>
          <Text style={[styles.sectionLabel, { color: theme.colors.textTertiary }]}>
            THÔNG TIN
          </Text>
          
          <View style={[styles.settingRow, { borderBottomColor: theme.colors.divider }]}>
            <Text style={[styles.settingTitle, { color: theme.colors.textPrimary }]}>
              Phiên bản
            </Text>
            <Text style={[styles.settingValue, { color: theme.colors.textSecondary }]}>
              1.0.0
            </Text>
          </View>

          <View style={styles.settingRow}>
            <Text style={[styles.settingTitle, { color: theme.colors.textPrimary }]}>
              Về ứng dụng
            </Text>
            <Text style={[styles.chevron, { color: theme.colors.textMuted }]}>›</Text>
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
    paddingVertical: spacing.md,
    borderWidth: 1,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 2,
    elevation: 1,
  },
  sectionLabel: {
    fontSize: fontSize.xs,
    fontWeight: '600',
    letterSpacing: 1,
    paddingHorizontal: spacing.xl,
    marginBottom: spacing.sm,
  },
  settingRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.xl,
    borderBottomWidth: 1,
    borderBottomColor: 'transparent',
  },
  settingContent: {
    flex: 1,
    marginRight: spacing.md,
  },
  settingTitle: {
    fontSize: fontSize.md,
    fontWeight: '400',
  },
  settingSubtitle: {
    fontSize: fontSize.sm,
    marginTop: 2,
  },
  settingValue: {
    fontSize: fontSize.md,
  },
  chevron: {
    fontSize: 20,
    fontWeight: '300',
  },
});
