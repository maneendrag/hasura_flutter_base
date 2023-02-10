import 'package:efc_nc/_app/app.locator.dart';
import 'package:efc_nc/_app/app.router.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final NavigationService navigationService = locator<NavigationService>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 4)).then((d){
      print("<============ Navigation Success ===========>");
      navigationService.pushNamedAndRemoveUntil(Routes.homeScreen);
    });
        }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Splash Screen", style: TextStyle(fontSize: 28, color: Colors.red),),));
  }
}

