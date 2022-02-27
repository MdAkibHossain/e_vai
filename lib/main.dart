import 'package:ebay_demo/auth/auth_home.dart';
import 'package:ebay_demo/firebase_options.dart';
import 'package:ebay_demo/provider/google_signin_provider.dart';
import 'package:ebay_demo/provider/products.dart';
import 'package:ebay_demo/screen/edit_product_screen.dart';
import 'package:ebay_demo/screen/product_detail_screen.dart';
import 'package:ebay_demo/screen/products_overview_screen.dart';
import 'package:ebay_demo/screen/user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Products(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthHome(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          ProductsOverviewScreen.routeName: (ctx) =>
              const ProductsOverviewScreen(),
          UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
          EditProductsScreen.routeName: (ctx) => const EditProductsScreen(),
        },
      ),
    );
  }
}
