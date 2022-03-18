import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import './certificate_upload.dart';
import './health_certificate_upload.dart';

class OfficeScan extends StatefulWidget {
  final bool doctorLoggedIn;
  final String lanr;
  OfficeScan({required Key key, required this.doctorLoggedIn, required this.lanr});
  @override
  _OfficeScanState createState() {
    return _OfficeScanState(doctorLoggedIn: doctorLoggedIn, lanr: lanr);
  }

}

class _OfficeScanState extends State<OfficeScan> {
  final bool doctorLoggedIn;
  final String lanr;
  _OfficeScanState({required this.doctorLoggedIn, required this.lanr});

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner"),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      var arr = scanData.code.split('/');
      if (arr[0] == "UploadCertificate") {
        Navigator.pop(context);
        if(!doctorLoggedIn) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                CertificateUpload(key: UniqueKey(), roomId: arr[1])),
          );
        }
        else if(doctorLoggedIn) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                HealthCertificateUpload(key: UniqueKey(), roomId: arr[1], lanr: lanr,)),
          );
        }

      }
      controller.resumeCamera();
    });
  }
}