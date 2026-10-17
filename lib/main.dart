import 'package:flutter/material.dart';

void main() {
  runApp(const FlutterDemoApp());
}

class FlutterDemoApp extends StatefulWidget {
  const FlutterDemoApp({super.key});

  @override
  State<FlutterDemoApp> createState() => _FlutterDemoAppState();
}

class _FlutterDemoAppState extends State<FlutterDemoApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق فلاتر التجريبي',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D9488),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF14B8A6),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MainScreen(
          toggleTheme: _toggleTheme,
          currentThemeMode: _themeMode,
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeMode currentThemeMode;

  const MainScreen({
    super.key,
    required this.toggleTheme,
    required this.currentThemeMode,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _counter = 0;

  void _increment() => setState(() => _counter++);
  void _decrement() => setState(() => _counter > 0 ? _counter-- : 0);
  void _reset() => setState(() => _counter = 0);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screens = [
      _buildHomeScreen(colorScheme, isDark),
      _buildFeaturesScreen(colorScheme),
      _buildAboutScreen(colorScheme),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.flutter_dash, size: 28),
            SizedBox(width: 10),
            Text(
              'تطبيق فلاتر تجريبي',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'تغيير السمة',
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            tooltip: 'معلومات التطبيق',
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => _showAppInfoDialog(context),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline_rounded),
            selectedIcon: Icon(Icons.star_rounded),
            label: 'المميزات',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline_rounded),
            selectedIcon: Icon(Icons.info_rounded),
            label: 'حول',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreen(ColorScheme colors, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Hero Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [colors.primaryContainer, colors.surfaceContainerHighest]
                  : [colors.primary, colors.tertiary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.rocket_launch_rounded,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'تم تصدير التطبيق بنجاح! 🎉',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'هذا التطبيق مبني ومصدر كملف APK عبر GitHub Actions بكامل بيئة Flutter الأصلية وأحدث معايير Material 3.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Quick Stats
        const Text(
          'حالة البيئة والإطلاق',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: Icons.check_circle_rounded,
                iconColor: Colors.green,
                title: 'حالة الـ APK',
                subtitle: 'جاهز ومثبت',
                colors: colors,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                icon: Icons.speed_rounded,
                iconColor: Colors.blueAccent,
                title: 'الأداء',
                subtitle: 'أصيل 60fps',
                colors: colors,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Interactive Counter Card
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: colors.outlineVariant.withOpacity(0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'عداد تفاعلي تجريبي',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      tooltip: 'تصفير',
                      onPressed: _reset,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '$_counter',
                  style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
                const Text(
                  'عدد الضغطات المسجلة',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: _decrement,
                      icon: const Icon(Icons.remove),
                      label: const Text('طرح'),
                    ),
                    const SizedBox(width: 16),
                    FilledButton.icon(
                      onPressed: _increment,
                      icon: const Icon(Icons.add),
                      label: const Text('زيادة'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required ColorScheme colors,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
        border: BorderSide(color: colors.outlineVariant.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesScreen(ColorScheme colors) {
    final features = [
      {
        'icon': Icons.bolt_rounded,
        'title': 'بناء سريع عبر GitHub Actions',
        'desc': 'أتمتة كاملة لدورة التجميع وبناء APK بنقرة زر بدون إجهاد هاتفك.'
      },
      {
        'icon': Icons.palette_rounded,
        'title': 'تصميم Material 3 العصري',
        'desc': 'يدعم النمط الداكن والفاتح وألوان متناسقة وعناصر عصرية.'
      },
      {
        'icon': Icons.format_textdirection_r_to_l_rounded,
        'title': 'دعم اللغة العربية والـ RTL',
        'desc': 'واجهة مريحة ومحاذاة طبيعية لجميع اللغات ذات الاتجاه اليميني.'
      },
      {
        'icon': Icons.phone_android_rounded,
        'title': 'ملف APK أصيل (Native)',
        'desc': 'يعمل مباشرة على أجهزة أندرويد بأداء سلس ومستقر.'
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: features.length,
      itemBuilder: (ctx, i) {
        final item = features[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: colors.outlineVariant.withOpacity(0.4)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: colors.primaryContainer,
              child: Icon(item['icon'] as IconData, color: colors.primary),
            ),
            title: Text(
              item['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(item['desc'] as String),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAboutScreen(ColorScheme colors) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.primaryContainer.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.flutter_dash, size: 64, color: colors.primary),
              ),
              const SizedBox(height: 16),
              const Text(
                'تطبيق فلاتر التجريبي',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'الإصدار 1.0.0 (Release Build)',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: colors.outlineVariant.withOpacity(0.4)),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.code_rounded),
                title: const Text('إطار العمل'),
                subtitle: const Text('Flutter SDK 3.x / Dart 3'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.cloud_sync_rounded),
                title: const Text('نظام التصدير'),
                subtitle: const Text('GitHub Actions (CI/CD Automated)'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.android_rounded),
                title: const Text('صيغة الحزمة'),
                subtitle: const Text('Android APK (Universal Release)'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.tonal(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم التحقق بنجاح من التطبيق! ✨'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('اختبار التنبيهات (SnackBar)'),
          ),
        ),
      ],
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('عن التطبيق'),
        content: const Text(
          'تم إنشاء هذا التطبيق كنموذج جاهز للتأكد من نجاح دورة البناء والتحزيم إلى APK عبر GitHub Actions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
