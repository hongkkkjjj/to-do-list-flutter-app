import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/Layout/Color/CustomColor.dart';
import 'package:to_do_list_app/Layout/home_screen.dart';
import 'package:to_do_list_app/Providers/to_do_details_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ToDoDetailsProvider()),
      ],
      child: _launchApp(),
    );
  }

  Widget _launchApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List App',
      theme: ThemeData(
        primaryColor: CustomColor.PrimaryColor,
        // declare the color scheme to change date picker color
        colorScheme: ColorScheme(
          primary: CustomColor.PrimaryColor,
          primaryVariant: Colors.black,
          secondary: Colors.black,
          secondaryVariant: Colors.black,
          surface: Colors.black,
          background: Colors.white,
          error: Colors.red,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onBackground: Colors.white,
          onError: Colors.red,
          brightness: Brightness.light,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
