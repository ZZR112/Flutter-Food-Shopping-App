import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grub_go/model/buger_model.dart';
import 'package:grub_go/model/mexican_model.dart';
import 'package:grub_go/model/category_model.dart';
import 'package:grub_go/model/chinese_model.dart';
import 'package:grub_go/model/pizza_model.dart';
import 'package:grub_go/pages/detail_page.dart';
import 'package:grub_go/service/burger_data.dart';
import 'package:grub_go/service/category_data.dart';
import 'package:grub_go/service/chinese_data.dart';
import 'package:grub_go/service/database.dart';
import 'package:grub_go/service/mexican_data.dart';
import 'package:grub_go/service/pizza_data.dart';
import 'package:grub_go/service/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  List<PizzaModel> pizza = [];
  List<BugerModel> burger = [];
  List<ChineseMordel> chinese = [];
  List<MexicanModel> mexican = [];
  String track = "0";
  bool search = false;
  TextEditingController searchcontroller = new TextEditingController();

  @override
  void initState() {
    categories = getCategories();
    pizza = getPizza();
    burger = getBurger();
    chinese = getChinese();
    mexican = getMexican();

    super.initState();
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });

    var CapitalizeValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['Name'].startsWith(CapitalizeValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 20.0, top: 40.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "images/grubgo1.png",
                      height: 80,
                      width: 180,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      "Order your favourite food!",
                      style: AppWidget.SimpleTextFeildStyle(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "images/boy.jpg",
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0),
                    margin: EdgeInsets.only(right: 20.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: searchcontroller,
                      onChanged: (value) {
                        initiateSearch(value.toUpperCase());
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search food item...",
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10.0),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xffef2b39),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      search
                          ? GestureDetector(
                            onTap: () {
                              setState(() {
                                searchcontroller.clear();
                                queryResultSet.clear();
                                tempSearchStore.clear();
                                search = false;
                              });
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          )
                          : Icon(Icons.search, color: Colors.white, size: 30.0),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              height: 70,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryTile(
                    categories[index].name!,
                    categories[index].image!,
                    index.toString(),
                  );
                },
              ),
            ),

            SizedBox(height: 10.0),
            search
                ? Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.69,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 15.0,
                      ),
                      itemCount: tempSearchStore.length,
                      itemBuilder: (context, index) {
                        return FoodTile(
                          tempSearchStore[index]['Name'],
                          tempSearchStore[index]['Image'],
                          tempSearchStore[index]['Price'],
                        );
                      },
                    ),
                  ),
                )
                : track == "0"
                ? Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.69,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 15.0,
                      ),
                      itemCount: pizza.length,
                      itemBuilder: (context, index) {
                        return FoodTile(
                          pizza[index].name!,
                          pizza[index].image!,
                          pizza[index].price!,
                        );
                      },
                    ),
                  ),
                )
                : track == "1"
                ? Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.69,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 15.0,
                      ),
                      itemCount: burger.length,
                      itemBuilder: (context, index) {
                        return FoodTile(
                          burger[index].name!,
                          burger[index].image!,
                          burger[index].price!,
                        );
                      },
                    ),
                  ),
                )
                : track == "2"
                ? Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.69,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 15.0,
                      ),
                      itemCount: chinese.length,
                      itemBuilder: (context, index) {
                        return FoodTile(
                          chinese[index].name!,
                          chinese[index].image!,
                          chinese[index].price!,
                        );
                      },
                    ),
                  ),
                )
                : track == "3"
                ? Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.69,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 15.0,
                      ),
                      itemCount: mexican.length,
                      itemBuilder: (context, index) {
                        return FoodTile(
                          mexican[index].name!,
                          mexican[index].image!,
                          mexican[index].price!,
                        );
                      },
                    ),
                  ),
                )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget FoodTile(String name, String image, String price) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, top: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              image,
              height: 100, // Further reduced to save space
              width: 125,
              fit: BoxFit.contain,
            ),
          ),
          Text(name, style: AppWidget.boldTextFeildStyle()),
          Text("\₱" + price, style: AppWidget.priceTextFeildStyle()),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DetailPage(
                            image: image,
                            name: name,
                            price: price,
                          ),
                    ),
                  );
                },

                child: Container(
                  height: 50,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Color(0xffef2b39),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget CategoryTile(String name, String image, String categoryindex) {
    return GestureDetector(
      onTap: () {
        track = categoryindex.toString();
        setState(() {});
      },
      child:
          track == categoryindex
              ? Container(
                margin: EdgeInsets.only(right: 20.0, bottom: 10.0),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),

                    decoration: BoxDecoration(
                      color: Color(0xffef2b39),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          image,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10.0),
                        Text(name, style: AppWidget.WhiteTextFeildStyle()),
                      ],
                    ),
                  ),
                ),
              )
              : Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                margin: EdgeInsets.only(right: 20.0, bottom: 10.0),
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      image,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 10.0),
                    Text(name, style: AppWidget.SimpleTextFeildStyle()),
                  ],
                ),
              ),
    );
  }
}
