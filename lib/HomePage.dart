import 'package:ecommerceapp1/details.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {

  List categories=[
    {
      "iconname":Icons.laptop,
      "title":"Laptop"
    },
    {
      "iconname":Icons.phone_android_rounded,
      "title":"Phone"
    },
    {
      "iconname":Icons.pedal_bike,
      "title":"Bikes"
    },
    {
      "iconname":Icons.card_giftcard,
      "title":"Gifts"
    },
    {
      "iconname":Icons.table_restaurant,
      "title":"Tables"
    },
    ];
  List Items=[
    {
      "image":"images/headphone.png",
      "title":"HeadPhone",
      "subtitle":"Description",
      "price":"350\$"
    },
    {
      "image":"images/smart.png",
      "title":"Smart Watch",
      "subtitle":" 12 hours battery",
      "price":"150\$"
    },
    {
      "image":"images/headphone.png",
      "title":"Labtop",
      "subtitle":"Description",
      "price":"350\$"
    },
    {
      "image":"images/smart.png",
      "title":"Smart Watch",
      "subtitle":"Description 12 hours battery",
      "price":"150\$"
    },
  ];
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      hintText: "Search", // ✅ تم تصحيحها------------------------------------------------------search bar---------------------------------------
                      border: InputBorder.none,
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(Icons.menu, size: 40),
                ),
              ],
            ),
            SizedBox(height:26 ),
            Text(
              "Categories",//------------------------------------------------------------------------categories--------------------------------------------------------------
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
            SizedBox(height: 10),
            Container(
              height: 92,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
               itemBuilder: (context, i){
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                       Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(categories[i]['iconname'],size: 32,),
                    padding: EdgeInsets.all(15),
                    ),
                    Text(
                      categories[i]['title']
                      ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                      )
                    ],
                  ),
                );
               }
                
                
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Best Selling",//------------------------------------------------------------------------------------Best Selling-------------------------------------------------
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GridView.builder(
              itemCount: Items.length,
              shrinkWrap: true, // ✅ مهم جداً
              physics: NeverScrollableScrollPhysics(), 
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 200),
             itemBuilder: (context, i) { 
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => itemdetails(data: Items[i],)));
                  },
                  child: Card(
                     surfaceTintColor: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Container(
                          color: Colors.grey[10],
                            child:  Image.asset(
                              Items[i]['image'],//-----------------------------------------------------------headphone-------------------------------------------
                             height: 92,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                          Text(Items[i]['title'],style: TextStyle(fontWeight: FontWeight.bold), ),
                          Text(Items[i]['subtitle'],style: TextStyle(fontSize: 14, color:Colors.grey[400] ), ),
                          Container(height: 0,),
                          Text(Items[i]['price'],style: TextStyle(fontSize: 14, color:Colors.amber[700],fontWeight: FontWeight.bold ),),
                      ],
                    ),
                  ),
                );
             }
              
            ),
          ],
        ),
      ),
    );
  }

}
