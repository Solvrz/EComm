import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/screens/product.dart';

class CategoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      "name": "Parker",
      "img":
          "https://images-na.ssl-images-amazon.com/images/I/51OCvyegJcL._SX466_.jpg",
      "price": "99"
    },
    {
      "name": "Parker",
      "img":
          "https://images-na.ssl-images-amazon.com/images/I/51OCvyegJcL._SX466_.jpg",
      "price": "99"
    },
    {
      "name": "Parker",
      "img":
          "https://images-na.ssl-images-amazon.com/images/I/51OCvyegJcL._SX466_.jpg",
      "price": "99"
    },
    {
      "name": "Parker",
      "img":
          "https://images-na.ssl-images-amazon.com/images/I/51OCvyegJcL._SX466_.jpg",
      "price": "99"
    },
    {
      "name": "Parker",
      "img":
          "https://images-na.ssl-images-amazon.com/images/I/51OCvyegJcL._SX466_.jpg",
      "price": "99"
    },
    {
      "name": "Parker",
      "img":
          "https://images-na.ssl-images-amazon.com/images/I/51OCvyegJcL._SX466_.jpg",
      "price": "99"
    },
    {
      "name": "Parker",
      "img":
          "https://images-na.ssl-images-amazon.com/images/I/51OCvyegJcL._SX466_.jpg",
      "price": "99"
    },
    {
      "name": "Parker",
      "img":
          "https://images-na.ssl-images-amazon.com/images/I/51OCvyegJcL._SX466_.jpg",
      "price": "99"
    },
    {
      "name": "Parker",
      "img":
          "https://images-na.ssl-images-amazon.com/images/I/51OCvyegJcL._SX466_.jpg",
      "price": "99"
    },
    {
      "name": "Parker",
      "img":
          "https://images-na.ssl-images-amazon.com/images/I/51OCvyegJcL._SX466_.jpg",
      "price": "99"
    },
    {
      "name": "Parker",
      "img":
          "https://images-na.ssl-images-amazon.com/images/I/51OCvyegJcL._SX466_.jpg",
      "price": "99"
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    CategoryArguments args = ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, "/cart"),
            child: Icon(Icons.shopping_cart),
            backgroundColor: kUIAccent),
        appBar: AppBar(
          title: Text(
            args.title,
            style: TextStyle(color: kUILightText),
          ),
        ),
        body: products.isNotEmpty && args.title == "Pens"
            ? Scrollbar(
                child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(context, "/product",
                            arguments: ProductArguments(
                                products[index]["name"],
                                products[index]["img"],
                                products[index]["price"])),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: ListTile(
                              leading: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18.0)),
                                child: Image.network(products[index]["img"]),
                              ),
                              trailing: Text(
                                "₹ ${products[index]["price"]}",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 15),
                              ),
                              title: Text(products[index]["name"])),
                        ),
                      );
                    }),
              )
            : Center(child: Text("No products available")),
      ),
    );
  }
}

class CategoryArguments {
  String title;

  CategoryArguments(this.title);
}
