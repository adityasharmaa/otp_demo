import 'package:demo/current_user_provider.dart';
import 'package:demo/home.dart';
import 'package:demo/otp_login_screen.dart';
import 'package:demo/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: CurrentUserProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        routes: {
          Home.route: (_) => Home(),
          OtpLoginScreen.route: (_) => OtpLoginScreen(),
        },
      ),
    );
  }
}
