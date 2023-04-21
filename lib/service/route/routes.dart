import 'package:chattyhive/screens/login_screen.dart';
import 'package:chattyhive/screens/profile_screen.dart';
import 'package:chattyhive/screens/search_screen.dart';
import 'package:chattyhive/service/route/routes_name.dart';
import 'package:flutter/material.dart';

import '../../screens/home_screen.dart';
import '../../screens/register_screen.dart';

class Routes{
  static Route<dynamic> generateRoutes(RouteSettings settings){
    switch(settings.name){
      case RoutesName.home:
      return MaterialPageRoute(builder: (context)=>const HomeScreen());
      case RoutesName.login:
      return MaterialPageRoute(builder: (context)=>const LoginScreen());
      case RoutesName.register:
      return MaterialPageRoute(builder: (context)=>const RegisterScreen());
      case RoutesName.profile:
      return MaterialPageRoute(builder: (context)=>const ProfileScreen());
      case RoutesName.search:
      return MaterialPageRoute(builder: (context)=>const SearchScreen());
      
     default:
     return MaterialPageRoute(builder: (_){
      return const Scaffold(
        body: Center(child: Text("404 error screen not found")),
      );
     }
     
     );
    }
  }
}