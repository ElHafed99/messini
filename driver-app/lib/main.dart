import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:store_driver/pages/home_page.dart';
import 'package:store_driver/pages/profile_page.dart';
import 'package:store_driver/splash_page.dart';
import 'package:store_driver/utils/app_themes.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  GetStorage().writeIfNull('darkMode', false);
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  await translator.init(
    localeType: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'assets/langs/',
  );

  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    Get.showSnackbar(GetSnackBar(
      title: "${message.notification!.title}",
      message: "${message.notification!.body}",
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 7),
    ));
  });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(LocalizedApp(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'appName'.tr(),
      localizationsDelegates: translator.delegates,
      locale: translator.activeLocale,
      supportedLocales: translator.locals(),
      theme: AppThemes.lightTheme(),
      darkTheme: AppThemes.darkTheme(),
      themeMode:
          GetStorage().read("darkMode") ? ThemeMode.dark : ThemeMode.light,
      home: const SplashPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  final int? selectedIndex;
  const MainPage({Key? key, this.selectedIndex}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex = widget.selectedIndex ?? 0;

  static const List pages = [
    HomePage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Ionicons.home_outline),
            activeIcon: Icon(Ionicons.home),
            label: 'home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.person_outline),
            activeIcon: Icon(Ionicons.person),
            label: 'profile'.tr(),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
