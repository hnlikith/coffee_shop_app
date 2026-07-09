# ☕ Coffee Shop App

A premium Flutter coffee ordering application with a modern dark theme, Supabase backend integration, and smooth animations.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![Supabase](https://img.shields.io/badge/Backend-Supabase-green?logo=supabase)
![GetX](https://img.shields.io/badge/State-GetX-purple)

---

## 📱 Features

- **4 Premium Screens**: Splash, Home, Detail, Checkout
- **Supabase Backend**: PostgreSQL database with real REST APIs
- **GetX State Management**: Reactive UI updates throughout
- **Responsive Design**: Adapts to all Android and iOS screen sizes
- **Smooth Animations**: Hero transitions, fade-ins, scale effects
- **Category Filtering**: Filter products by coffee type
- **Search**: Real-time product search
- **Size Selector**: S/M/L with dynamic price calculation
- **Quantity Controls**: Increment/decrement with live total updates
- **Delivery/Pickup Toggle**: Dynamic checkout experience

---

## 🛠 Tech Stack

| Layer              | Technology             |
|--------------------|------------------------|
| Framework          | Flutter                |
| Language           | Dart                   |
| State Management   | GetX                   |
| Backend            | Supabase (PostgreSQL)  |
| Image Caching      | CachedNetworkImage     |
| Responsive Design  | flutter_screenutil     |
| Typography         | Google Fonts (Sora)    |
| Architecture       | Clean Architecture     |

---

## 📂 Folder Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # Root widget with routing
├── core/
│   ├── constants/
│   │   ├── app_colors.dart      # Color palette
│   │   ├── app_strings.dart     # String constants
│   │   └── supabase_constants.dart  # Supabase config
│   └── theme/
│       └── app_theme.dart       # Dark theme configuration
├── data/
│   ├── models/
│   │   ├── coffee_model.dart    # Coffee product model
│   │   ├── category_model.dart  # Category model
│   │   └── cart_item_model.dart # Cart item model
│   ├── repositories/
│   │   └── coffee_repository.dart   # Data access layer
│   └── services/
│       └── supabase_service.dart    # Supabase client wrapper
├── controllers/
│   ├── coffee_controller.dart   # Products and categories state
│   └── cart_controller.dart     # Cart, size, quantity state
├── screens/
│   ├── splash/
│   │   └── splash_screen.dart   # Animated splash screen
│   ├── home/
│   │   └── home_screen.dart     # Home with grid and categories
│   ├── detail/
│   │   └── detail_screen.dart   # Product detail with size selector
│   └── checkout/
│       └── checkout_screen.dart # Order and payment screen
└── widgets/
    ├── coffee_card.dart         # Product grid card
    ├── category_chip.dart       # Category filter chip
    ├── size_selector.dart       # S/M/L toggle
    ├── quantity_selector.dart   # +/- quantity stepper
    └── promo_banner.dart        # Promotional banner
```

---

## 🚀 Installation

### Prerequisites

- Flutter SDK 3.x+
- Android Studio / VS Code
- Git

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/coffee-ordering-app.git
cd coffee-ordering-app

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

---

## 🔧 API / Backend Setup (Supabase)

### 1. Create a Supabase Project

Go to [supabase.com](https://supabase.com) and create a new project named `coffee_shop_app`.

### 2. Create Tables

Run the following SQL in the Supabase SQL Editor:

```sql
-- Categories
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL
);

INSERT INTO categories (name) VALUES
  ('All Coffee'), ('Macchiato'), ('Latte'), ('Americano');

-- Products
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL NOT NULL,
  rating DECIMAL DEFAULT 4.5,
  image_url TEXT,
  category TEXT NOT NULL
);

INSERT INTO products (name, description, price, rating, image_url, category) VALUES
  ('Caffe Mocha', 'A rich chocolate-flavored warm beverage', 4.53, 4.8, 'YOUR_URL', 'Latte'),
  ('Flat White', 'Smooth and velvety espresso coffee', 3.99, 4.6, 'YOUR_URL', 'Latte'),
  ('Espresso', 'A concentrated shot of bold coffee', 2.99, 4.9, 'YOUR_URL', 'Americano'),
  ('Cappuccino', 'Classic Italian coffee with foam', 4.20, 4.7, 'YOUR_URL', 'Macchiato'),
  ('Macchiato', 'Espresso stained with foamed milk', 3.50, 4.5, 'YOUR_URL', 'Macchiato'),
  ('Americano', 'Smooth espresso diluted with hot water', 3.00, 4.4, 'YOUR_URL', 'Americano'),
  ('Latte', 'Creamy espresso with steamed milk', 4.00, 4.6, 'YOUR_URL', 'Latte'),
  ('Mocha Latte', 'Espresso with chocolate and steamed milk', 5.00, 4.8, 'YOUR_URL', 'Latte');
```

### 3. Upload Coffee Images

1. Create a **Storage bucket** named `coffee-images`
2. Upload coffee images
3. Copy the public URLs into the `image_url` column

### 4. Configure Flutter App

Update `lib/core/constants/supabase_constants.dart`:

```dart
static const String supabaseUrl = 'https://YOUR_PROJECT.supabase.co';
static const String supabaseAnonKey = 'YOUR_ANON_KEY';
```

> **Note**: The app includes built-in fallback data with Unsplash images, so it works even without Supabase configured.

---

## 📦 Build APK

```bash
flutter clean
flutter pub get
flutter build apk --release
```

APK output: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📸 App Flow

```
Splash Screen → Home Screen → Coffee Detail → Checkout
```

1. **Splash**: Animated entry with Get Started button
2. **Home**: Browse products, filter by category, search
3. **Detail**: View product, select size (S/M/L), see dynamic pricing
4. **Checkout**: Choose delivery/pickup, adjust quantity, view total, place order

---

## 🏗 Architecture

The app follows **Clean Architecture** principles:

- **Data Layer**: Models, Repository, Services (Supabase)
- **Business Logic**: GetX Controllers with reactive state
- **Presentation**: Screens and reusable Widgets
- **Core**: Constants, Theme, Utilities

---

## 📄 License

This project is created as part of a Flutter Internship Assignment.
