import 'package:flutter/material.dart';

enum SearchBy{PRODUCTS, RESTAURANTS}

class AppProvider with ChangeNotifier{
  bool isLoading = false;


  void changeLoading(){
    isLoading = !isLoading;
    notifyListeners();
  }
}