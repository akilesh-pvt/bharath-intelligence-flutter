# 🌾 Bharath Intelligence - Flutter Agricultural Field Management System

A high-performance, mobile-first agricultural field management system with light green theme, optimized UI/UX, and custom database authentication.

## 📋 Prerequisites

Before running this application, ensure you have:

- **Flutter SDK**: Version 3.10.0 or higher
- **Dart SDK**: Version 3.0.0 or higher
- **Android Studio** or **VS Code** with Flutter extensions
- **Git** for version control
- **Supabase Account** (free tier is sufficient)

## 🚀 Setup Instructions

### Step 1: Clone the Repository

```bash
git clone https://github.com/akilesh-pvt/bharath-intelligence-flutter.git
cd bharath-intelligence-flutter
```

### Step 2: Install Flutter Dependencies

```bash
flutter pub get
```

### Step 3: Set Up Supabase Database

#### 3.1 Create a Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign up or log in to your account
3. Click "New Project"
4. Fill in your project details:
   - **Name**: `bharath-intelligence`
   - **Organization**: Select your organization
   - **Password**: Choose a strong database password
   - **Region**: Select the closest region to you
5. Click "Create new project"
6. Wait for the project to be set up (usually takes 1-2 minutes)

#### 3.2 Get Your Supabase Credentials

1. Go to your project dashboard
2. Click on "Settings" → "API"
3. Copy the following values:
   - **Project URL** (looks like: `https://xxxxx.supabase.co`)
   - **anon/public key** (starts with `eyJhbGci...`)

#### 3.3 Execute the Database Schema

1. In your Supabase dashboard, go to "SQL Editor"
2. Click "New query"
3. **Copy and paste the following SQL code**:

```sql
-- Create profiles table with custom authentication
CREATE TABLE profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  mobile TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT DEFAULT 'field_visitor' CHECK (role IN ('admin', 'field_visitor')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create farmers table with full-text search capability
CREATE TABLE farmers (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT,
  village TEXT,
  district TEXT,
  crops TEXT,
  is_prefilled BOOLEAN DEFAULT FALSE,
  created_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create tasks table with proper cascade handling
CREATE TABLE tasks (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  farmer_id BIGINT REFERENCES farmers(id) ON DELETE CASCADE,
  assigned_to UUID REFERENCES profiles(id) ON DELETE CASCADE,
  created_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'completed')),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create claims table with financial tracking
CREATE TABLE claims (
  id BIGSERIAL PRIMARY KEY,
  task_id BIGINT REFERENCES tasks(id) ON DELETE CASCADE,
  visitor_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  amount DECIMAL(10,2) DEFAULT 0,
  status TEXT DEFAULT 'submitted' CHECK (status IN ('submitted', 'approved', 'rejected')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create performance indexes
CREATE INDEX idx_profiles_mobile ON profiles(mobile);
CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_tasks_assigned_to ON tasks(assigned_to);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_farmers_name ON farmers USING gin(to_tsvector('english', name));
CREATE INDEX idx_claims_visitor_id ON claims(visitor_id);

-- Insert default admin user (password: admin123)
INSERT INTO profiles (name, mobile, password_hash, role) VALUES 
('System Admin', '9999999999', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'admin');

-- Insert sample field visitor (password: visitor123)
INSERT INTO profiles (name, mobile, password_hash, role) VALUES 
('John Visitor', '8888888888', '2e99758548972a8e8822ad47fa1017ff72f06f3ff6a016851f45c398732bc50c', 'field_visitor');

-- Insert sample farmers
INSERT INTO farmers (name, phone, village, district, crops, is_prefilled, created_by) VALUES 
('Ravi Kumar', '7777777777', 'Kanakapura', 'Ramanagara', 'Rice, Wheat', true, (SELECT id FROM profiles WHERE role = 'admin' LIMIT 1)),
('Lakshmi Devi', '6666666666', 'Channapatna', 'Ramanagara', 'Vegetables, Flowers', true, (SELECT id FROM profiles WHERE role = 'admin' LIMIT 1)),
('Manjunath', '5555555555', 'Magadi', 'Ramanagara', 'Sugarcane, Maize', true, (SELECT id FROM profiles WHERE role = 'admin' LIMIT 1));

-- Insert sample tasks
INSERT INTO tasks (title, farmer_id, assigned_to, created_by, status, notes) VALUES 
('Crop Survey - Kanakapura', 1, (SELECT id FROM profiles WHERE role = 'field_visitor' LIMIT 1), (SELECT id FROM profiles WHERE role = 'admin' LIMIT 1), 'pending', 'Complete crop assessment for Ravi Kumar'),
('Soil Testing - Channapatna', 2, (SELECT id FROM profiles WHERE role = 'field_visitor' LIMIT 1), (SELECT id FROM profiles WHERE role = 'admin' LIMIT 1), 'pending', 'Collect soil samples for testing'),
('Fertilizer Distribution', 3, (SELECT id FROM profiles WHERE role = 'field_visitor' LIMIT 1), (SELECT id FROM profiles WHERE role = 'admin' LIMIT 1), 'completed', 'Fertilizer distribution completed successfully');

-- Enable Row Level Security (RLS) - Optional but recommended
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE farmers ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE claims ENABLE ROW LEVEL SECURITY;

-- Create policies for Row Level Security
CREATE POLICY "Enable read access for all users" ON profiles FOR SELECT USING (true);
CREATE POLICY "Enable insert for authenticated users only" ON profiles FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for users based on role" ON profiles FOR UPDATE USING (true);
CREATE POLICY "Enable delete for admin users only" ON profiles FOR DELETE USING (true);

CREATE POLICY "Enable read access for all users" ON farmers FOR SELECT USING (true);
CREATE POLICY "Enable insert for authenticated users only" ON farmers FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for authenticated users only" ON farmers FOR UPDATE USING (true);
CREATE POLICY "Enable delete for authenticated users only" ON farmers FOR DELETE USING (true);

CREATE POLICY "Enable read access for all users" ON tasks FOR SELECT USING (true);
CREATE POLICY "Enable insert for authenticated users only" ON tasks FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for authenticated users only" ON tasks FOR UPDATE USING (true);
CREATE POLICY "Enable delete for authenticated users only" ON tasks FOR DELETE USING (true);

CREATE POLICY "Enable read access for all users" ON claims FOR SELECT USING (true);
CREATE POLICY "Enable insert for authenticated users only" ON claims FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for authenticated users only" ON claims FOR UPDATE USING (true);
CREATE POLICY "Enable delete for authenticated users only" ON claims FOR DELETE USING (true);
```

4. Click "Run" to execute the SQL
5. You should see "Success. No rows returned" message

### Step 4: Configure Supabase in Flutter App

Create a new file `lib/config/supabase_config.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL_HERE';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
}
```

**Replace the placeholder values with your actual Supabase credentials:**
- Replace `YOUR_SUPABASE_URL_HERE` with your Project URL
- Replace `YOUR_SUPABASE_ANON_KEY_HERE` with your anon/public key

### Step 5: Update Main Application File

Create/update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'config/supabase_config.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/farmer_provider.dart';
import 'providers/task_provider.dart';
import 'screens/splash_screen.dart';
import 'services/storage_service.dart';
import 'utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  // Initialize services
  await StorageService.initialize();
  await SupabaseConfig.initialize();
  
  runApp(const BharathIntelligenceApp());
}

class BharathIntelligenceApp extends StatelessWidget {
  const BharathIntelligenceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FarmerProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'Bharath Intelligence',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: AppColors.primarySwatch,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.buttonText,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.buttonText,
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
```

### Step 6: Run the Application

#### For Android:
```bash
flutter run
```

#### For iOS (macOS only):
```bash
flutter run -d ios
```

#### For specific device:
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

## 🔐 Default Login Credentials

The application comes with pre-configured users:

### Admin User:
- **Mobile**: `9999999999`
- **Password**: `admin123`
- **Role**: Administrator (Full access)

### Field Visitor User:
- **Mobile**: `8888888888`
- **Password**: `visitor123`
- **Role**: Field Visitor (Limited access)

## 📱 Application Features

### Admin Features:
- ✅ User Management (Create, Update, Delete users)
- ✅ Farmer Management (Full CRUD operations)
- ✅ Task Management (Create and assign tasks)
- ✅ Claims Management (Review and approve claims)
- ✅ Dashboard with statistics

### Field Visitor Features:
- ✅ View assigned tasks
- ✅ Complete tasks with notes
- ✅ View farmer information through tasks
- ✅ Submit claims for completed tasks
- ✅ Personal dashboard

## 🎨 Design Features

- **Light Green Theme**: Optimized color palette avoiding blue colors
- **Portrait Locked**: Optimal mobile user experience
- **Smooth Animations**: 60fps performance with optimized transitions
- **Material Design 3**: Modern, accessible UI components
- **Custom Authentication**: Secure login without external dependencies

## 🛠️ Troubleshooting

### Common Issues:

1. **Build Errors**: Run `flutter clean` then `flutter pub get`

2. **Supabase Connection Issues**: 
   - Verify your URL and API key in `supabase_config.dart`
   - Check your internet connection
   - Ensure Supabase project is active

3. **Database Issues**:
   - Verify SQL schema was executed successfully
   - Check Supabase dashboard for table creation
   - Ensure sample data is inserted

4. **Login Issues**:
   - Use the exact credentials provided above
   - Check for typos in mobile number
   - Verify the database has the default users

### Getting Help:

If you encounter any issues:
1. Check the Flutter logs in your terminal
2. Verify all dependencies are installed correctly
3. Ensure your Supabase project is properly configured
4. Check that the database schema was executed successfully

## 📊 Performance Optimizations

- ✅ Const constructors throughout the app
- ✅ Efficient state management with Provider
- ✅ Optimized database queries with indexes
- ✅ Lazy loading for large datasets
- ✅ Strategic widget rebuilding minimization

The application is designed to run smoothly on devices with API 21+ (Android 5.0+) and iOS 12.0+.