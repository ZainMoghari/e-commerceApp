import 'package:flutter/material.dart';

class itemdetails extends StatefulWidget {
  final data;
  const itemdetails({super.key, this.data});

  @override
  State<itemdetails> createState() => _itemdetailsState();
}

class _itemdetailsState extends State<itemdetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedItemColor: Colors.black,
        unselectedFontSize: 0,
        
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: "*"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined),label: "*"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline),label: "*"),
      ]),
      endDrawer: Drawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shop_two_outlined, color: Colors.black),
            Text(" Zain ", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "Shop",
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.grey[200],
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          Image.asset(widget.data['image']),
          Container(
            child: Text(
              widget.data['title'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            child: Text(
              widget.data['subtitle'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 20, top: 10),
            child: Text(
              widget.data['price'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontSize: 18,
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Color : ", style: TextStyle(color: Colors.grey[500])),
                SizedBox(width: 6),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                Text(" Gray"),
                SizedBox(width: 20),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.orange, width: 1),
                  ),
                ),

                Text(" Black"),
              ],
            ),
          ),
          Container(
            child: Text(
              " Size :    39    40    41    42    43",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500]),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 60,vertical: 10),
            padding: EdgeInsets.all(10),
            child: MaterialButton(
              color: Colors.black,
              textColor: Colors.white,
              
              onPressed: () {},
              child: Text(
                
                "Add To Cart",
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
