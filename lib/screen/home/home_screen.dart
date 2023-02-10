import 'package:efc_nc/screen/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeScreenViewModel>.reactive(
        viewModelBuilder: ()=> HomeScreenViewModel(),
        onViewModelReady: (model)=> model.fetchHomeData(),
        builder: (context, model, child){
          return model.isBusy == true ? Center(child: CircularProgressIndicator(color: Colors.yellow,))
              : Scaffold(
            body: Container(
                color: Colors.teal,
                child: Center(
                  child: Text("${model.homeResponse?.users![0].apartmentNo}",
                      style: TextStyle(fontSize: 42, color: Colors.white, fontWeight: FontWeight.bold)),
                )),
          );
        });

  }
}
