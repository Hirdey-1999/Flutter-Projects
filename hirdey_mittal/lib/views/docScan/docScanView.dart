import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class docScanView extends StatefulWidget {
  const docScanView({Key? key}) : super(key: key);

  @override
  State<docScanView> createState() => _docScanViewState();
}

class _docScanViewState extends State<docScanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Document Scanner')),
    );
  }
}