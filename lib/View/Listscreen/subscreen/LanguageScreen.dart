import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Language"),
      ),
      body: Column(
        children: [
          LanguageContainer("English","english"),
          LanguageContainer("Urdu","urdu")
        ],
      ),
    );
  }

  Widget LanguageContainer(
      String title, String subtitle
      ){
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing:  Icon(Icons.ads_click),
      ),
    );
  }

}
