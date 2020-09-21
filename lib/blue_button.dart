import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final String label;
  final void Function() action;
  final bool isLoading;
  final bool disable;
  final BoxDecoration decoration;
  double height, width;

  BlueButton({
    @required this.label,
    @required this.action,
    this.decoration = const BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    this.isLoading = false,
    this.disable = false,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if(height == null)
      height = size.longestSide * 0.06;
    if(width == null)
      width = double.maxFinite;

    return InkWell(
      child: Container(
        height: height,
        width: width,
        decoration: decoration,
        constraints: BoxConstraints(
          minHeight: 40,
          minWidth: 100,
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold,),
                    ),
            ),
            if (disable)
              Positioned.fill(child: Container(color: Colors.white54)),
          ],
        ),
      ),
      onTap: disable ? null : action,
    );
  }
}
