/**
 * Văn Khấn Detail Screen
 * Shows prayer package content with sections (Xuất xứ, Sắm lễ, Văn khấn)
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

type NavigationProp = NativeStackNavigationProp<VanKhanStackParamList, 'Detail'>;
type RouteType = RouteProp<VanKhanStackParamList, 'Detail'>;

export const VanKhanDetailScreen: React.FC = () => {
  const { theme, isDark } = useTheme();
  const navigation = useNavigation<NavigationProp>();
  const route = useRoute<RouteType>();
  const { packageId, packageTitle } = route.params;
  const { getChildren, getItemById } = usePrayers();

  const packageItem = getItemById(packageId);
  const sections = getChildren(packageId);

  const handleBack = () => {
    navigation.goBack();
  };

  // Get section icon based on title
  const getSectionIcon = (title: string): string => {
    const lowerTitle = title.toLowerCase();
    if (lowerTitle.includes('xuất xứ') || lowerTitle.includes('xuất xu')) return '○';
    if (lowerTitle.includes('sắm lễ') || lowerTitle.includes('sam le')) return '◎';
    if (lowerTitle.includes('văn khấn') || lowerTitle.includes('van khan')) return '☰';
    return '•';
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
              {packageItem?.title || 'Chi tiết'}
            </Text>
            <Text style={[styles.title, { color: theme.colors.textPrimary }]} numberOfLines={1}>
              {packageTitle}
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

      <ScrollView
        style={styles.content}
        contentContainerStyle={styles.contentContainer}
        showsVerticalScrollIndicator={false}
      >
        {/* Package Header Card */}
        <View style={[styles.headerCard, { 
          backgroundColor: theme.colors.card,
          borderColor: theme.colors.border,
        }]}>
          <View style={[styles.iconContainer, { backgroundColor: theme.colors.backgroundSecondary }]}>
            <Text style={[styles.packageIcon, { color: theme.colors.accent }]}>☰</Text>
          </View>
          <View style={styles.headerCardContent}>
            <Text style={[styles.packageTitle, { color: theme.colors.textPrimary }]}>
              {packageTitle}
            </Text>
            <View style={styles.metaRow}>
              <Text style={[styles.metaText, { color: theme.colors.textTertiary }]}>
                {sections.length} phần
              </Text>
            </View>
          </View>
        </View>

        {/* Content Sections */}
        {sections.map((section) => (
          <View
            key={section.id}
            style={[styles.sectionCard, { 
              backgroundColor: theme.colors.card,
              borderColor: theme.colors.border,
            }]}
          >
            <View style={styles.sectionHeader}>
              <View style={[styles.sectionIconContainer, { backgroundColor: theme.colors.backgroundSecondary }]}>
                <Text style={[styles.sectionIcon, { color: theme.colors.textTertiary }]}>
                  {getSectionIcon(section.title)}
                </Text>
              </View>
              <Text style={[styles.sectionTitle, { color: theme.colors.textPrimary }]}>
                {section.title.toUpperCase()}
              </Text>
            </View>
            <Text style={[styles.sectionContent, { color: theme.colors.textSecondary }]}>
              {section.content || 'Nội dung đang được cập nhật...'}
            </Text>
          </View>
        ))}

        {/* If no sections but has content */}
        {sections.length === 0 && packageItem?.content && (
          <View style={[styles.sectionCard, { 
            backgroundColor: theme.colors.card,
            borderColor: theme.colors.border,
          }]}>
            <Text style={[styles.sectionContent, { color: theme.colors.textSecondary }]}>
              {packageItem.content}
            </Text>
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
  },
  metaText: {
    fontSize: fontSize.sm,
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
});
