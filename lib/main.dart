import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_res/providers/app.dart';
import 'package:flutter_res/providers/category.dart';
import 'package:flutter_res/providers/product.dart';
import 'package:flutter_res/providers/restaurant.dart';
import 'package:flutter_res/providers/user.dart';
import 'package:flutter_res/screens/dashboard.dart';
import 'package:flutter_res/screens/login.dart';
import 'package:flutter_res/widgets/loading.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
      providers: [
       ChangeNotifierProvider.value(value: AppProvider()),
        ChangeNotifierProvider.value(value: UserProvider.initialize()),
       ChangeNotifierProvider.value(value: CategoryProvider.initialize()),
//        ChangeNotifierProvider.value(value: RestaurantProvider.initialize()),
        ChangeNotifierProvider.value(value: ProductProvider.initialize()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Food App admin',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: LoginScreen())));
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserProvider>(context);
    switch (auth.status) {
      case Status.Uninitialized:
        return Loading();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return LoginScreen();
      case Status.Authenticated:
        return DashboardScreen();
      default:
        return LoginScreen();
    }
  }
}