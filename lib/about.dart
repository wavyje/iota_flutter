import 'package:flutter/material.dart';

import 'Buttons.dart';


// defines a custom button design
class About extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return TextButton(onPressed: ()
    {
      showDialog(context: context, builder: (BuildContext context) {
        return Container(padding: EdgeInsets.all(90), child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center,
            mainAxisSize: MainAxisSize.min,
            children: [
                  Text(
                      "About IOTA Health", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(
                      "Author of the App: Jendrik Mann"),
                  Text("Contact: "),
                  Text(
                      "jendrik.mann@uni-oldenburg.de"),
                  Container(
                    padding: EdgeInsets
                        .all(
                        10),),
                  Text(
                      "Non-profit and open-source"),
                  Text(
                      "-No association with the IOTA Foundation-", textAlign: TextAlign.center,),
                  Container(padding: EdgeInsets.all(3),),
                  Text(
                      "What is this app about?", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                  Container(padding: EdgeInsets.all(4),),
                  Text(
                      "• Prototype to test the suitability of Distributed Ledgers for health certificates", textAlign: TextAlign.center),
                  Text(
                      "• User functionalities include local data saves, certificate creation via QR-Code and certificate checking via QR-Code", textAlign: TextAlign.center),
                  Text(
                      "• Doctors and the registration office may publish certificates by scanning the QR-Code of the user", textAlign: TextAlign.center),
                  Text(
                      "• Certificates will be anonymously published on the IOTA Tangle via IOTA Streams", textAlign: TextAlign.center),
                  Text(
                      "• Certificates are therefore immutable", textAlign: TextAlign.center),
                  Text(
                      "• Doctors can and will be blacklisted, if misuse is detected!", textAlign: TextAlign.center)
                ]
            ));
      });
    },
      child: Text("About", style: TextStyle(color: Colors.white60),),
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 17),
      ),
    );
  }

}