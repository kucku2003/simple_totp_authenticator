import 'package:flutter/material.dart';
import 'package:base32/base32.dart';
import 'package:my_totp/models/setup-model.dart';
import 'package:provider/provider.dart';
import '../models/app-model.dart';
import '../screens/qr-scan-page.dart';

class SetupPage extends StatefulWidget {
  SetupPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppModel,SetupModel>(
      builder: (context, appModel, setupModel, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.disabled,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Enter description of the new account',
                labelText: 'Account name (*)',
              ),
              initialValue: setupModel.name,
              onChanged: (String value) {
                setupModel.setName(value);
              },
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.always,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                hintText: 'Enter secret key',
                labelText: 'Key (*)',
                suffixIcon: IconButton (
                  icon: Icon(Icons.qr_code),
                  onPressed: () => {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => QRScanPage(title: 'Scan QR Code')),            
                    ),
                  }
                ),
              ),
              initialValue: setupModel.key,
              onChanged: (String value) {
                setupModel.setKey(value);
              },
              validator: (String value) {
                try {
                  base32.decode(value);
                } on FormatException catch (_) {
                  return 'Invalid key format';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  label: Text('Add new account'),
                  icon: Icon(Icons.save),
                  onPressed: () => {
                    appModel.addOTP(setupModel.name, setupModel.key),
                    setupModel.setName(""),
                    setupModel.setKey(""),
                    Navigator.pop(context)
                  },
                ),
              )
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.pop(context)
          },
          child: Icon(Icons.arrow_back),
        ), 
      )
    );
  }
}