/**
 * Văn Khấn Categories Screen
 * Shows list of prayer categories (flat list from normalized data)
 */

import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  SafeAreaView,
  StatusBar,
  ScrollView,
  TouchableOpacity,
  TextInput,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';

import { useTheme, usePrayers } from '../hooks';
import { spacing, borderRadius, fontSize } from '../constants/theme';
import { VanKhanStackParamList } from '../navigation/VanKhanNavigator';

type NavigationProp = NativeStackNavigationProp<VanKhanStackParamList, 'Categories'>;

export const VanKhanCategoriesScreen: React.FC = () => {
  const { theme, isDark } = useTheme();
  const { categories, isLoading, getEventsByCategory, search } = usePrayers();
  const navigation = useNavigation<NavigationProp>();
  const [searchQuery, setSearchQuery] = useState('');
  const [showSearch, setShowSearch] = useState(false);

  const handleCategoryPress = (categoryId: string, categoryName: string) => {
    navigation.navigate('EventList', { categoryId, categoryName });
  };

  const handleSearchToggle = () => {
    setShowSearch(!showSearch);
    if (showSearch) {
      setSearchQuery('');
    }
  };

  const searchResults = searchQuery.trim() ? search(searchQuery) : [];

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
          <TouchableOpacity
            style={[styles.searchButton, { backgroundColor: theme.colors.backgroundSecondary }]}
            activeOpacity={0.7}
            onPress={handleSearchToggle}
          >
            <Text style={{ color: theme.colors.textTertiary, fontSize: 18 }}>
              {showSearch ? '✕' : '⌕'}
            </Text>
          </TouchableOpacity>
        </View>
      </View>

      {/* Search Bar */}
      {showSearch && (
        <View style={[styles.searchBar, { backgroundColor: theme.colors.backgroundSecondary }]}>
          <TextInput
            style={[styles.searchInput, { color: theme.colors.textPrimary }]}
            placeholder="Tìm kiếm văn khấn..."
            placeholderTextColor={theme.colors.textTertiary}
            value={searchQuery}
            onChangeText={setSearchQuery}
            autoFocus
          />
        </View>
      )}

      <ScrollView
        style={styles.content}
        contentContainerStyle={styles.contentContainer}
        showsVerticalScrollIndicator={false}
      >
        {isLoading ? (
          <Text style={[styles.loadingText, { color: theme.colors.textSecondary }]}>
            Đang tải...
          </Text>
        ) : searchQuery.trim() ? (
          /* Search Results */
          searchResults.length > 0 ? (
            <View style={[styles.listCard, {
              backgroundColor: theme.colors.card,
              borderColor: theme.colors.border,
            }]}>
              {searchResults.map((result, index) => (
                <TouchableOpacity
                  key={result.event.id}
                  style={[
                    styles.listItem,
                    index < searchResults.length - 1 && {
                      borderBottomWidth: 1,
                      borderBottomColor: theme.colors.divider,
                    },
                  ]}
                  activeOpacity={0.6}
                  onPress={() =>
                    navigation.navigate('EventDetail', {
                      eventId: result.event.id,
                      eventName: result.event.name,
                    })
                  }
                >
                  <View style={styles.listItemContent}>
                    <Text style={[styles.itemTitle, { color: theme.colors.textPrimary }]}>
                      {result.event.name}
                    </Text>
                    <Text style={[styles.itemSubtitle, { color: theme.colors.textSecondary }]}>
                      {result.event.prayers.length} bài khấn
                      {result.matchType === 'prayerContent' ? ' · Tìm thấy trong nội dung' : ''}
                    </Text>
                  </View>
                  <Text style={[styles.chevron, { color: theme.colors.textMuted }]}>›</Text>
                </TouchableOpacity>
              ))}
            </View>
          ) : (
            <Text style={[styles.loadingText, { color: theme.colors.textSecondary }]}>
              Không tìm thấy kết quả
            </Text>
          )
        ) : (
          /* Category List */
          <View style={[styles.listCard, {
            backgroundColor: theme.colors.card,
            borderColor: theme.colors.border,
          }]}>
            {categories.map((category, index) => {
              const eventCount = getEventsByCategory(category.id).length;
              return (
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
                  onPress={() => handleCategoryPress(category.id, category.name)}
                >
                  <View style={styles.listItemContent}>
                    <Text style={[styles.itemTitle, { color: theme.colors.textPrimary }]}>
                      {category.name}
                    </Text>
                    <Text style={[styles.itemSubtitle, { color: theme.colors.textSecondary }]}>
                      {eventCount} bài khấn
                    </Text>
                  </View>
                  <Text style={[styles.chevron, { color: theme.colors.textMuted }]}>›</Text>
                </TouchableOpacity>
              );
            })}
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
  searchBar: {
    marginHorizontal: spacing.xl,
    marginBottom: spacing.md,
    borderRadius: borderRadius.md,
    paddingHorizontal: spacing.lg,
  },
  searchInput: {
    height: 44,
    fontSize: fontSize.md,
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
