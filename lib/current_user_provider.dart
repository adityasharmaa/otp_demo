import 'package:flutter/cupertino.dart';

class CurrentUserProvider with ChangeNotifier{

  String _mobileNumber;

  String get mobileNumber{
    return _mobileNumber;
  }

  void setMobileNumber(String mobile){
    _mobileNumber = mobile;
    notifyListeners();
  }

}