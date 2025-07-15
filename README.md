# Expense Tracker

# 📊 Expense Tracker App

A modern **Flutter-based Personal Expense Tracker** application to manage budgets, track income/expenses, and visualize spending with clean charts and category-wise summaries.

---

## 📸 Screenshots

<!-- Add screenshots here -->
<img width="424" height="910" alt="image" src="https://github.com/user-attachments/assets/fea994c1-c1dd-4c00-ba29-d1ca911ea71e" />
<img width="424" height="910" alt="image" src="https://github.com/user-attachments/assets/a32610ee-30c8-4071-a7cd-15e9ec2c70e0" />
<img width="353" height="715" alt="image" src="https://github.com/user-attachments/assets/29a3af0e-39ce-40e3-a2fc-62f78d6aef6c" />
<img width="353" height="715" alt="image" src="https://github.com/user-attachments/assets/a62787cf-df52-4cd4-a1d2-813723402c68" />
<img width="353" height="715" alt="image" src="https://github.com/user-attachments/assets/44e837e5-9c82-48e3-8286-b65b3a68bfc7" />
<img width="353" height="715" alt="image" src="https://github.com/user-attachments/assets/d43596ab-c9e0-4e7e-8a50-4fe7d1e47095" />
<img width="353" height="715" alt="image" src="https://github.com/user-attachments/assets/3587d7ce-f81e-4d0a-8921-fd5fb5577006" />


- 🏠 Home Screen  
- ➕ Add Transaction  
- 📅 Monthly Filter  
- 📈 Pie Chart Summary  

---

## ⚙️ Features

- ✅ Add, **transactions**
- ✅ Create **wallets** with budgets
- ✅ **Category-based** organization (with icons)
- ✅ **Monthly filters** and grouping
- ✅ **Pie chart** for expense breakdown (powered by `fl_chart`)
- ✅ Data stored locally using **Drift + SQLite**
- ✅ Clean and **responsive UI** (`flutter_screenutil`)
- ✅ **Biometric authentication** (via `local_auth`)
- ✅ Export and print transactions as **CSV or PDF**

---

📁 Project Structure
bashlib/
│
├── application/       # Bloc state management
├── core/              # Common widgets, constants, services
├── data/
│   ├── datasources/   # Drift DB setup and DAOs
│   └── models/        # Data models
├── domain/            # Business logic and entities
├── presentation/      # UI widgets and screens
└── main.dart          # Entry point

🧠 Architecture
This project follows a Clean Architecture + Bloc approach:

Presentation Layer: UI built with Flutter widgets
Application Layer: flutter_bloc used for reactive state management
Domain Layer: Plain Dart entities and use cases
Data Layer: Local DB via Drift, file system, and secure storage


🛠️ Dependencies
Package                Purpose
flutter_bloc           State management
drift                  Local database
flutter_screenutil     Responsive layout
fl_chart               Pie chart visualization
flutter_secure_storage Secure PIN storage
local_auth             Biometric 
authentication         file_picker
google_fonts          Styling
flutter_svg            Icons

🧪 Setup Instructions

Clone the repository:
bashgit clone https://github.com/your-username/expense_tracker.git
cd expense_tracker

Install dependencies:
bashflutter pub get

Configure Android permissions
Add this to android/app/src/main/AndroidManifest.xml:
xml<uses-permission android:name="android.permission.INTERNET" />

Run the app:
bashflutter run



📦 Build APK
To build a release APK:
bashflutter build apk --release

📝 Notes

⚠️ Avoid using sqlite3_flutter_libs on Android SDK 35 until it's stabilized.
App uses manual Drift setup, not code generation (can be changed via build runner).
Uses IndexedStack and Bloc to manage bottom navigation efficiently.


🚀 Future Improvements

🔒 Passcode or biometric lock for app launch
☁️ Sync with cloud (Firebase, Supabase, etc.)
📱 iOS support
🌍 Localization & multi-currency support


📄 License
MIT License – see LICENSE file.
