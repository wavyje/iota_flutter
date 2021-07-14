import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import './certificate_upload.dart';

class CustomerScan extends StatefulWidget {
  @override
  _CustomerScanState createState() => _CustomerScanState();
}

class _CustomerScanState extends State<CustomerScan> {

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
        title: Text("Qr Code scannen"),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CertificateUpload(key: UniqueKey(), roomId: arr[1])),
        );
      }
      controller.resumeCamera();
    });
  }
}