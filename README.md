# Academic Planner for IT

This Flutter-based application helps IT students efficiently manage their academic schedules, deadlines, and events. It supports Excel import for bulk event creation and integrates with an OCR system for extracting event details from images.

## Key Features
- **Event Management**: Create, update, and delete academic events with ease.
- **Excel Import**: Bulk import events from Excel files for efficient data entry.
- **Reminders**: Local notifications for upcoming deadlines.
- **Database Storage**: Persist data using an SQLite database.
- **Share Events**: Share Events from List and Notifications
- ** Search**: Search by Event Name
- **Pagination**: Pagination for easy loading

## Installation

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio or Visual Studio Code with Flutter plugins

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/Sharma-Shivam2021/academic_planner_for_it.git
   ```
2. Navigate into project directory
   ```bash
   cd acaademic_planner_for_it
   ```
3. Fetch the dependencies
   ```bash
   flutter pub get
   ```
4. Run the app
   ```bash
   flutter run
   ```
## State Management
This app uses Riverpod for efficient state management. Both classic and generator methods are used for handling state across the app.

## Database
The app uses SQLite to store events locally. Imported Excel events are stored separately to ensure regular and imported events are easy to manage.

## Packages Used
### flutter_riverpod:
State management solution.
### sqflite: 
SQLite database integration.
### intl:
Date formatting and localization support.
### flutter_local_notifications:
Notification scheduling.

## Project Structure
```
lib\/
├── features/
│   ├── splash_screen/
│   │   └── view
│   ├── home_screen/
│   │   ├── models
│   │   ├── view_models
│   │   ├── view
│   │   └── widgets
│   ├── import_excel/
│   │   ├── models
│   │   ├── view_models
│   │   ├── view
│   │   └── widgets
│   └── settings_screen/
│       ├── models
│       ├── view_models
│       └── view
├── utilities/
│   ├── common_widgets
│   ├── constants
│   ├── routes
│   ├── seervices
│   └── theme
└── main.dart 
```

