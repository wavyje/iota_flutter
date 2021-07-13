import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/scheduler.dart';

class LoadingScreen extends StatefulWidget {
 State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  bool dialogHidden = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Demo'),
        ),
        body: Builder(
            builder: (BuildContext context) {

                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(backgroundImage: Image
                                .asset('assets/images/IOTA_Spawn.gif')
                                .image,
                              radius: 100,

                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 0, top: 10, right: 0, bottom: 0),
                            ),
                            new Text("Loading", style:
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 8,
                              fontSize: 20,
                            ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                );


              return Container(
                child: Center(
                  child: Text('Dialog Sample'),
                ),
              );
            }
        )
    );
  }


}


