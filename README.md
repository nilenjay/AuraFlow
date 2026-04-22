# AuraFlow — Immersive Ambience & Reflection

AuraFlow is a premium mini-experience designed to help users find calm through immersive ambiences and mindful journaling. Built with a focus on clean architecture, stable state management, and thoughtful UX.

## Features

- **Ambience Library**: Explore a curated list of 6 local ambiences with search and tag filtering.
- **Immersive Player**: A dedicated session player with high-quality looping audio and a subtle "breathing" visual animation.
- **Mini Player**: Persistent audio control that stays active across screens and app restarts.
- **Daily Reflection**: A beautifully designed journaling screen with mood tracking (Calm, Grounded, Energized, Sleepy).
- **Journal History**: Searchable history of past reflections with detailed insights.
- **Dark Mode**: A fully integrated dark mode powered by a dedicated BLoC (ThemeCubit).
- **Floating Navigation**: A custom, animated bottom navigation bar with integrated active state transitions.

##  Architecture & Tech Stack

The project follows **Clean Architecture** principles, separating the codebase into logical layers:

- **Data Layer**: Repositories and Models handling JSON parsing and local persistence.
- **Business Logic (BLoC)**: Pure BLoC implementation for all state management (No `ValueNotifier` or `ChangeNotifier`).
- **Presentation Layer**: Atomic widgets and screens designed for a premium, minimal aesthetic.

### Key Libraries:
- **State Management**: `flutter_bloc`
- **Navigation**: `go_router` (Declarative routing)
- **Audio**: `just_audio` (Stable, low-latency playback)
- **Persistence**: `hive` (Fast NoSQL database for session and journal storage)
- **Icons**: Custom PNG assets for a unique, premium nav feel.

## Design Decisions & Tradeoffs

### 1. Pure BLoC Pattern
To ensure scalability and testability, I transitioned all state management to BLoC. This includes the `ThemeCubit` for global theme switching, ensuring a single source of truth for the app's appearance.

### 2. Session Persistence
The `MiniPlayer` state is persisted using Hive. If the app is closed while a session is active, AuraFlow restores the player state on the next launch, ensuring the user doesn't lose their immersive flow.

### 3. Decoupled Session Timer
Unlike a standard music app, the "Session Timer" is decoupled from the audio file length. This allows for truly infinite looping ambiences while still providing a structured 3-minute (or custom) meditation window.

### 4. Custom Navigation
Instead of using the standard Material BottomNavigationBar, I built a custom floating pill navigation bar. This was a tradeoff in complexity but allowed for the specific "active circle" animation requested in the design specification.
