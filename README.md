# Expense Tracker Lite

A lightweight expense tracking mobile application built with Flutter that works offline, integrates with a currency conversion API, supports pagination, and matches a modern UI design.

## 📱 Features

### Core Features
- **Dashboard Screen**
  - User welcome message and profile image
  - Total balance, income, and expenses display
  - Filter options (This Month, Last 7 Days, Last 30 Days, This Year, All Time)
  - List of recent expenses with infinite scroll pagination
  - Floating action button to add new expenses

- **Add Expense Screen**
  - Category selection with visual icons
  - Amount input with currency selection
  - Date picker
  - Receipt image upload
  - Save functionality with validation

- **Currency Conversion**
  - Real-time currency conversion using [Open Exchange Rates API](https://open.er-api.com/v6/latest/USD)
  - Stores both original amount and USD converted amount
  - Supports multiple currencies

- **Pagination**
  - Infinite scroll pagination (10 items per page)
  - Works seamlessly with filters
  - Loading states and error handling

- **Local Storage**
  - Offline-first architecture using Hive
  - Persistent data storage
  - Fast read/write operations

- **Export Functionality**
  - Export expenses as CSV
  - Export expenses as PDF
  - Share functionality

### Bonus Features
- ✅ **Animated Transitions** - Smooth page transitions between screens
- ✅ **CSV Export** - Export expense data as CSV files
- ✅ **PDF Export** - Generate PDF reports with expense summaries
- ✅ **CI/CD Pipeline** - GitHub Actions for automated testing and building

## 🏗️ Architecture

### State Management
The app uses **BLoC (Business Logic Component)** pattern for state management, following the requirements strictly (using `Bloc` not `Cubit`).

### Project Structure
```
lib/
├── core/
│   ├── common_widgets/     # Reusable widgets
│   ├── constants/          # App constants and configurations
│   ├── extensions/         # Context and other extensions
│   ├── localization/      # Internationalization
│   ├── models/            # Shared models (categories, currencies)
│   ├── network/           # API client and network utilities
│   ├── storage/           # Hive storage service
│   ├── theme/             # App theme, colors, text styles
│   └── utils/             # Utility functions (validators, date utils, etc.)
├── features/
│   ├── dashboard/
│   │   ├── data/
│   │   │   └── entities/  # Data models
│   │   ├── repositories/  # Data repositories and API clients
│   │   └── presentation/
│   │       ├── blocs/     # BLoC implementation
│   │       ├── pages/     # Screen widgets
│   │       └── widgets/   # Feature-specific widgets
│   └── add_expense/
│       └── presentation/
│           ├── blocs/
│           ├── pages/
│           └── widgets/
└── main.dart
```

### Key Architectural Decisions

1. **Feature-based Structure**: Each feature is self-contained with its own data, repository, and presentation layers
2. **BLoC Pattern**: Strict use of `Bloc` (not `Cubit`) as per requirements
3. **Repository Pattern**: Separation of data sources (Hive, API) from business logic
4. **Extension-based Utilities**: Context extensions for cleaner code
5. **Reusable Components**: Common widgets for consistent UI

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd expense_tracker_lite
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/validators_test.dart
flutter test test/currency_calculation_test.dart
flutter test test/pagination_test.dart
```

### Building for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 📦 Dependencies

### Main Dependencies
- `flutter_bloc: ^8.1.6` - BLoC state management
- `hive: ^2.2.3` & `hive_flutter: ^1.1.0` - Local storage
- `http: ^1.2.0` - HTTP client for API calls
- `equatable: ^2.0.5` - Value equality
- `intl: ^0.19.0` - Internationalization
- `image_picker: ^1.0.7` - Image selection
- `pdf: ^3.10.7` - PDF generation
- `csv: ^5.0.2` - CSV export
- `share_plus: ^7.2.1` - File sharing

## 🧪 Testing

The project includes comprehensive tests:

1. **Expense Validation Tests** (`test/validators_test.dart`)
   - Amount validation
   - Category validation
   - Date validation
   - Amount parsing

2. **Currency Calculation Tests** (`test/currency_calculation_test.dart`)
   - USD conversion
   - Multi-currency conversion
   - API rate fetching

3. **Pagination Logic Tests** (`test/pagination_test.dart`)
   - Page size validation
   - Empty list handling
   - Order maintenance
   - Edge cases

## 🔄 CI/CD

The project includes GitHub Actions workflow (`.github/workflows/ci.yml`) that:
- Runs on push and pull requests
- Executes code formatting checks
- Runs static analysis
- Executes all tests
- Builds Android APK
- Builds iOS app (on macOS runners)

## 📱 API Integration

### Currency Conversion API
- **Endpoint**: `https://open.er-api.com/v6/latest/USD`
- **No API Key Required**: Free tier available
- **Implementation**: Real-time conversion when saving expenses
- **Caching**: Currency rates are stored locally for offline use

## 💾 Local Storage Strategy

- **Technology**: Hive (NoSQL database)
- **Storage**: Platform-specific storage (works offline)
- **Data Models**: JSON-serialized expense entities
- **Pagination**: Client-side pagination from local storage

## 🎨 UI/UX

The app closely follows the provided design with:
- Modern card-based layout
- Rounded corners and shadows
- Consistent color scheme (blue primary)
- Smooth animations and transitions
- Responsive design

## 📝 Known Limitations

1. **Currency Rates**: Rates are fetched on-demand; no automatic refresh mechanism
2. **Receipt Storage**: Receipt images are stored as file paths; consider cloud storage for production
3. **Category Management**: "Add Category" feature is UI-ready but not fully implemented
4. **Income Tracking**: UI supports income but primary focus is on expenses

## 🔮 Future Enhancements

- [ ] Cloud sync functionality
- [ ] Recurring expenses
- [ ] Budget planning
- [ ] Expense analytics and charts
- [ ] Multi-language support (currently English/Arabic ready)
- [ ] Dark mode toggle
- [ ] Receipt OCR for automatic expense extraction

## 📄 License

This project is created for technical assessment purposes.

## 👤 Author

Developed as part of a technical interview project.

---

**Note**: This project follows clean architecture principles and best practices for Flutter development. All requirements from the technical task have been implemented, including bonus features.
