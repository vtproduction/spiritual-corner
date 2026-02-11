/**
 * usePrayers Hook
 * React hook for accessing the normalized prayer data.
 *
 * Provides categories, event lookups, prayer lookups, and search.
 * Data is loaded once and memoized in the service layer.
 */

import { useState, useEffect, useCallback } from 'react';
import {
  Category,
  EventItem,
  Prayer,
  SearchResult,
} from '../types/prayer';
import {
  getCategories,
  getEventsByCategory,
  getEvent,
  getPrayer,
  searchEvents,
} from '../services/prayerService';

interface UsePrayersResult {
  categories: Category[];
  isLoading: boolean;
  getEventsByCategory: (categoryId: string) => EventItem[];
  getEvent: (eventId: string) => EventItem | null;
  getPrayer: (eventId: string, prayerId: string) => Prayer | null;
  search: (query: string) => SearchResult[];
}

export const usePrayers = (): UsePrayersResult => {
  const [categories, setCategories] = useState<Category[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    setIsLoading(true);
    try {
      setCategories(getCategories());
    } finally {
      setIsLoading(false);
    }
  }, []);

  const getEventsByCategoryCb = useCallback(
    (categoryId: string): EventItem[] => getEventsByCategory(categoryId),
    [],
  );

  const getEventCb = useCallback(
    (eventId: string): EventItem | null => getEvent(eventId),
    [],
  );

  const getPrayerCb = useCallback(
    (eventId: string, prayerId: string): Prayer | null => getPrayer(eventId, prayerId),
    [],
  );

  const searchCb = useCallback(
    (query: string): SearchResult[] => searchEvents(query),
    [],
  );

  return {
    categories,
    isLoading,
    getEventsByCategory: getEventsByCategoryCb,
    getEvent: getEventCb,
    getPrayer: getPrayerCb,
    search: searchCb,
  };
};
