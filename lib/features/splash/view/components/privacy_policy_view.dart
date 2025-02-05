import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PrivacyPolicyView extends StatelessWidget {
 const PrivacyPolicyView({super.key});

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text("Privacy & Policy"),
     ),
     body: InAppWebView(
       initialUrlRequest: URLRequest(
         url: WebUri.uri(Uri.parse('https://venturo.id')),
       ),
     ),
   );
 }
}
