# Hostel Management System

A premium, responsive Hostel Management mobile application built with Flutter.

## 🚀 Features

### Core Management
*   **Secure Authentication**: Login system with validation (Email/Password).
*   **Dynamic Dashboard**: Real-time summary of total hostellers, pending dues, and room availability.
*   **Resident Management**: 
    *   Add/Update/Delete hostellers.
    *   Advanced Search and Filtering (All / Active / Inactive).
    *   Detailed resident profiles with payment tracking.
*   **Payment System**:
    *   Record payments with amount, date, and multiple modes (Online/Cash/Cheque).
    *   **Monthly Grouped History**: Beautifully organized payment records in resident profiles.
    *   **Pending Dues Logic**: Automatic identification of residents with unpaid rent for the current month.
*   **Smart Notifications**: 
    *   System alerts for pending dues.
    *   Mock "Send Reminder" functionality for resident communication.

### Premium Experience
*   **Modern UI**: High-end dark theme using Midnight Indigo and Vibrant Teal.
*   **Glassmorphism**: Premium translucent surfaces and modern card designs.
*   **Responsiveness**: Fully optimized for Mobile, Tablet, and Desktop using adaptive layouts.
*   **Micro-Animations**: Smooth transitions and interactive feedback using `flutter_animate`.

### Bonus Features
*   **PDF Export**: Generate professional payment reports for residents.
*   **Core Desugaring**: Configured Android Gradle for compatibility with latest notification libraries.

## 🛠️ Technical Stack
*   **Framework**: Flutter (Latest Stable)
*   **State Management**: `flutter_riverpod` (v2)
*   **Local Database**: `sqflite` (SQLite) for persistence
*   **Architecture**: Clean Architecture (Data, Domain, Presentation layers)
*   **Animations**: `flutter_animate`
*   **PDF Generation**: `pdf` & `printing`

## 📦 Setup Instructions

### Prerequisites
*   Flutter SDK (Stable channel)
*   Android Studio / VS Code
*   Java 17 (Required for Android builds)

### Installation
1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd hostel_managemet
    ```
2.  **Get dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the application**:
    ```bash
    flutter run
    ```

### Default Credentials
*   **Email**: `admin@hostel.com`
*   **Password**: `admin123`

## 🏗️ Folder Structure
```text
lib/
├── core/             # Theme, Utilities (Responsive, PDF), General Widgets
├── data/             # Models, Local DB (SQLite), Repositories
└── presentation/
    ├── providers/    # Riverpod State Notifiers
    └── screens/      # All App Screens (Dashboard, Auth, Payments, etc.)
```

## 📝 Submission Details
*   **Developer**: Antigravity AI
*   **APK**: Located in `build/app/outputs/flutter-apk/app-debug.apk` (after run)
