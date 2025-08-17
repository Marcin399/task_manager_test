# Task Manager

A task management application built with Flutter using Clean Architecture.

## Features

- ✅ **Task Management**: Create, edit, delete and mark tasks as completed
- 📅 **Deadlines**: Set deadlines with visual indication of overdue tasks
- 🔔 **Notifications**: Reminders for upcoming deadlines
- 🎯 **Priorities**: Categorize tasks by importance (low, medium, high, urgent)
- 📊 **Statistics**: Overview of productivity and task completion trends
- 💾 **Local Storage**: All data stored locally in SQLite

## Architecture

The project uses **Clean Architecture** with layer separation:

```
lib/
├── core/               # Shared components
│   ├── constants/      # Application constants
│   ├── di/             # Dependency Injection
│   ├── errors/         # Error handling
│   ├── storage/        # Database configuration
│   └── utils/          # Helper utilities
├── data/               # Data layer
│   ├── datasources/    # Data sources (local)
│   ├── models/         # Data models
│   └── repositories/   # Repository implementations
├── domain/             # Business layer
│   ├── entities/       # Business entities
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Use cases
└── features/           # Presentation layer
    ├── tasks/          # Tasks module
    ├── statistics/     # Statistics module
    └── notifications/  # Notifications module
```

## Technologies

- **Flutter** 3.8.1+
- **Provider** - State Management
- **SQLite** - Local database
- **Get It + Injectable** - Dependency Injection
- **Freezed** - Code generation for models
- **Flutter Local Notifications** - Local notifications

## Installation

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd task_manager
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run application**
   ```bash
   flutter run
   ```

## Testing

```bash
# Run tests
flutter test

# Code analysis
flutter analyze
```

## Database Structure

### `tasks` Table
- `id` (TEXT PRIMARY KEY)
- `title` (TEXT NOT NULL)
- `description` (TEXT)
- `deadline` (INTEGER NOT NULL)
- `isCompleted` (INTEGER DEFAULT 0)
- `createdAt` (INTEGER NOT NULL)
- `updatedAt` (INTEGER NOT NULL)
- `reminderMinutes` (INTEGER)
- `priority` (INTEGER DEFAULT 0)

### `task_statistics` Table
- `id` (TEXT PRIMARY KEY)
- `taskId` (TEXT NOT NULL)
- `completedAt` (INTEGER NOT NULL)
- `dayOfWeek` (INTEGER NOT NULL)

## Key Patterns

- **Repository Pattern** - Data access abstraction
- **Result Pattern** - Success/error handling
- **Provider Pattern** - State management
- **Dependency Injection** - Dependency inversion

