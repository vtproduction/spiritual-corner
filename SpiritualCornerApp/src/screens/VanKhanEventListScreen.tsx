/**
 * Văn Khấn Event List Screen
 * Shows list of events within a category, with badges for daily/monthly/has-dates.
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

type NavigationProp = NativeStackNavigationProp<VanKhanStackParamList, 'EventList'>;
type RouteType = RouteProp<VanKhanStackParamList, 'EventList'>;

export const VanKhanEventListScreen: React.FC = () => {
  const { theme, isDark } = useTheme();
  const navigation = useNavigation<NavigationProp>();
  const route = useRoute<RouteType>();
  const { categoryId, categoryName } = route.params;
  const { getEventsByCategory } = usePrayers();

  const events = getEventsByCategory(categoryId);

  const handleEventPress = (eventId: string, eventName: string) => {
    navigation.navigate('EventDetail', { eventId, eventName });
  };

  const handleBack = () => {
    navigation.goBack();
  };

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
              {categoryName}
            </Text>
            <Text style={[styles.title, { color: theme.colors.textPrimary }]}>
              Chọn bài văn khấn
            </Text>
          </View>
        </View>
      </View>

      {/* Event Count */}
      <View style={styles.countRow}>
        <Text style={[styles.countText, { color: theme.colors.textSecondary }]}>
          {events.length} bài văn khấn
        </Text>
      </View>

      <ScrollView
        style={styles.content}
        contentContainerStyle={styles.contentContainer}
        showsVerticalScrollIndicator={false}
      >
        <View style={[styles.listCard, {
          backgroundColor: theme.colors.card,
          borderColor: theme.colors.border,
        }]}>
          {events.map((event, index) => (
            <TouchableOpacity
              key={event.id}
              style={[
                styles.listItem,
                index < events.length - 1 && {
                  borderBottomWidth: 1,
                  borderBottomColor: theme.colors.divider,
                },
              ]}
              activeOpacity={0.6}
              onPress={() => handleEventPress(event.id, event.name)}
            >
              <View style={styles.listItemContent}>
                <Text style={[styles.itemTitle, { color: theme.colors.textPrimary }]}>
                  {event.name}
                </Text>
                {/* Badges */}
                <View style={styles.badgeRow}>
                  {event.isDaily && (
                    <View style={[styles.badge, { backgroundColor: theme.colors.accent + '20' }]}>
                      <Text style={[styles.badgeText, { color: theme.colors.accent }]}>
                        Hằng ngày
                      </Text>
                    </View>
                  )}
                  {event.isMonthly && (
                    <View style={[styles.badge, { backgroundColor: theme.colors.accent + '20' }]}>
                      <Text style={[styles.badgeText, { color: theme.colors.accent }]}>
                        Hằng tháng
                      </Text>
                    </View>
                  )}
                  {event.prayDateIDs.length > 0 && (
                    <View style={[styles.badge, { backgroundColor: theme.colors.backgroundSecondary }]}>
                      <Text style={[styles.badgeText, { color: theme.colors.textSecondary }]}>
                        Có ngày lễ
                      </Text>
                    </View>
                  )}
                  <Text style={[styles.prayerCount, { color: theme.colors.textTertiary }]}>
                    {event.prayers.length} bài
                  </Text>
                </View>
              </View>
              <Text style={[styles.chevron, { color: theme.colors.textMuted }]}>›</Text>
            </TouchableOpacity>
          ))}
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
  countRow: {
    paddingHorizontal: spacing.xl,
    paddingBottom: spacing.sm,
  },
  countText: {
    fontSize: fontSize.sm,
  },
  content: {
    flex: 1,
  },
  contentContainer: {
    padding: spacing.xl,
    paddingTop: spacing.sm,
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
  badgeRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 6,
    flexWrap: 'wrap',
    gap: 6,
  },
  badge: {
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 6,
  },
  badgeText: {
    fontSize: fontSize.xs,
    fontWeight: '500',
  },
  prayerCount: {
    fontSize: fontSize.xs,
  },
  chevron: {
    fontSize: 24,
    fontWeight: '300',
  },
});
