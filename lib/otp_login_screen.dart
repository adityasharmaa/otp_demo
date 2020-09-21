import 'package:demo/current_user_provider.dart';
import 'package:demo/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'blue_button.dart';
import 'config/my_colors.dart';
import 'grey_text_field.dart';

class OtpLoginScreen extends StatefulWidget {
  static const route = "/otp_login_screen";
  @override
  _OtpLoginScreenState createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  bool _enterMobileNumberMode = true;
  final _mobileNumberController = TextEditingController();
  final _otpController = TextEditingController();
  final _scaffold = GlobalKey<ScaffoldState>();
  bool _loading = false;
  String _verificationId;
  String _mobileNumber;
  int _forceResendingToken;

  void _showMessage(String message) {
    _scaffold.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _takeDecision(bool success, UserCredential result) {
    if (success) {
      Navigator.of(context).pushReplacementNamed(Home.route);
      print("Login Success : UserId: " + result.user.uid);
    } else
      _showMessage("Error Signing In!");
  }

  void _verifyPhoneNumber() async {
    if (_mobileNumberController.text.toString().length != 10) {
      _showMessage("Invalid mobile number");
      return;
    }

    setState(() {
      _loading = true;
    });

    _mobileNumber = _mobileNumberController.text.toString();
    Provider.of<CurrentUserProvider>(
      context,
      listen: false,
    ).setMobileNumber("+91$_mobileNumber");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91" + _mobileNumber,
      verificationCompleted: (authCredential) =>
          _verificationComplete(authCredential),
      verificationFailed: (authException) => _verificationFailed(authException),
      codeAutoRetrievalTimeout: (verificationId) =>
          _codeAutoRetrievalTimeout(verificationId),
      // called when the SMS code is sent
      codeSent: (verificationId, [code]) => _smsCodeSent(
        verificationId,
        [code],
      ),
      forceResendingToken: _forceResendingToken,
    );
  }

  void _verificationComplete(AuthCredential authCredential) async {
    final authResult =
        await FirebaseAuth.instance.signInWithCredential(authCredential);

    bool success = authResult.user != null;

    setState(() {
      _loading = false;
    });

    _takeDecision(success, authResult);
  }

  void _smsCodeSent(String verificationId, List<int> code) {
    // set the verification code so that we can use it to log the user in

    setState(() {
      _enterMobileNumberMode = false;
      _loading = false;
    });

    _verificationId = verificationId;
    _forceResendingToken = code[0];
    print("OTP Sent");
  }

  void _verificationFailed(FirebaseAuthException authException) {
    setState(() {
      _loading = false;
    });
    print("Verification Failed: " + authException.message);
    _showMessage("Verification Failed!");
  }

  void _codeAutoRetrievalTimeout(String verificationId) {
    setState(() {
      _enterMobileNumberMode = false;
      _loading = false;
    });
    // set the verification code so that we can use it to log the user in
    _verificationId = verificationId;
    print("Code autoretrieval timeout");
  }

  void _signInWithOTP(String smsCode) async {
    setState(() {
      _loading = true;
    });

    try {
      final result = await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: smsCode,
        ),
      );

      bool success = result.user != null;

      _takeDecision(success, result);
    } catch (e) {
      _showMessage("Error Signing In!");
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffold,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: height,
        width: width,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_enterMobileNumberMode)
                      Container(
                        height: height * 0.072,
                        width: height * 0.072,
                        margin: EdgeInsets.only(bottom: 7),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(
                            color: Colors.grey[300],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "+91",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    Expanded(
                      child: SizedBox(
                        child: GreyTextField(
                          hint:
                              _enterMobileNumberMode ? "Mobile number" : "OTP",
                          controller: _enterMobileNumberMode
                              ? _mobileNumberController
                              : _otpController,
                          enabled: !_loading,
                          maxLength: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: 10),
                BlueButton(
                  isLoading: _loading,
                  label: _enterMobileNumberMode ? "Send OTP" : "Login",
                  action: _enterMobileNumberMode
                      ? _verifyPhoneNumber
                      : () {
                          _signInWithOTP(_otpController.text.toString());
                        },
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: RadialGradient(
                      colors: [
                        MyColors.themeLight,
                        MyColors.themeDark,
                      ],
                      center: Alignment(0, 0),
                      radius: 5,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                if (!_enterMobileNumberMode)
                  Row(
                    children: <Widget>[
                      Expanded(child: SizedBox()),
                      InkWell(
                        child: Text(
                          "Resend",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        onTap: _verifyPhoneNumber,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
