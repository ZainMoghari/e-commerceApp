import 'package:ecommerceapp1/HomePage.dart';
import 'package:flutter/material.dart';
 
void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<StatefulWidget> createState() => _MyAppState();
        
  
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext con){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}