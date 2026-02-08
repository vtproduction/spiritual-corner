/**
 * Văn Khấn Packages Screen
 * Shows list of prayer packages within a category
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

type NavigationProp = NativeStackNavigationProp<VanKhanStackParamList, 'Packages'>;
type RouteType = RouteProp<VanKhanStackParamList, 'Packages'>;

export const VanKhanPackagesScreen: React.FC = () => {
  const { theme, isDark } = useTheme();
  const navigation = useNavigation<NavigationProp>();
  const route = useRoute<RouteType>();
  const { categoryId, categoryTitle } = route.params;
  const { getChildren } = usePrayers();

  const packages = getChildren(categoryId);

  const handlePackagePress = (packageId: string, title: string) => {
    navigation.navigate('Detail', { packageId, packageTitle: title });
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
              {categoryTitle}
            </Text>
            <Text style={[styles.title, { color: theme.colors.textPrimary }]}>
              Chọn bài văn khấn
            </Text>
          </View>
          <TouchableOpacity 
            style={[styles.searchButton, { backgroundColor: theme.colors.backgroundSecondary }]}
            activeOpacity={0.7}
          >
            <Text style={{ color: theme.colors.textTertiary, fontSize: 18 }}>⌕</Text>
          </TouchableOpacity>
        </View>
      </View>

      {/* Package Count */}
      <View style={styles.countRow}>
        <Text style={[styles.countText, { color: theme.colors.textSecondary }]}>
          {packages.length} bài văn khấn
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
          {packages.map((pkg, index) => (
            <TouchableOpacity
              key={pkg.id}
              style={[
                styles.listItem,
                index < packages.length - 1 && {
                  borderBottomWidth: 1,
                  borderBottomColor: theme.colors.divider,
                },
              ]}
              activeOpacity={0.6}
              onPress={() => handlePackagePress(pkg.id, pkg.title)}
            >
              <View style={styles.listItemContent}>
                <Text style={[styles.itemTitle, { color: theme.colors.textPrimary }]}>
                  {pkg.title}
                </Text>
                {pkg.content ? (
                  <Text 
                    style={[styles.itemSubtitle, { color: theme.colors.textSecondary }]}
                    numberOfLines={1}
                  >
                    {pkg.content.substring(0, 50)}...
                  </Text>
                ) : null}
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
  searchButton: {
    width: 40,
    height: 40,
    borderRadius: borderRadius.full,
    justifyContent: 'center',
    alignItems: 'center',
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
  itemSubtitle: {
    fontSize: fontSize.sm,
    marginTop: 2,
  },
  chevron: {
    fontSize: 24,
    fontWeight: '300',
  },
});
