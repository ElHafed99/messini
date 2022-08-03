import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:store_driver/splash_page.dart';
import 'package:store_driver/utils/app_const.dart';
import 'package:store_driver/utils/app_themes.dart';
import 'package:store_driver/utils/app_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Headline6("profile".tr(),
            style: TextStyle(
                color: AppThemes.lightGreyColor, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const Margin.all(16),
        children: [
          Center(
            child: Image.asset(
              "assets/images/logo.png",
              width: Get.width / 4,
              height: Get.width / 4,
            ),
          ),
          ListTile(
            title: Text(
              "phone".tr(),
              textAlign: TextAlign.center,
            ),
            subtitle: Headline5(
              "${FirebaseAuth.instance.currentUser!.phoneNumber}",
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(),
          ListTile(
            title: Headline6(
              "settings".tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          profileItem(
              icon: Ionicons.globe_outline,
              title: "language".tr(),
              subtitle: translator.activeLanguageCode,
              iconBackground: const Color(0xff3DB2FF),
              onTap: () {
                translator.setNewLanguage(
                  context,
                  newLanguage:
                      translator.activeLanguageCode == 'ar' ? 'en' : 'ar',
                  remember: true,
                );
              }),
          profileItem(
              icon: GetStorage().read("darkMode")
                  ? Ionicons.moon
                  : Ionicons.sunny,
              title: "theme".tr(),
              subtitle:
                  GetStorage().read("darkMode") ? "dark".tr() : "light".tr(),
              iconBackground: const Color(0xffFC5404),
              onTap: () {
                if (GetStorage().read("darkMode")) {
                  setState(() {
                    Get.changeThemeMode(ThemeMode.light);
                    GetStorage().write("darkMode", false);
                  });
                } else {
                  setState(() {
                    Get.changeThemeMode(ThemeMode.dark);
                    GetStorage().write("darkMode", true);
                  });
                }
              }),
          profileItem(
              icon: Ionicons.log_out_outline,
              title: "logout".tr(),
              subtitle: "logoutDescription".tr(),
              iconBackground: const Color(0xffDF2E2E),
              onTap: () {
                AppWidgets().MyDialog(
                    context: context,
                    asset: const Icon(
                      Ionicons.information_circle,
                      size: 80,
                      color: Colors.white,
                    ),
                    background: Color(0xff3DB2FF),
                    title: "logout".tr(),
                    subtitle: "logoutConfirm".tr(),
                    confirm: ElevatedButton(
                        onPressed: () async {
                          await FirebaseMessaging.instance
                              .unsubscribeFromTopic("driver");
                          await FirebaseMessaging.instance.unsubscribeFromTopic(
                              "${GetStorage().read('driverData')['id']}");

                          await FirebaseAuth.instance
                              .signOut()
                              .then((value) => Get.offAll(() => SplashPage()));
                        },
                        child: Text("yes".tr())),
                    cancel: ElevatedButton(
                        onPressed: () async {
                          Get.back();
                        },
                        style: Get.theme.elevatedButtonTheme.style!.copyWith(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xffDF2E2E))),
                        child: Text("no".tr())));
              }),
          ListTile(
            title: Headline6(
              "aboutApp".tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          profileItem(
              icon: Ionicons.information,
              title: "appName".tr(),
              subtitle: "version".tr(),
              iconBackground: const Color(0xff3DB2FF)),
          profileItem(
              icon: Ionicons.shield_half,
              title: "privacyPolicy".tr(),
              subtitle: "privacyPolicyDescription".tr(),
              iconBackground: const Color(0xffDF2E2E),
              onTap: () async {
                if (!await launchUrl(Uri.parse(AppConst.privacyPolicyLink)))
                  throw 'Could not launch';
              }),
        ],
      ),
    );
  }

  Widget profileItem(
      {required IconData icon,
      required Color iconBackground,
      required String title,
      required String subtitle,
      Function()? onTap}) {
    return StatefulBuilder(builder: (context, _) {
      return Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: EdgeRadius.all(10)),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: EdgeRadius.all(10)),
          onTap: onTap,
          trailing: onTap != null
              ? Icon(translator.activeLanguageCode == 'ar'
                  ? Ionicons.chevron_back
                  : Ionicons.chevron_forward)
              : null,
          leading: Card(
            shape: RoundedRectangleBorder(borderRadius: EdgeRadius.all(10)),
            color: iconBackground,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(
            subtitle,
          ),
        ),
      );
    });
  }
}
