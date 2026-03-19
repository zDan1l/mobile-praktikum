# 📱 Materi 4 - Permission, Dependency, Navigation & Routing
## Step-by-Step Tutorial Flutter (D4TI Vokasi)

---

## 📋 DAFTAR ISI
1. [Setup AndroidManifest & build.gradle](#step-1)
2. [Struktur Folder](#step-2)
3. [Update Constants](#step-3)
4. [Dashboard Model](#step-4)
5. [Dashboard Repository](#step-5)
6. [Dashboard Provider](#step-6)
7. [Dashboard Widget](#step-7)
8. [Dashboard Page](#step-8)
9. [Dosen - Model](#step-9)
10. [Dosen - Repository](#step-10)
11. [Dosen - Provider](#step-11)
12. [Dosen - Widget](#step-12)
13. [Dosen - Page](#step-13)
14. [Main.dart](#step-14)
15. [Tugas Mandiri (Mahasiswa, Mahasiswa Aktif, Profile)](#step-15)

---

## STEP 1 - Setup AndroidManifest & build.gradle {#step-1}

### 1a. Edit `android/app/src/main/AndroidManifest.xml`

Tambahkan permission INTERNET dan camera **sebelum tag `<application>`**:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-feature
        android:name="android.hardware.camera"
        android:required="false" />

    <application
        android:label="D4 TI Vokasi"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            ...
```

### 1b. Edit `android/app/build.gradle.kts`

Cari bagian `buildTypes` dan ubah menjadi seperti ini:

```kotlin
buildTypes {
    release {
        // TODO: Add your own signing config for the release build.
        // Signing with the debug keys for now, so `flutter run --release` works.
        signingConfig = signingConfigs.getByName("debug")
        isMinifyEnabled = true
        isShrinkResources = true
    }
}
```

### 1c. Jalankan perintah ini di terminal

```bash
flutter clean
flutter pub get
```

---

## STEP 2 - Buat Struktur Folder {#step-2}

Buat folder-folder berikut di dalam `lib/`:

```
lib/
├── core/
│   ├── constants/
│   │   └── constants.dart  (sudah ada, nanti diedit)
│   ├── theme/
│   │   └── theme.dart
│   └── widgets/
│       └── widgets.dart
├── features/
│   ├── dashboard/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── dashboard_model.dart
│   │   │   └── repositories/
│   │   │       └── dashboard_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── dashboard_page.dart
│   │       ├── providers/
│   │       │   └── dashboard_provider.dart
│   │       └── widgets/
│   │           └── dashboard_widget.dart
│   ├── dosen/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── dosen_model.dart
│   │   │   └── repositories/
│   │   │       └── dosen_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── dosen_page.dart
│   │       ├── providers/
│   │       │   └── dosen_provider.dart
│   │       └── widgets/
│   │           └── dosen_widget.dart
│   ├── mahasiswa/          ← buat nanti (tugas)
│   ├── mahasiswa_aktif/    ← buat nanti (tugas)
│   └── profile/            ← buat nanti (tugas)
└── main.dart
```

> 💡 **Tips:** Buat folder dulu semuanya, baru isi file-nya satu per satu.

---

## STEP 3 - Update `core/constants/constants.dart` {#step-3}

Tambahkan kode berikut ke dalam class `AppConstants`:

```dart
class AppConstants {
  // App Info
  static const String appName = 'Dashboard Mahasiswa D4TI';
  static const String appVersion = '1.0.0';

  // Keys
  static const String userPrefsKey = 'user_prefs';

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  // Dashboard Gradient Colors
  static const List<List<Color>> dashboardGradients = [
    [Color(0xFF667eea), Color(0xFF764ba2)], // Purple
    [Color(0xFFf093fb), Color(0xFFf5576c)], // Pink
    [Color(0xFF4facfe), Color(0xFF00f2fe)], // Blue
    [Color(0xFF43e97b), Color(0xFF38f9d7)], // Green
  ];

  // Individual Gradient Colors (optional - for direct access)
  static const List<Color> gradientPurple = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
  ];
  static const List<Color> gradientPink = [
    Color(0xFFf093fb),
    Color(0xFFf5576c),
  ];
  static const List<Color> gradientBlue = [
    Color(0xFF4facfe),
    Color(0xFF00f2fe),
  ];
  static const List<Color> gradientGreen = [
    Color(0xFF43e97b),
    Color(0xFF38f9d7),
  ];
}
```

> ⚠️ **Catatan:** Tambahkan `import 'package:flutter/material.dart';` di bagian atas file jika belum ada.

---

## STEP 4 - Dashboard Model {#step-4}

Buat file `lib/features/dashboard/data/models/dashboard_model.dart`:

```dart
/// Model statistik di dashboard
class DashboardStats {
  final String title;
  final String value;
  final String subtitle;
  // final double percentage;
  // final bool isIncrease;

  DashboardStats({
    required this.title,
    required this.value,
    required this.subtitle,
    // required this.percentage,
    // required this.isIncrease,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      title: json['title'] ?? '',
      value: json['value'] ?? '0',
      subtitle: json['subtitle'] ?? '',
      // percentage: (json['percentage'] ?? 0).toDouble(),
      // isIncrease: json['isIncrease'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'subtitle': subtitle,
      // 'percentage': percentage,
      // 'isIncrease': isIncrease,
    };
  }
}

/// Model data dashboard
class DashboardData {
  final List<DashboardStats> stats;
  final String userName;
  final DateTime lastUpdate;

  DashboardData({
    required this.stats,
    required this.userName,
    required this.lastUpdate,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      stats: (json['stats'] as List?)
              ?.map((e) => DashboardStats.fromJson(e))
              .toList() ??
          [],
      userName: json['userName'] ?? 'User',
      lastUpdate: DateTime.parse(
        json['lastUpdate'] ?? DateTime.now().toString(),
      ),
    ); // DashboardData
  }

  Map<String, dynamic> toJson() {
    return {
      'stats': stats.map((e) => e.toJson()).toList(),
      'userName': userName,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  // Copy with method
  DashboardData copyWith({
    List<DashboardStats>? stats,
    String? userName,
    DateTime? lastUpdate,
  }) {
    return DashboardData(
      stats: stats ?? this.stats,
      userName: userName ?? this.userName,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
```

---

## STEP 5 - Dashboard Repository {#step-5}

Buat file `lib/features/dashboard/data/repositories/dashboard_repository.dart`:

```dart
import 'package:d4tivokasi/features/dashboard/data/models/dashboard_model.dart';

class DashboardRepository {
  /// Mendapatkan data dashboard
  Future<DashboardData> getDashboardData() async {
    // network delay
    await Future.delayed(const Duration(seconds: 1));

    // Data dummy
    return DashboardData(
      userName: 'Admin D4TI',
      lastUpdate: DateTime.now(),
      stats: [
        DashboardStats(
          title: 'Total Mahasiswa',
          value: '1,200',
          subtitle: '',
          // percentage: 8.5,
          // isIncrease: true,
        ), // DashboardStats
        DashboardStats(
          title: 'Mahasiswa Aktif',
          value: '550',
          subtitle: '',
          // percentage: 5.2,
          // isIncrease: true,
        ), // DashboardStats
        DashboardStats(
          title: 'Dosen',
          value: '650',
          subtitle: '',
          // percentage: 1,
          // isIncrease: false,
        ), // DashboardStats
        DashboardStats(
          title: 'Profile',
          value: '',
          subtitle: '',
          // percentage: 3.5,
          // isIncrease: true,
        ), // DashboardStats
      ],
    ); // DashboardData
  }

  /// Refresh dashboard data
  Future<DashboardData> refreshDashboard() async {
    return getDashboardData();
  }

  /// Get specific stat by title
  Future<DashboardStats?> getStatByTitle(String title) async {
    final data = await getDashboardData();
    try {
      return data.stats.firstWhere((stat) => stat.title == title);
    } catch (e) {
      return null;
    }
  }
}
```

> ⚠️ **Ganti** `d4tivokasi` dengan nama package project kamu (cek di `pubspec.yaml` bagian `name:`).

---

## STEP 6 - Dashboard Provider {#step-6}

Buat file `lib/features/dashboard/presentation/providers/dashboard_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
}); // Provider

/// Menggunakan FutureProvider.autoDispose untuk selalu fetch data terbaru
final dashboardDataProvider = FutureProvider.autoDispose<DashboardData>((
  ref,
) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getDashboardData();
});

/// StateNotifier untuk mengelola state dashboard yang lebih kompleks
class DashboardNotifier extends StateNotifier<AsyncValue<DashboardData>> {
  final DashboardRepository _repository;

  DashboardNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadDashboard();
  }

  /// Load dashboard data
  Future<void> loadDashboard() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getDashboardData();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh dashboard
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.refreshDashboard();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update user name (contoh untuk state management)
  void updateUserName(String newName) {
    state.whenData((data) {
      state = AsyncValue.data(data.copyWith(userName: newName));
    });
  }
}

/// Dashboard Notifier Provider dengan autoDispose
final dashboardNotifierProvider = StateNotifierProvider.autoDispose<
  DashboardNotifier,
  AsyncValue<DashboardData>
>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return DashboardNotifier(repository);
});

/// Selected Stat Provider
final selectedStatIndexProvider = StateProvider<int>((ref) => 0);

/// Theme Mode Provider
final themeModeProvider = StateProvider<bool>(
  (ref) => false,
); // false = light, true = dark
```

---

## STEP 7 - Dashboard Widget {#step-7}

Buat file `lib/features/dashboard/presentation/widgets/dashboard_widget.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d4tivokasi/core/constants/constants.dart';
import 'package:d4tivokasi/core/theme/theme.dart';
import 'package:d4tivokasi/features/dashboard/data/models/dashboard_model.dart';

/// Widget untuk menampilkan statistik card
class StatCard extends StatelessWidget {
  final DashboardStats stats;
  final bool isSelected;
  final VoidCallback? onTap;

  const StatCard({
    Key? key,
    required this.stats,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 2,
      color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stats.title,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ), // Text
              const SizedBox(height: 8),
              Text(
                stats.value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ), // Text
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    ); // Card
  }
}

class DashboardHeader extends ConsumerWidget {
  final String userName;

  const DashboardHeader({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.radiusLarge),
          bottomRight: Radius.circular(AppConstants.radiusLarge),
        ),
      ), // BoxDecoration
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ), // Text
                    const SizedBox(height: 4),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ), // Text
                  ],
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 28,
                  ),
                ), // CircleAvatar
              ],
            ), // Row
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              'Data Mahasiswa D4TI',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ), // Text
          ],
        ),
      ), // Column
    ); // Container
  }
}

/// Modern Stat Card with Gradient and Glass Morphism
class ModernStatCard extends StatefulWidget {
  final DashboardStats stats;
  final IconData icon;
  final List<Color> gradientColors;
  final bool isSelected;
  final VoidCallback? onTap;

  const ModernStatCard({
    Key? key,
    required this.stats,
    required this.icon,
    required this.gradientColors,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<ModernStatCard> createState() => _ModernStatCardState();
}

class _ModernStatCardState extends State<ModernStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    ); // AnimationController
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradientColors,
            ), // LinearGradient
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors[0].withOpacity(0.3),
                blurRadius: widget.isSelected ? 20 : 12,
                offset: Offset(0, widget.isSelected ? 8 : 4),
              ), // BoxShadow
            ],
          ), // BoxDecoration
          child: Stack(
            children: [
              // Background decoration circles
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ), // BoxDecoration
                ), // Container
              ), // Positioned
              Positioned(
                left: -10,
                bottom: -10,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ), // BoxDecoration
                ), // Container
              ), // Positioned

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ), // BoxDecoration
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ), // Container
                    const Spacer(),

                    // Value
                    Text(
                      widget.stats.value,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ), // Text
                    const SizedBox(height: 4),

                    // Title
                    Text(
                      widget.stats.title,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ), // Text
                  ],
                ),
              ), // Padding
            ],
          ), // Stack
        ), // Container
      ), // ScaleTransition
    ); // GestureDetector
  }
}
```

---

## STEP 8 - Dashboard Page {#step-8}

Buat file `lib/features/dashboard/presentation/pages/dashboard_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d4tivokasi/core/constants/constants.dart';
import 'package:d4tivokasi/core/widgets/widgets.dart';
import 'package:d4tivokasi/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:d4tivokasi/features/dashboard/presentation/widgets/dashboard_widget.dart';
import 'package:d4tivokasi/features/mahasiswa/presentation/pages/mahasiswa_page.dart';
import 'package:d4tivokasi/features/mahasiswa_aktif/presentation/pages/mahasiswa_aktif_page.dart';
import 'package:d4tivokasi/features/dosen/presentation/pages/dosen_page.dart';
import 'package:d4tivokasi/features/profile/presentation/pages/profile_page.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({Key? key}) : super(key: key);

  // get icon
  IconData _getIconForStat(String title) {
    switch (title) {
      case 'Total Mahasiswa':
        return Icons.school_rounded;
      case 'Mahasiswa Aktif':
        return Icons.person_outline_rounded;
      case 'Mahasiswa Lulus':
        return Icons.workspace_premium_rounded;
      case 'Dosen':
        return Icons.people_outline_rounded;
      default:
        return Icons.analytics_outlined;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final selectedIndex = ref.watch(selectedStatIndexProvider);

    return Scaffold(
      body: dashboardState.when(
        loading: () => const LoadingWidget(),
        error: (error, stack) => CustomErrorWidget(
          message: 'Gagal memuat data: ${error.toString()}',
          onRetry: () {
            ref.read(dashboardNotifierProvider.notifier).refresh();
          },
        ), // CustomErrorWidget
        data: (dashboardData) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dashboardNotifierProvider);
            },
            child: CustomScrollView(
              slivers: [
                // Modern Header with Gradient
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withBlue(220),
                        ],
                      ), // LinearGradient
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ), // BorderRadius.only
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ), // BoxShadow
                      ],
                    ), // BoxDecoration
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Selamat Datang! 👋',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(
                                            0.9,
                                          ),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ), // Text
                                      const SizedBox(height: 8),
                                      Text(
                                        dashboardData.userName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.5,
                                        ),
                                      ), // Text
                                    ],
                                  ),
                                ), // Expanded
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ), // BoxDecoration
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.white,
                                      size: 26,
                                    ), // Icon
                                    onPressed: () {},
                                  ), // IconButton
                                ), // Container
                              ],
                            ), // Row
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ), // EdgeInsets.symmetric
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ), // BoxDecoration
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    color: Colors.white.withOpacity(0.9),
                                    size: 18,
                                  ), // Icon
                                  const SizedBox(width: 12),
                                  Text(
                                    'Update: ${_formatDate(dashboardData.lastUpdate)}',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ), // Text
                                ],
                              ), // Row
                            ), // Container
                          ],
                        ),
                      ), // Column
                    ), // Padding
                  ), // SafeArea
                ), // Container
                // SliverToBoxAdapter

                // Stats Section with Modern Cards
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Statistik',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ), // Text
                            TextButton.icon(
                              onPressed: () {
                                ref.invalidate(dashboardNotifierProvider);
                              },
                              icon: const Icon(
                                Icons.refresh_rounded,
                                size: 18,
                              ),
                              label: const Text('Refresh'),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ), // EdgeInsets.symmetric
                              ),
                            ), // TextButton.icon
                          ],
                        ), // Row
                        const SizedBox(height: 20),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.1,
                              ), // SliverGridDelegateWithFixedCrossAxisCount
                          itemCount: dashboardData.stats.length,
                          itemBuilder: (context, index) {
                            final stat = dashboardData.stats[index];
                            return ModernStatCard(
                              stats: stat,
                              icon: _getIconForStat(stat.title),
                              gradientColors:
                                  AppConstants.dashboardGradients[index %
                                      AppConstants.dashboardGradients.length],
                              isSelected: selectedIndex == index,
                              onTap: () {
                                ref
                                    .read(
                                      selectedStatIndexProvider.notifier,
                                    )
                                    .state = index;

                                final statTitle = stat.title;
                                Widget? targetPage;

                                switch (statTitle) {
                                  case 'Total Mahasiswa':
                                    targetPage = const MahasiswaPage();
                                    break;
                                  case 'Mahasiswa Aktif':
                                    targetPage = const MahasiswaAktifPage();
                                    break;
                                  case 'Dosen':
                                    targetPage = const DosenPage();
                                    break;
                                  case 'Profile':
                                    targetPage = const ProfilePage();
                                    break;
                                }

                                if (targetPage != null) {
                                  Navigator.push(
                                    context,
                                    _createRoute(targetPage),
                                  );
                                }
                              },
                            ); // ModernStatCard
                          },
                        ), // GridView.builder
                      ],
                    ),
                  ), // SliverToBoxAdapter
                ), // SliverPadding

                const SliverPadding(
                  padding: EdgeInsets.only(bottom: 24),
                ),
              ],
            ), // CustomScrollView
          ); // RefreshIndicator
        },
      ),
    ); // Scaffold
  }

  // custome slide transisi waktu pindah page
  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve)); // Tween
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    ); // PageRouteBuilder
  }

  // conver tanggal update
  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
```

> ⚠️ **Catatan:** File ini memerlukan halaman `MahasiswaPage`, `MahasiswaAktifPage`, dan `ProfilePage` yang akan kamu buat di Step 15. Untuk sementara bisa dibuat placeholder dulu.

---

## STEP 9 - Dosen Model {#step-9}

Buat file `lib/features/dosen/data/models/dosen_model.dart`:

```dart
class DosenModel {
  final String nama;
  final String nip;
  final String email;
  final String jurusan;

  DosenModel({
    required this.nama,
    required this.nip,
    required this.email,
    required this.jurusan,
  });

  factory DosenModel.fromJson(Map<String, dynamic> json) {
    return DosenModel(
      nama: json['nama'] ?? '',
      nip: json['nip'] ?? '',
      email: json['email'] ?? '',
      jurusan: json['jurusan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'nama': nama, 'nip': nip, 'email': email, 'jurusan': jurusan};
  }
}
```

---

## STEP 10 - Dosen Repository {#step-10}

Buat file `lib/features/dosen/data/repositories/dosen_repository.dart`:

```dart
import 'package:d4tivokasi/features/dosen/data/models/dosen_model.dart';

class DosenRepository {
  /// Mendapatkan daftar dosen
  Future<List<DosenModel>> getDosenList() async {
    // Simulasi network delay
    await Future.delayed(const Duration(seconds: 1));

    // Data dummy dosen
    return [
      DosenModel(
        nama: 'Anank Prasetyo',
        nip: '123456789',
        email: 'anank.prasetyo@example.com',
        jurusan: 'Teknik Informatika',
      ),
      DosenModel(
        nama: 'Rachman Sinatriya',
        nip: '987654321',
        email: 'rachman.sinatriya@example.com',
        jurusan: 'Teknik Informatika',
      ),
      DosenModel(
        nama: 'Alfian Sukma',
        nip: '456789123',
        email: 'alfian.sukma@example.com',
        jurusan: 'Teknik Informatika',
      ),
    ];
  }
}
```

---

## STEP 11 - Dosen Provider {#step-11}

Buat file `lib/features/dosen/presentation/providers/dosen_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d4tivokasi/features/dosen/data/models/dosen_model.dart';
import 'package:d4tivokasi/features/dosen/data/repositories/dosen_repository.dart';

// Repository Provider
final dosenRepositoryProvider = Provider<DosenRepository>((ref) {
  return DosenRepository();
}); // Provider

// StateNotifier untuk mengelola state dosen
class DosenNotifier extends StateNotifier<AsyncValue<List<DosenModel>>> {
  final DosenRepository _repository;

  DosenNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadDosenList();
  }

  /// Load data dosen dalam bentuk list
  Future<void> loadDosenList() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getDosenList();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh data dosen dalam bentuk list
  Future<void> refresh() async {
    await loadDosenList();
  }
}

// Dosen Notifier Provider
final dosenNotifierProvider = StateNotifierProvider.autoDispose<
  DosenNotifier,
  AsyncValue<List<DosenModel>>
>((ref) {
  final repository = ref.watch(dosenRepositoryProvider);
  return DosenNotifier(repository);
});
```

---

## STEP 12 - Dosen Widget {#step-12}

Buat file `lib/features/dosen/presentation/widgets/dosen_widget.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:d4tivokasi/core/constants/constants.dart';
import 'package:d4tivokasi/features/dosen/data/models/dosen_model.dart';

class ModernDosenCard extends StatefulWidget {
  final DosenModel dosen;
  final VoidCallback? onTap;
  final List<Color>? gradientColors;

  const ModernDosenCard({
    Key? key,
    required this.dosen,
    this.onTap,
    this.gradientColors,
  }) : super(key: key);

  @override
  State<ModernDosenCard> createState() => _ModernDosenCardState();
}

class _ModernDosenCardState extends State<ModernDosenCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    ); // AnimationController
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors =
        widget.gradientColors ??
        [
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor.withOpacity(0.7),
        ];

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, gradientColors[0].withOpacity(0.05)],
            ), // LinearGradient
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ), // BoxShadow
            ],
            border: Border.all(
              color: gradientColors[0].withOpacity(0.1),
              width: 1,
            ), // Border.all
          ), // BoxDecoration
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar with Gradient
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    ), // LinearGradient
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors[0].withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ), // BoxShadow
                    ],
                  ), // BoxDecoration
                  child: Center(
                    child: Text(
                      widget.dosen.nama.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ), // Text
                  ), // Center
                ), // Container
                const SizedBox(width: 16),

                // Dosen Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dosen.nama,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ), // Text
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.badge_outlined,
                        'NIP: ${widget.dosen.nip}',
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        Icons.email_outlined,
                        widget.dosen.email,
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        Icons.school_outlined,
                        widget.dosen.jurusan,
                      ),
                    ],
                  ),
                ), // Expanded

                // Arrow Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: gradientColors[0].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ), // BoxDecoration
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: gradientColors[0],
                  ), // Icon
                ), // Container
              ],
            ), // Row
          ), // Padding
        ), // Container
      ), // ScaleTransition
    ); // GestureDetector
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ), // Text
        ), // Expanded
      ],
    ); // Row
  }
}

/// Widget untuk menampilkan list dosen
class DosenListView extends StatelessWidget {
  final List<DosenModel> dosenList;
  final VoidCallback? onRefresh;
  final bool useModernCard;

  const DosenListView({
    Key? key,
    required this.dosenList,
    this.onRefresh,
    this.useModernCard = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradients = AppConstants.dashboardGradients;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dosenList.length,
      itemBuilder: (context, index) {
        final dosen = dosenList[index];
        return ModernDosenCard(
          dosen: dosen,
          gradientColors: gradients[index % gradients.length],
          onTap: () {
            // Navigasi detail dosen bisa ditambahkan di sini
          },
        );
      },
    );
  }
}
```

---

## STEP 13 - Dosen Page {#step-13}

Buat file `lib/features/dosen/presentation/pages/dosen_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d4tivokasi/core/widgets/widgets.dart';
import 'package:d4tivokasi/features/dosen/presentation/providers/dosen_provider.dart';
import 'package:d4tivokasi/features/dosen/presentation/widgets/dosen_widget.dart';

class DosenPage extends ConsumerWidget {
  const DosenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dosenState = ref.watch(dosenNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Dosen'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.invalidate(dosenNotifierProvider);
            },
            tooltip: 'Refresh',
          ), // IconButton
        ],
      ), // AppBar
      body: dosenState.when(
        // State: Loading
        loading: () => const LoadingWidget(),

        // State: Error
        error: (error, stack) => CustomErrorWidget(
          message: 'Gagal memuat data dosen: ${error.toString()}',
          onRetry: () {
            ref.read(dosenNotifierProvider.notifier).refresh();
          },
        ), // CustomErrorWidget

        // State: memanggil data dosen dari dosen list dan memanggil widget
        data: (dosenList) {
          return DosenListView(
            dosenList: dosenList,
            onRefresh: () {
              ref.invalidate(dosenNotifierProvider);
            },
            useModernCard: true, // Set to false for simple card
          ); // DosenListView
        },
      ),
    ); // Scaffold
  }
}
```

---

## STEP 14 - Main.dart {#step-14}

Update file `lib/main.dart`:

```dart
import 'package:d4tivokasi/core/constants/constants.dart';
import 'package:d4tivokasi/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:d4tivokasi/features/dashboard/presentation/pages/dashboard_page.dart';

// Run | Debug | Profile
void main() {
  // runApp(const MyApp());
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: DashboardPage(),
    ); // MaterialApp
  }
}
```

---

## STEP 15 - Tugas Mandiri: Halaman Mahasiswa, Mahasiswa Aktif & Profile {#step-15}

Buat halaman-halaman berikut mengikuti pola yang sama dengan Dosen. Struktur foldernya sama.

### 15a. Placeholder sementara agar app bisa jalan

Buat file `lib/features/mahasiswa/presentation/pages/mahasiswa_page.dart`:

```dart
import 'package:flutter/material.dart';

class MahasiswaPage extends StatelessWidget {
  const MahasiswaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Mahasiswa')),
      body: const Center(child: Text('Halaman Mahasiswa - Coming Soon')),
    );
  }
}
```

Buat file `lib/features/mahasiswa_aktif/presentation/pages/mahasiswa_aktif_page.dart`:

```dart
import 'package:flutter/material.dart';

class MahasiswaAktifPage extends StatelessWidget {
  const MahasiswaAktifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mahasiswa Aktif')),
      body: const Center(child: Text('Halaman Mahasiswa Aktif - Coming Soon')),
    );
  }
}
```

Buat file `lib/features/profile/presentation/pages/profile_page.dart`:

```dart
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Halaman Profile - Coming Soon')),
    );
  }
}
```

### 15b. Model Mahasiswa (contoh untuk dikembangkan)

Buat `lib/features/mahasiswa/data/models/mahasiswa_model.dart`:

```dart
class MahasiswaModel {
  final String nama;
  final String nim;
  final String email;
  final String jurusan;
  final String status; // Aktif / Lulus / Cuti

  MahasiswaModel({
    required this.nama,
    required this.nim,
    required this.email,
    required this.jurusan,
    required this.status,
  });

  factory MahasiswaModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaModel(
      nama: json['nama'] ?? '',
      nim: json['nim'] ?? '',
      email: json['email'] ?? '',
      jurusan: json['jurusan'] ?? '',
      status: json['status'] ?? 'Aktif',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'nim': nim,
      'email': email,
      'jurusan': jurusan,
      'status': status,
    };
  }
}
```

---

## 🔧 Hal Penting yang Perlu Diperhatikan

### Penggantian nama package
Ganti semua `d4tivokasi` dengan nama package project kamu. Cek nama package di `pubspec.yaml`:
```yaml
name: nama_project_kamu   # <-- ini yang dipakai
```

### Widget Loading & Error
Pastikan kamu punya `LoadingWidget` dan `CustomErrorWidget` di `lib/core/widgets/widgets.dart`. Contoh minimal:

```dart
// lib/core/widgets/widgets.dart
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const CustomErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Coba Lagi')),
          ],
        ],
      ),
    );
  }
}

class CustomScrollView extends StatelessWidget {
  final List<Widget> slivers;
  const CustomScrollView({super.key, required this.slivers});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: slivers);
  }
}
```

### AppTheme
Pastikan `lib/core/theme/theme.dart` mendefinisikan `AppTheme` dengan field-field berikut:

```dart
// lib/core/theme/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF667eea);
  static const Color textPrimaryColor = Color(0xFF1a1a2e);
  static const Color textSecondaryColor = Color(0xFF6b7280);

  static ThemeData get lightTheme => ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    useMaterial3: true,
  );

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
  );
}
```

### pubspec.yaml
Pastikan dependency berikut sudah ada:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
```

Lalu jalankan:
```bash
flutter pub get
```

---

## ✅ Urutan Pengerjaan yang Disarankan

1. ✅ Setup AndroidManifest & build.gradle
2. ✅ Buat semua folder sekaligus
3. ✅ Buat `AppTheme` di `core/theme/theme.dart`
4. ✅ Buat `LoadingWidget` & `CustomErrorWidget` di `core/widgets/widgets.dart`
5. ✅ Update `constants.dart`
6. ✅ Buat model & repository untuk Dashboard
7. ✅ Buat provider Dashboard
8. ✅ Buat widget Dashboard
9. ✅ Buat placeholder halaman Mahasiswa, MahasiswaAktif, Profile
10. ✅ Buat Dashboard Page (butuh semua halaman di atas)
11. ✅ Update `main.dart`
12. ✅ Coba jalankan: `flutter run`
13. ✅ Buat model, repository, provider, widget, page untuk Dosen
14. ✅ Kembangkan halaman Mahasiswa, MahasiswaAktif, Profile sesuai kreativitas

---

*Selamat mengerjakan! 🚀*