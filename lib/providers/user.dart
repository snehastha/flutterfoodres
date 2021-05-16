import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_res/helpers/order.dart';
import 'package:flutter_res/helpers/poduct.dart';
import 'package:flutter_res/helpers/restaurant.dart';
import 'package:flutter_res/models/order.dart';
import 'package:flutter_res/models/products.dart';
import 'package:flutter_res/models/restaurant.dart';
import 'package:uuid/uuid.dart';


enum Status{Uninitialized, Authenticated, Authenticating, Unauthenticated}

class UserProvider with ChangeNotifier{
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  OrderServices _orderServices = OrderServices();
  RestaurantServices _restaurantServices = RestaurantServices();
  ProductServices _productServices = ProductServices();
  RestaurantModel _restaurant;
  List<ProductModel> products = <ProductModel>[];




//  getter
  Status get status => _status;
  User get user => _user;
  RestaurantModel get restaurant =>_restaurant;

  // public variables
  List<OrderModel> orders = [];

  final formkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();


  UserProvider.initialize(): _auth = FirebaseAuth.instance{
    _auth.authStateChanges().listen(_onStateChanged);
  }

  Future<bool> signIn()async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email.text.trim(), password: password.text.trim());
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }


  Future<bool> signUp()async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email.text.trim(), password: password.text.trim()).then((result){
        _firestore.collection('restaurants').doc(result.user.uid).set({
          'name':name.text,
          'email':email.text,
          'uid':result.user.uid,
          "avgPrice":0.0,
          "image": "",
          "popular":false,
          "rates":0,
          "rating":0.0,

        });
      });
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut()async{
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController(){
    name.text = "";
    password.text = "";
    email.text = "";
  }

  Future<void> reload()async{
    _restaurant = await _restaurantServices.getRestaurantById(id:user.uid);
    notifyListeners();
  }


  Future<void> _onStateChanged(User firebaseUser) async{
    if(firebaseUser == null){
      _status = Status.Unauthenticated;
    }else{
      _user = firebaseUser;
      _status = Status.Authenticated;
      await loadProductsByRestaurant(restaurantId: user.uid);
      _restaurant = await _restaurantServices.getRestaurantById(id:user.uid);
    }
    notifyListeners();
  }


  getOrders()async{
    orders = await _orderServices.getUserOrders(userId: _user.uid);
    notifyListeners();
  }

  Future<bool> removeFromCart({Map cartItem})async{
    print("THE PRODUC IS: ${cartItem.toString()}");

    try{
//      _userServicse.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }
  Future loadProductsByRestaurant({String restaurantId})async{
    products = await _productServices.getProductsByRestaurant(id: restaurantId);
    notifyListeners();
  }
}