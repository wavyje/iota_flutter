import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({required this.onPressed, required this.buttonText, required this.icon});
  final GestureTapCallback onPressed;
  final String buttonText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.white,
      splashColor: //Colors.pinkAccent
      Color.fromRGBO(255, 195, 193, 1),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: Color.fromRGBO(255, 195, 193, 1),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              buttonText,
              maxLines: 1,
              style: TextStyle(color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}
