# Coffee Shop App

A premium, highly-responsive Flutter application developed for the Flutter Designer Intern Assignment. Features dynamic UI state management, real-time GPS location tracking, and integration with a Supabase backend.

## Project setup instructions

1. Ensure you have the Flutter SDK installed and added to your system PATH.
2. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/hnlikith/coffee_shop_app.git
   ```
3. Navigate into the project directory:
   ```bash
   cd coffee_shop_app
   ```
4. Check that your emulator is running or a physical device is connected via USB.

## Dependency installation

This project uses standard Flutter packages. To install all necessary dependencies, run the following command in the root directory of the project:

```bash
flutter pub get
```

Key dependencies included:
- `get` (State Management, Routing, DI)
- `geolocator` & `http` (Live GPS & Reverse Geocoding)
- `supabase_flutter` (Backend connectivity)
- `flutter_screenutil` (Responsive UI layout)
- `google_fonts` (Typography)

## Steps to run the application locally

1. Start your Android Emulator or connect a physical Android/iOS device.
2. Run the application from the root directory using:
   ```bash
   flutter run
   ```
3. **Location Services:** Upon opening, the app will request location permissions to fetch your live city using OpenStreetMap. Ensure Location/GPS is turned on in your device emulator.

*Note: For the best performance and to ensure all assets are bundled correctly, building an APK is recommended (`flutter build apk --release`).*

## Backend configuration/setup

The application is fully integrated with **Supabase** for backend data management. 

1. Create a project at [supabase.com](https://supabase.com/).
2. Navigate to the SQL Editor in your Supabase dashboard and execute the following database schema to create the necessary tables:

```sql
-- Create Categories Table
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL
);

-- Insert Categories
INSERT INTO categories (name) VALUES
  ('All Coffee'), ('Machaito'), ('Latte'), ('Americano');

-- Create Products Table
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL NOT NULL,
  rating DECIMAL DEFAULT 4.5,
  image_url TEXT,
  category TEXT NOT NULL
);

-- Insert Products
INSERT INTO products (name, description, price, rating, image_url, category) VALUES
  ('Caffe Mocha', 'A rich chocolate-flavored warm beverage made with espresso, steamed milk, and cocoa.', 4.53, 4.8, 'assets/images/caffe_mocha.png', 'Latte'),
  ('Flat White', 'A smooth and velvety coffee with a thin layer of steamed milk over a double shot of espresso.', 3.99, 4.6, 'assets/images/flat_white.png', 'Latte'),
  ('Espresso', 'A concentrated shot of bold coffee brewed by forcing hot water through finely ground beans.', 2.99, 4.9, 'assets/images/espresso.png', 'Americano'),
  ('Cappuccino', 'A classic Italian coffee with equal parts espresso, steamed milk, and rich milk foam.', 4.20, 4.7, 'assets/images/cappuccino.png', 'Machaito'),
  ('Macchiato', 'An espresso "stained" with a small dollop of foamed milk for a bold yet balanced flavor.', 3.50, 4.5, 'assets/images/macchiato.png', 'Machaito'),
  ('Americano', 'A smooth, full-bodied coffee made by diluting espresso with hot water.', 3.00, 4.4, 'assets/images/americano.png', 'Americano'),
  ('Latte', 'A creamy coffee made with espresso and a generous pour of steamed milk.', 4.00, 4.6, 'assets/images/latte.png', 'Latte'),
  ('Mocha Latte', 'A decadent blend of espresso, chocolate syrup, and steamed milk topped with whipped cream.', 5.00, 4.8, 'assets/images/mocha_latte.png', 'Latte');
```

## API endpoints or configuration details

If your Supabase database is empty or offline, the app employs a **graceful fallback architecture** that serves the above data locally. 

To connect the live backend, open `lib/main.dart` and insert your Supabase credentials into the `Supabase.initialize` block:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

**External API (OpenStreetMap Nominatim):**
- **Endpoint:** `https://nominatim.openstreetmap.org/reverse`
- **Method:** `GET`
- **Purpose:** Converts the user's raw GPS latitude and longitude into a localized City and State name. No authentication is required, but a `User-Agent` header is provided as per Nominatim policy.
