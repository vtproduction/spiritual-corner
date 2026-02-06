# Spiritual Corner (Góc Tâm Linh)

A React Native mobile app serving spiritual and cultural needs for Vietnamese users.

## Features

- 📿 **Văn khấn (Prayers)** – Offline prayer texts with teleprompter reading mode
- 📅 **Lịch Âm (Lunar Calendar)** – Vietnamese lunar calendar reference *(Coming Soon)*
- 🌙 **AI Astrology** – Astrological chart interpretation *(Coming Soon)*

## Tech Stack

- **Framework**: React Native (Bare) + TypeScript
- **Navigation**: React Navigation
- **State**: Zustand
- **Storage**: MMKV
- **Search**: MiniSearch (offline full-text)

## Getting Started

### Prerequisites

- Node.js 18+
- React Native CLI
- Xcode (for iOS)
- Android Studio (for Android)

### Installation

```bash
# Install dependencies
npm install

# iOS
cd ios && pod install && cd ..
npx react-native run-ios

# Android
npx react-native run-android
```

## Project Structure

```
src/
├── app/          # App entry, navigation, providers
├── features/     # Feature modules
├── shared/       # Shared components, hooks, utils
└── data/         # Data models and services
```

## License

Private – VTProduction
