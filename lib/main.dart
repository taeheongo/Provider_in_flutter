import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/common/theme.dart';
import 'package:state_management/models/cart.dart';
import 'package:state_management/models/catalog.dart';
import 'package:state_management/screens/cart.dart';
import 'package:state_management/screens/catalog.dart';
import 'package:state_management/screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MultiProvider(
      providers: [
        // In this sample app, CatalogModel never changes, so a simple Provider
        // is sufficient.
        // ChangeNotifierProvider is smart enough not to rebuild CartModel unless absolutely necessary.
        // It also automatically calls dispose() on CartModel when the instance is no longer needed.
        Provider(create: (context) => CatalogModel()),
        // CartModel is implemented as a ChangeNotifier, which calls for the use
        // of ChangeNotifierProvider. Moreover, CartModel depends
        // on CatalogModel, so a ProxyProvider is needed.

        // ProxyProvider is a provider that combines multiple values from other providers
        // into a new object, and sends the result to Provider.
        // That new object will then be updated whenever one of the providers it depends on updates.
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) {
            cart.catalog = catalog;
            return cart;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Provider Demo',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => MyLogin(),
          '/catalog': (context) => MyCatalog(),
          '/cart': (context) => MyCart(),
        },
      ),
    );
  }
}
