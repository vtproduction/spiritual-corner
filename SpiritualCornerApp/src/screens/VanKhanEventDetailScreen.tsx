/**
 * Văn Khấn Event Detail Screen
 * Shows event detail/prepare sections and prayer list.
 * If only 1 prayer, offers direct CTA. If >1, shows selectable list.
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
import { useNavigation, useRoute, RouteProp } from '@react-navigation/native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';

import { useTheme, usePrayers } from '../hooks';
import { spacing, borderRadius, fontSize } from '../constants/theme';
import { VanKhanStackParamList } from '../navigation/VanKhanNavigator';

type NavigationProp = NativeStackNavigationProp<VanKhanStackParamList, 'EventDetail'>;
type RouteType = RouteProp<VanKhanStackParamList, 'EventDetail'>;

export const VanKhanEventDetailScreen: React.FC = () => {
  const { theme, isDark } = useTheme();
  const navigation = useNavigation<NavigationProp>();
  const route = useRoute<RouteType>();
  const { eventId, eventName } = route.params;
  const { getEvent } = usePrayers();

  const event = getEvent(eventId);

  const handleBack = () => {
    navigation.goBack();
  };

  const handleOpenPrayer = (prayerId: string, prayerName: string) => {
    navigation.navigate('Teleprompter', {
      eventId,
      prayerId,
      prayerName,
    });
  };

  if (!event) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: theme.colors.background }]}>
        <Text style={{ color: theme.colors.textSecondary, textAlign: 'center', marginTop: 40 }}>
          Không tìm thấy dữ liệu
        </Text>
      </SafeAreaView>
    );
  }

  const hasSinglePrayer = event.prayers.length === 1;

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <StatusBar barStyle={isDark ? 'light-content' : 'dark-content'} />

      {/* Header with Back Button */}
      <View style={styles.header}>
        <View style={styles.headerRow}>
          <TouchableOpacity onPress={handleBack} style={styles.backButton} activeOpacity={0.6}>
            <Text style={[styles.backIcon, { color: theme.colors.textSecondary }]}>‹</Text>
          </TouchableOpacity>
          <View style={styles.headerTitles}>
            <Text style={[styles.breadcrumb, { color: theme.colors.textTertiary }]} numberOfLines={1}>
              Chi tiết
            </Text>
            <Text style={[styles.title, { color: theme.colors.textPrimary }]} numberOfLines={1}>
              {eventName}
            </Text>
          </View>
        </View>
      </View>

      <ScrollView
        style={styles.content}
        contentContainerStyle={styles.contentContainer}
        showsVerticalScrollIndicator={false}
      >
        {/* Event Header Card */}
        <View style={[styles.headerCard, {
          backgroundColor: theme.colors.card,
          borderColor: theme.colors.border,
        }]}>
          <View style={[styles.iconContainer, { backgroundColor: theme.colors.backgroundSecondary }]}>
            <Text style={[styles.packageIcon, { color: theme.colors.accent }]}>☰</Text>
          </View>
          <View style={styles.headerCardContent}>
            <Text style={[styles.packageTitle, { color: theme.colors.textPrimary }]}>
              {event.name}
            </Text>
            <View style={styles.metaRow}>
              <Text style={[styles.metaText, { color: theme.colors.textTertiary }]}>
                {event.prayers.length} bài khấn
              </Text>
              {event.isDaily && (
                <View style={[styles.metaBadge, { backgroundColor: theme.colors.accent + '20' }]}>
                  <Text style={[styles.metaBadgeText, { color: theme.colors.accent }]}>
                    Hằng ngày
                  </Text>
                </View>
              )}
              {event.isMonthly && (
                <View style={[styles.metaBadge, { backgroundColor: theme.colors.accent + '20' }]}>
                  <Text style={[styles.metaBadgeText, { color: theme.colors.accent }]}>
                    Hằng tháng
                  </Text>
                </View>
              )}
            </View>
          </View>
        </View>

        {/* Detail / Origin Section */}
        {event.detail ? (
          <View style={[styles.sectionCard, {
            backgroundColor: theme.colors.card,
            borderColor: theme.colors.border,
          }]}>
            <View style={styles.sectionHeader}>
              <View style={[styles.sectionIconContainer, { backgroundColor: theme.colors.backgroundSecondary }]}>
                <Text style={[styles.sectionIcon, { color: theme.colors.textTertiary }]}>○</Text>
              </View>
              <Text style={[styles.sectionTitle, { color: theme.colors.textPrimary }]}>
                XUẤT XỨ
              </Text>
            </View>
            <Text style={[styles.sectionContent, { color: theme.colors.textSecondary }]}>
              {event.detail}
            </Text>
          </View>
        ) : null}

        {/* Prepare / Offerings Section */}
        {event.prepare ? (
          <View style={[styles.sectionCard, {
            backgroundColor: theme.colors.card,
            borderColor: theme.colors.border,
          }]}>
            <View style={styles.sectionHeader}>
              <View style={[styles.sectionIconContainer, { backgroundColor: theme.colors.backgroundSecondary }]}>
                <Text style={[styles.sectionIcon, { color: theme.colors.textTertiary }]}>◎</Text>
              </View>
              <Text style={[styles.sectionTitle, { color: theme.colors.textPrimary }]}>
                SẮM LỄ
              </Text>
            </View>
            <Text style={[styles.sectionContent, { color: theme.colors.textSecondary }]}>
              {event.prepare}
            </Text>
          </View>
        ) : null}

        {/* Prayers List (only shown when >1 prayer) */}
        {!hasSinglePrayer && (
          <View style={[styles.sectionCard, {
            backgroundColor: theme.colors.card,
            borderColor: theme.colors.border,
          }]}>
            <View style={styles.sectionHeader}>
              <View style={[styles.sectionIconContainer, { backgroundColor: theme.colors.backgroundSecondary }]}>
                <Text style={[styles.sectionIcon, { color: theme.colors.textTertiary }]}>☰</Text>
              </View>
              <Text style={[styles.sectionTitle, { color: theme.colors.textPrimary }]}>
                VĂN KHẤN
              </Text>
            </View>
            {event.prayers.map((prayer, index) => (
              <TouchableOpacity
                key={prayer.id}
                style={[
                  styles.prayerItem,
                  index < event.prayers.length - 1 && {
                    borderBottomWidth: 1,
                    borderBottomColor: theme.colors.divider,
                  },
                ]}
                activeOpacity={0.6}
                onPress={() => handleOpenPrayer(prayer.id, prayer.name)}
              >
                <View style={styles.prayerItemContent}>
                  <Text style={[styles.prayerName, { color: theme.colors.textPrimary }]}>
                    {prayer.name}
                  </Text>
                  {prayer.intro ? (
                    <Text
                      style={[styles.prayerIntro, { color: theme.colors.textSecondary }]}
                      numberOfLines={1}
                    >
                      {prayer.intro}
                    </Text>
                  ) : null}
                </View>
                <Text style={[styles.chevron, { color: theme.colors.textMuted }]}>›</Text>
              </TouchableOpacity>
            ))}
          </View>
        )}

        {/* Bottom padding for CTA */}
        <View style={{ height: 80 }} />
      </ScrollView>

      {/* Read Prayer CTA Button */}
      <View style={[styles.ctaContainer, { backgroundColor: theme.colors.background }]}>
        {hasSinglePrayer ? (
          <TouchableOpacity
            style={[styles.ctaButton, { backgroundColor: theme.colors.accent }]}
            onPress={() => handleOpenPrayer(event.prayers[0].id, event.prayers[0].name)}
            activeOpacity={0.8}
          >
            <Text style={styles.ctaIcon}>☰</Text>
            <Text style={styles.ctaText}>Đọc văn khấn</Text>
          </TouchableOpacity>
        ) : (
          <View style={[styles.ctaHint]}>
            <Text style={[styles.ctaHintText, { color: theme.colors.textTertiary }]}>
              Chọn một bài văn khấn ở trên để đọc
            </Text>
          </View>
        )}
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    paddingHorizontal: spacing.xl,
    paddingTop: spacing.md,
    paddingBottom: spacing.sm,
  },
  headerRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  backButton: {
    width: 32,
    height: 32,
    justifyContent: 'center',
    alignItems: 'center',
    marginLeft: -spacing.sm,
  },
  backIcon: {
    fontSize: 32,
    fontWeight: '300',
    marginTop: -4,
  },
  headerTitles: {
    flex: 1,
    marginLeft: spacing.sm,
  },
  breadcrumb: {
    fontSize: fontSize.xs,
    marginBottom: 2,
  },
  title: {
    fontSize: fontSize.xl,
    fontWeight: '600',
  },
  content: {
    flex: 1,
  },
  contentContainer: {
    padding: spacing.xl,
    gap: spacing.lg,
  },
  headerCard: {
    borderRadius: borderRadius.lg,
    borderWidth: 1,
    padding: spacing.xl,
    flexDirection: 'row',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 2,
    elevation: 1,
  },
  iconContainer: {
    width: 48,
    height: 48,
    borderRadius: borderRadius.md,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: spacing.lg,
  },
  packageIcon: {
    fontSize: 24,
  },
  headerCardContent: {
    flex: 1,
  },
  packageTitle: {
    fontSize: fontSize.lg,
    fontWeight: '600',
    marginBottom: 4,
  },
  metaRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  metaText: {
    fontSize: fontSize.sm,
  },
  metaBadge: {
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 6,
  },
  metaBadgeText: {
    fontSize: fontSize.xs,
    fontWeight: '500',
  },
  sectionCard: {
    borderRadius: borderRadius.lg,
    borderWidth: 1,
    padding: spacing.xl,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 2,
    elevation: 1,
  },
  sectionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  sectionIconContainer: {
    width: 32,
    height: 32,
    borderRadius: borderRadius.full,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: spacing.md,
  },
  sectionIcon: {
    fontSize: 14,
  },
  sectionTitle: {
    fontSize: fontSize.sm,
    fontWeight: '600',
    letterSpacing: 0.5,
  },
  sectionContent: {
    fontSize: fontSize.md,
    lineHeight: 24,
  },
  prayerItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: spacing.md,
  },
  prayerItemContent: {
    flex: 1,
    marginRight: spacing.md,
  },
  prayerName: {
    fontSize: fontSize.md,
    fontWeight: '500',
  },
  prayerIntro: {
    fontSize: fontSize.sm,
    marginTop: 2,
  },
  chevron: {
    fontSize: 24,
    fontWeight: '300',
  },
  ctaContainer: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    padding: spacing.xl,
    paddingBottom: spacing.xxl,
  },
  ctaButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: spacing.lg,
    borderRadius: borderRadius.lg,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  ctaIcon: {
    fontSize: 18,
    color: '#FFFFFF',
    marginRight: spacing.sm,
  },
  ctaText: {
    fontSize: fontSize.md,
    fontWeight: '600',
    color: '#FFFFFF',
  },
  ctaHint: {
    alignItems: 'center',
    paddingVertical: spacing.md,
  },
  ctaHintText: {
    fontSize: fontSize.sm,
  },
});
