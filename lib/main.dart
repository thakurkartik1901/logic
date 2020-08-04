import 'package:flutter/material.dart';
import 'package:oodles/provider/orders_provider.dart';
import 'package:oodles/users_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<OrderProvider>(
            create: (context) => OrderProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Test',
          home: Consumer<OrderProvider>(builder: (ctx, userProviderRef, _) {
            if (userProviderRef.items == null) {
              return CircularProgressIndicator();
            }
            return UsersScreen();
          }),
        ));
  }
}
