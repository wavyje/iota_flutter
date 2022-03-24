import 'package:flutter/material.dart';

import 'Buttons.dart';


// defines a custom button design
class About extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return TextButton(onPressed: ()
    {
      showDialog(context: context, builder: (BuildContext context) {
        return Column(
            mainAxisAlignment: MainAxisAlignment
                .center,
            children: [
                  Text(
                      "About IOTA Health"),
                  Text(
                      "Author of the App: Jendrik Mann"),
                  Text(
                      "Contact: jendrik.mann@uni-oldenburg.de"),
                  Container(
                    padding: EdgeInsets
                        .all(
                        15),),
                  Text(
                      "Non-profit and open-source"),
                  Text(
                      "No association with the IOTA Foundation!"),
                  Text(
                      "What is this app about?"),
                  Text(
                      "• Prototype to test the suitability of Distributed Ledgers for health certificates"),
                  Text(
                      "• User functionalities include local data saves, certificate creation via QR-Code and certificate checking via QR-Code"),
                  Text(
                      "• Doctors and the registration office may publish certificates by scanning the QR-Code of the user"),
                  Text(
                      "• Certificates will be anonymously published on the IOTA Tangle via IOTA Streams"),
                  Text(
                      "• Certificates are therefore immutable"),
                  Text(
                      "• Doctors can and will be blacklisted, if misuse is detected!")
                ]
            );
      });
    },
      child: Text("About", style: TextStyle(color: Colors.white60),),
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 17),
      ),
    );
  }

}