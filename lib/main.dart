import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:my_app/views/splash_screen/splash_screen.dart';
import 'package:my_app/views/category_screen/category_details.dart';
import 'package:get/get.dart';
import 'consts/consts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    if (kIsWeb) {
      await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: "AIzaSyB0rZtPVxOISc9e3wOJjBe4t6qtwUS9bjU",
              authDomain: "shopsphere-b0ae8.firebaseapp.com",
              projectId: "shopsphere-b0ae8",
              storageBucket: "shopsphere-b0ae8.firebasestorage.app",
              messagingSenderId: "497716734229",
              appId: "1:497716734229:web:9ed6213a301c540dabe11c"));
    } else {
      await Firebase.initializeApp();
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: darkFontGrey,
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        fontFamily: regular,
      ),
      home: const SplashScreen(), // Default screen
      getPages: [
        GetPage(
            name: '/CategoryDetails',
            page: () => CategoryDetails(title: "Baby Clothing")),
      ],
    );
  }
}
