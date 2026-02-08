/**
 * usePrayers Hook
 * React hook for accessing prayer data with loading state
 */

import { useState, useEffect, useCallback } from 'react';
import {
  PrayerItem,
  PrayerCategory,
} from '../types/prayer';
import {
  getPrayerCategories,
  getChildrenByParentId,
  getPrayerById,
  getAllPrayers,
  searchPrayers,
} from '../services/prayerService';

interface UsePrayersResult {
  categories: PrayerCategory[];
  isLoading: boolean;
  getChildren: (parentId: string) => PrayerItem[];
  getItemById: (id: string) => PrayerItem | null;
  search: (query: string) => PrayerItem[];
  allPrayers: PrayerItem[];
}

export const usePrayers = (): UsePrayersResult => {
  const [categories, setCategories] = useState<PrayerCategory[]>([]);
  const [allPrayers, setAllPrayers] = useState<PrayerItem[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Load data on mount
    const loadData = () => {
      setIsLoading(true);
      try {
        setCategories(getPrayerCategories());
        setAllPrayers(getAllPrayers());
      } finally {
        setIsLoading(false);
      }
    };
    loadData();
  }, []);

  const getChildren = useCallback((parentId: string): PrayerItem[] => {
    return getChildrenByParentId(parentId);
  }, []);

  const getItemById = useCallback((id: string): PrayerItem | null => {
    return getPrayerById(id);
  }, []);

  const search = useCallback((query: string): PrayerItem[] => {
    return searchPrayers(query);
  }, []);

  return {
    categories,
    isLoading,
    getChildren,
    getItemById,
    search,
    allPrayers,
  };
};
