/**
 * Văn Khấn Stack Navigator
 * Handles drill-down navigation: Categories → Event List → Event Detail → Teleprompter
 */

import React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

import { VanKhanCategoriesScreen } from '../screens/VanKhanCategoriesScreen';
import { VanKhanEventListScreen } from '../screens/VanKhanEventListScreen';
import { VanKhanEventDetailScreen } from '../screens/VanKhanEventDetailScreen';
import { TeleprompterScreen } from '../screens/TeleprompterScreen';
import { useTheme } from '../hooks';

export type VanKhanStackParamList = {
  Categories: undefined;
  EventList: { categoryId: string; categoryName: string };
  EventDetail: { eventId: string; eventName: string };
  Teleprompter: { eventId: string; prayerId: string; prayerName: string };
};

const Stack = createNativeStackNavigator<VanKhanStackParamList>();

export const VanKhanNavigator: React.FC = () => {
  const { theme } = useTheme();

  return (
    <Stack.Navigator
      screenOptions={{
        headerShown: false,
        contentStyle: { backgroundColor: theme.colors.background },
        animation: 'slide_from_right',
      }}>
      <Stack.Screen name="Categories" component={VanKhanCategoriesScreen} />
      <Stack.Screen name="EventList" component={VanKhanEventListScreen} />
      <Stack.Screen name="EventDetail" component={VanKhanEventDetailScreen} />
      <Stack.Screen
        name="Teleprompter"
        component={TeleprompterScreen}
        options={{
          animation: 'slide_from_bottom',
          presentation: 'fullScreenModal',
        }}
      />
    </Stack.Navigator>
  );
};
