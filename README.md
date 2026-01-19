# 🎓 City University Student Portal

A comprehensive Flutter-based student management system with Firebase backend integration for authentication, course management, timetables, notes, and assignments.

![Flutter](https://img.shields.io/badge/Flutter-3.32.6-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-Integrated-orange.svg)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20iOS%20%7C%20Android%20%7C%20macOS-lightgrey.svg)

---

## 📋 Table of Contents

- [Features](#-features)
- [Screenshots](#-screenshots)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
- [Test Credentials](#-test-credentials)
- [Project Structure](#-project-structure)
- [Firebase Setup](#-firebase-setup)
- [Running the App](#-running-the-app)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

### 🔐 Authentication System
- Student registration and login
- Password reset functionality
- Admin authentication
- Firebase Authentication integration

### 👨‍🎓 Student Features
- **Dashboard Access** (for students with paid fees)
- **Course Management** - View enrolled courses with lecturer details
- **Timetable** - Interactive weekly class schedule
- **Notes & Materials** - Download study materials and lecture notes
- **Assignments** - Track and manage assignments
- **Fee Payment Status** - Automatic access control based on payment status

### 👨‍💼 Admin Features
- **Admin Dashboard** - Centralized management interface
- **Course Management** - Add, edit, and manage courses
- **Timetable Management** - Create and update class schedules
- **Notes Management** - Upload and manage study materials
- **Student Management** - View and manage student records

### 🚫 Fee Payment System
- Automatic blocking for unpaid fees
- Dedicated "Fees Block" page for unpaid students
- Seamless redirect to dashboard after payment

---

## 📱 Screenshots

> Add screenshots of your application here

---

## 🛠 Tech Stack

### Frontend
- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language

### Backend & Services
- **Firebase Authentication** - User authentication and management
- **Cloud Firestore** - NoSQL database for storing student data, courses, timetables
- **Shared Preferences** - Local data persistence

### Additional Packages
- `firebase_core: ^3.3.0`
- `firebase_auth: ^5.1.4`
- `cloud_firestore: ^5.0.3`
- `url_launcher: ^6.2.5`
- `shared_preferences: ^2.2.2`

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (3.8.1 or higher)
   ```bash
   flutter --version
   ```
   If not installed, visit: https://docs.flutter.dev/get-started/install

2. **Git**
   ```bash
   git --version
   ```

3. **A code editor** (VS Code, Android Studio, or IntelliJ IDEA)

4. **Chrome** (for web development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/aliahmed/city-university-portal.git
   cd city-university-portal
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter setup**
   ```bash
   flutter doctor
   ```

4. **Run the app**
   ```bash
   # For Chrome (Web)
   flutter run -d chrome
   
   # For macOS
   flutter run -d macos
   
   # For iOS Simulator
   flutter run -d ios
   
   # For Android Emulator
   flutter run -d android
   ```

---

## 🔑 Test Credentials

Use these credentials to test the application:

### Student Account
```
Email: student@city.edu.my
Password: 123456
```
*Note: This account may be blocked if fees are unpaid in the database*

### Admin Account
```
Email: admin@city.edu.my
Password: 123456
```
*Full access to admin dashboard and management features*

> ⚠️ **Security Note:** These are test credentials for development purposes only. Change them in production!

---

## 📁 Project Structure

```
student_portal/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── firebase_options.dart        # Firebase configuration
│   ├── login_page.dart              # Student/Admin login screen
│   ├── signup_page.dart             # Student registration
│   ├── dashboard_page.dart          # Student dashboard
│   ├── admin_dashboard.dart         # Admin control panel
│   └── pages/
│       ├── courses_page.dart        # Course management
│       ├── timetable_page.dart      # Class schedule
│       ├── notes_page.dart          # Study materials
│       ├── assignments_page.dart    # Assignment tracking
│       └── fees_block_page.dart     # Payment required page
├── android/                         # Android-specific files
├── ios/                            # iOS-specific files
├── web/                            # Web-specific files
├── macos/                          # macOS-specific files
├── pubspec.yaml                    # Dependencies
└── README.md                       # This file
```

---

## 🔥 Firebase Setup

This project uses Firebase for authentication and database. The Firebase project is already configured:

- **Project ID:** `city-student-portal`
- **Services:** Authentication, Cloud Firestore

### Database Structure

#### Collections:

**1. `students` Collection**
```json
{
  "uid": "user_firebase_uid",
  "feesPaid": true/false,
  "isAdmin": true/false
}
```

**2. `courses` Collection**
```json
{
  "main": {
    "courses": [
      {
        "subjectName": "Course Name",
        "subjectCode": "CS101",
        "lecturerName": "Dr. Name",
        "lecturerEmail": "lecturer@city.edu.my"
      }
    ]
  }
}
```

**3. `timetable` Collection**
```json
{
  "main": {
    "Monday-8-11": "Subject Name",
    "Monday-11-2": "Subject Name",
    ...
  }
}
```

### Setting Up Your Own Firebase Project

If you want to use your own Firebase project:

1. Create a new Firebase project at https://console.firebase.google.com
2. Enable Authentication (Email/Password)
3. Create a Firestore Database
4. Run `flutterfire configure` to generate new `firebase_options.dart`
5. Update the Firebase configuration in your project

---

## 💻 Running the App

### Web (Chrome)
```bash
flutter run -d chrome
```

### macOS Desktop
```bash
flutter run -d macos
```

### iOS Simulator
```bash
flutter run -d ios
```

### Android Emulator
```bash
flutter run -d android
```

### Hot Reload Commands (while app is running)
- `r` - Hot reload (apply code changes)
- `R` - Hot restart (full restart)
- `q` - Quit application
- `h` - Show all available commands

---

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

---

## 🐛 Troubleshooting

### Common Issues

**1. Firebase Connection Issues**
- Ensure you have internet connection
- Verify Firebase configuration in `firebase_options.dart`
- Check Firebase Console for project status

**2. Build Errors on Android**
- Run `flutter clean` then `flutter pub get`
- Check Android SDK installation
- Accept Android licenses: `flutter doctor --android-licenses`

**3. Dependencies Issues**
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Ali Ahmed**
- GitHub: [@aliahmed](https://github.com/aliahmed)
- Email: ali.ahmed.pachaar@gmail.com

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- City University for the project requirements

---

## 📞 Support

For support, email ali.ahmed.pachaar@gmail.com or create an issue in this repository.

---

**Made with ❤️ using Flutter**
