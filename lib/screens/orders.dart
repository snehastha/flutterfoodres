import 'package:flutter/material.dart';
import 'package:flutter_res/models/cart_item.dart';

import 'package:provider/provider.dart';

import '../helpers/style.dart';
import '../providers/user.dart';
import '../widgets/customtext.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Orders"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ListView.builder(
          itemCount: userProvider.cartItems.length,
          itemBuilder: (_, index){
            List<CartItemModel> cart = userProvider.cartItems;
            return ListTile(
              leading: CustomText(
                text: "\$${cart[index].totalRestaurantSale / 100}",
                weight: FontWeight.bold,
              ),
              title: Text(cart[index].name),
              subtitle: Text(DateTime.fromMillisecondsSinceEpoch(cart[index].date).toString()),
            );
          }),
    );
  }
}