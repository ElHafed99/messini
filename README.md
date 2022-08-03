## ​Welcome to

# **Messini Store**

| ##### **User app** | ##### **Driver app** | ##### **Control panel** |
| --- | --- | --- |
| phone: any \| password: any | phone: +213657193123 \| password: 123456 |     |
| [Download app](https://github.com/ElHafed99/messini/blob/main/app-file/messini-user.apk) | [Download app](https://github.com/ElHafed99/messini/blob/main/app-file/messini-driver.apk) | [Open Website](https://messini.aftersad.com) |

##### Help Me grow 🙏

el.hafed.messini@gmail.com

![GitHub  aha999/DonateButtons This is a repository for various donate  buttons for github etc, anyone can contribute and add new styles](https://raw.githubusercontent.com/aha999/DonateButtons/master/Paypal.png)

##### Welcome to any questions 👋

[Facebook](https://m.me/el.hafed.99) | [Email](mailto:el.hafed.messini@gmail.com)

---

## Screenshoot:

### 🧑 User app:

### 🚚 Driver app:

### ⚙ Control panel:

---

✨ Apps Features

**🌍 Multi Language**

🌙 **Dark/Light mode**

💫 **Easy setup**

**✅Easy to use**

**👨‍💻 ready for developers**

**and many more .....**

---

# 🛠Quick Setup (Make each app separately):

### Change **app name**:

```javascript
on app directory open:  android/app/src/main/AndroidManifest.xml

on <application ...> edit android:label="YOUR APP NAME"
```

### Change **app colors**:

```javascript
on app directory open:  lib/utils/app_themes.dart

go to line to this two line and edit primary and main color

static const primaryColor = Color(0xff019267);
static const mainColor = Color(0xff00C897);
```

![](data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw==)![](data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw== "Click and drag to move")

### 🔗Change **app url, currency, fee, google map api key and privacy policy link**

```javascript
on app directory open:  lib/utils/app_const.dart and edit settings
```

![](data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw==)![](data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw== "Click and drag to move")

### 🖼Change **app logo**:

```javascript
go to:  assets/images folder and replace logo.png with yours
```

```javascript
go to terminal and run:  
    flutter pub get
    flutter pub run flutter_launcher_icons:main
```

![](data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw==)![](data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw== "Click and drag to move")

---

# 🌐Server Setup

```
1- Import db.sql file to your PhpMyAdmin
2- Upload api.php and db.php files to your server
3- Edit db.php file with your database information
```

![](data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw==)![](data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw== "Click and drag to move")

---

# 🏗 build apk/aab file (user and driver app only)

- create keystore to sign app: [Create keystore](https://docs.flutter.dev/deployment/android#create-an-upload-keystore)

```javascript
go to:  android/ folder and replace messini-store.jks with yours
```

```javascript
open:  android/key.properties file and fill it with your key password
```

```javascript
go to terminal and run:  
    flutter build apk
    or
    flutter build aab
```

![](data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw==)![](data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw== "Click and drag to move")

# 🏗 Build web app ( control panel app only )

```javascript
go to terminal and run:  
    flutter build web --release
upload your web build folder content to your server
```

![](data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw==)![](data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw== "Click and drag to move")

---


​
