import 'package:demo/current_user_provider.dart';
import 'package:demo/firebase_auth.dart';
import 'package:demo/otp_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  static final route = "home/";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentUser =
        Provider.of<CurrentUserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async{
              await Auth().signOut();
              Navigator.of(context).pushReplacementNamed(OtpLoginScreen.route);
            },
          ),
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Center(
          child: Text(
            "Login Success ${currentUser.mobileNumber}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
