import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:messini_store/pages/category_pages/category_list_page.dart';
import 'package:messini_store/pages/drivers_pages/driver_list_page.dart';
import 'package:messini_store/pages/more_pages/notification_page.dart';
import 'package:messini_store/pages/order_pages/order_list_page.dart';
import 'package:messini_store/pages/product_pages/product_list_page.dart';
import 'package:messini_store/pages/slider_pages/slider_list_page.dart';
import 'package:messini_store/pages/users_pages/user_list_page.dart';
import 'package:messini_store/utils/app_themes.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  GetStorage().writeIfNull('darkMode', false);
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  timeago.setLocaleMessages('ar_short', timeago.ArShortMessages());

  await translator.init(
    localeType: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'assets/langs/',
  );

  runApp(LocalizedApp(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Messini Store - Management",
      localizationsDelegates: translator.delegates,
      locale: translator.activeLocale,
      supportedLocales: translator.locals(),
      theme: AppThemes.lightTheme(),
      darkTheme: AppThemes.darkTheme(),
      debugShowCheckedModeBanner: false,
      themeMode:
          GetStorage().read("darkMode") ? ThemeMode.dark : ThemeMode.light,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPage = 0;
  List _pages() {
    return const [
      ProductListPage(),
      CategoryListPage(),
      SliderListPage(),
      OrderListPage(),
      UserListPage(),
      DriverListPage(),
      NotificationPage(),
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Headline6(
          "Messini Store - Management",
          style: TextStyle(
              color: AppThemes.lightGreyColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              translator.setNewLanguage(
                context,
                newLanguage:
                    translator.activeLanguageCode == 'ar' ? 'en' : 'ar',
                remember: true,
              );
            },
            icon: const Icon(Ionicons.globe_outline),
            tooltip: "language".tr(),
          ),
        ],
      ),
      drawer: MediaQuery.of(context).size.width < 600 ? appDrawer(true) : null,
      body: Row(
        children: [
          MediaQuery.of(context).size.width < 600
              ? Container()
              : appDrawer(false),
          Expanded(
            flex: 8,
            child: _pages()[_currentPage],
          )
        ],
      ),
    );
  }

  Widget appDrawer(bool goBack) {
    return SizedBox(
      width: 200,
      child: Drawer(
        child: ListView(
          controller: ScrollController(),
          padding: const EdgeInsets.all(10),
          children: [
            Padding(
              padding: const Margin.vertical(8.0),
              child: Headline6("application".tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                minLeadingWidth: 0,
                onTap: () {
                  setState(() {
                    _currentPage = 0;
                  });
                  if (goBack) Get.back();
                },
                tileColor: _currentPage == 0
                    ? Get.theme.primaryColor
                    : Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: Text(
                  "products".tr(),
                  style:
                      TextStyle(color: _currentPage == 0 ? Colors.white : null),
                ),
                leading: Icon(
                  Ionicons.shapes,
                  color: _currentPage == 0 ? Colors.white : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                minLeadingWidth: 0,
                onTap: () {
                  setState(() {
                    _currentPage = 1;
                  });
                  if (goBack) Get.back();
                },
                tileColor: _currentPage == 1
                    ? Get.theme.primaryColor
                    : Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: Text(
                  "categories".tr(),
                  style:
                      TextStyle(color: _currentPage == 1 ? Colors.white : null),
                ),
                leading: Icon(
                  Ionicons.grid,
                  color: _currentPage == 1 ? Colors.white : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                minLeadingWidth: 0,
                onTap: () {
                  setState(() {
                    _currentPage = 2;
                  });
                  if (goBack) Get.back();
                },
                tileColor: _currentPage == 2
                    ? Get.theme.primaryColor
                    : Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: Text(
                  "sliders".tr(),
                  style:
                      TextStyle(color: _currentPage == 2 ? Colors.white : null),
                ),
                leading: Icon(
                  Ionicons.albums,
                  color: _currentPage == 2 ? Colors.white : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                minLeadingWidth: 0,
                onTap: () {
                  setState(() {
                    _currentPage = 3;
                  });
                  if (goBack) Get.back();
                },
                tileColor: _currentPage == 3
                    ? Get.theme.primaryColor
                    : Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: Text(
                  "orders".tr(),
                  style:
                      TextStyle(color: _currentPage == 3 ? Colors.white : null),
                ),
                leading: Icon(
                  Ionicons.bag_handle,
                  color: _currentPage == 3 ? Colors.white : null,
                ),
              ),
            ),
            Padding(
              padding: const Margin.vertical(8.0),
              child: Headline6("users".tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                minLeadingWidth: 0,
                onTap: () {
                  setState(() {
                    _currentPage = 4;
                  });
                  if (goBack) Get.back();
                },
                tileColor: _currentPage == 4
                    ? Get.theme.primaryColor
                    : Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: Text(
                  "users".tr(),
                  style:
                      TextStyle(color: _currentPage == 4 ? Colors.white : null),
                ),
                leading: Icon(
                  Ionicons.people,
                  color: _currentPage == 4 ? Colors.white : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                minLeadingWidth: 0,
                onTap: () {
                  setState(() {
                    _currentPage = 5;
                  });
                  if (goBack) Get.back();
                },
                tileColor: _currentPage == 5
                    ? Get.theme.primaryColor
                    : Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: Text(
                  "drivers".tr(),
                  style:
                      TextStyle(color: _currentPage == 5 ? Colors.white : null),
                ),
                leading: Icon(
                  Ionicons.bicycle,
                  color: _currentPage == 5 ? Colors.white : null,
                ),
              ),
            ),
            Padding(
              padding: const Margin.vertical(8.0),
              child: Headline6("more".tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                minLeadingWidth: 0,
                onTap: () {
                  setState(() {
                    _currentPage = 6;
                  });
                  if (goBack) Get.back();
                },
                tileColor: _currentPage == 6
                    ? Get.theme.primaryColor
                    : Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: Text(
                  "notification".tr(),
                  style:
                      TextStyle(color: _currentPage == 6 ? Colors.white : null),
                ),
                leading: Icon(
                  Ionicons.notifications,
                  color: _currentPage == 6 ? Colors.white : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
