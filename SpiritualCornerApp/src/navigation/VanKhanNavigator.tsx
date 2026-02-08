/**
 * Văn Khấn Stack Navigator
 * Handles drill-down navigation: Categories → Packages → Detail
 */

import React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

import { VanKhanCategoriesScreen } from '../screens/VanKhanCategoriesScreen';
import { VanKhanPackagesScreen } from '../screens/VanKhanPackagesScreen';
import { VanKhanDetailScreen } from '../screens/VanKhanDetailScreen';
import { useTheme } from '../hooks';

export type VanKhanStackParamList = {
  Categories: undefined;
  Packages: { categoryId: string; categoryTitle: string };
  Detail: { packageId: string; packageTitle: string };
};

const Stack = createNativeStackNavigator<VanKhanStackParamList>();

export const VanKhanNavigator: React.FC = () => {
  const { theme, isDark } = useTheme();

  return (
    <Stack.Navigator
      screenOptions={{
        headerShown: false,
        contentStyle: { backgroundColor: theme.colors.background },
        animation: 'slide_from_right',
      }}>
      <Stack.Screen name="Categories" component={VanKhanCategoriesScreen} />
      <Stack.Screen name="Packages" component={VanKhanPackagesScreen} />
      <Stack.Screen name="Detail" component={VanKhanDetailScreen} />
    </Stack.Navigator>
  );
};
