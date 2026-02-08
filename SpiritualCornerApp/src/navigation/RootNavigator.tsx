import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Text, StyleSheet } from 'react-native';

import { HomeScreen, SettingsScreen } from '../screens';
import { VanKhanNavigator } from './VanKhanNavigator';
import { useTheme } from '../hooks';

export type RootTabParamList = {
  Home: undefined;
  VanKhan: undefined;
  Settings: undefined;
};

const Tab = createBottomTabNavigator<RootTabParamList>();

// Simple icon component using text (will be replaced with proper icons later)
const TabIcon: React.FC<{ name: string; focused: boolean; color: string }> = ({
  name,
  color,
}) => {
  const iconMap: Record<string, string> = {
    home: '⌂',
    book: '☰',
    settings: '⚙',
  };

  return (
    <Text style={[styles.icon, { color }]}>
      {iconMap[name] || '○'}
    </Text>
  );
};

export const RootNavigator: React.FC = () => {
  const { theme } = useTheme();

  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: false,
        tabBarStyle: {
          backgroundColor: theme.colors.tabBar,
          borderTopWidth: 1,
          borderTopColor: theme.colors.tabBarBorder,
          height: 60,
          paddingBottom: 8,
          paddingTop: 8,
        },
        tabBarActiveTintColor: theme.colors.tabActive,
        tabBarInactiveTintColor: theme.colors.tabInactive,
        tabBarLabelStyle: {
          fontSize: 10,
          fontWeight: '600',
          marginTop: 2,
        },
      }}>
      <Tab.Screen
        name="Home"
        component={HomeScreen}
        options={{
          tabBarLabel: 'Trang chủ',
          tabBarIcon: ({ focused, color }) => (
            <TabIcon name="home" focused={focused} color={color} />
          ),
        }}
      />
      <Tab.Screen
        name="VanKhan"
        component={VanKhanNavigator}
        options={{
          tabBarLabel: 'Văn khấn',
          tabBarIcon: ({ focused, color }) => (
            <TabIcon name="book" focused={focused} color={color} />
          ),
        }}
      />
      <Tab.Screen
        name="Settings"
        component={SettingsScreen}
        options={{
          tabBarLabel: 'Cài đặt',
          tabBarIcon: ({ focused, color }) => (
            <TabIcon name="settings" focused={focused} color={color} />
          ),
        }}
      />
    </Tab.Navigator>
  );
};

const styles = StyleSheet.create({
  icon: {
    fontSize: 20,
    fontWeight: '400',
  },
});
