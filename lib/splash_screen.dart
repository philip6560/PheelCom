import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pheel_com/pheelcom_api.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pheel_com/UI responsiveness.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  List mtn_plan = [], glo_plan = [], airtel_plan = [], etisalat_plan= [];

  final Connectivity connectivity = Connectivity();

  StreamSubscription<ConnectivityResult> connectivitySubscription;

   checkConnectivity() async{
    ConnectivityResult result;
    try{
      // function called to check connectivity to the internet
      result = await connectivity.checkConnectivity();
      print('result:$result');
    }
    on PlatformException catch(error){
      print('platform error:$error');
    }

    // called to return null if this widget no longer exist in the widget tree
    // and a message is to be passed by this function
    if(!mounted){
      return Future.value(null);
    }


    if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
      Fluttertoast.showToast(
        msg: 'Connecting',
        textColor: Colors.black,
        backgroundColor: Colors.white,
      );
    }
    else{
      Fluttertoast.showToast(
        msg: 'check your internet connection',
        textColor: Colors.black,
        backgroundColor: Colors.white,
      );
    }

  }

  loading() async{
    Plan instance = Plan();
    await instance.getPlans();
    setState(() {
      mtn_plan = instance.mtn_plan;
      glo_plan = instance.glo_plan;
      airtel_plan = instance.airtel_plan;
      etisalat_plan = instance.etisalat_plan;
    });
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'mtn_plan': instance.mtn_plan,
      'glo_plan': instance.glo_plan,
      'airtel_plan': instance.airtel_plan,
      '9mobile_plan': instance.etisalat_plan,
    });
  }


  @override
  void initState() {
    super.initState();
    // function called to check if there is internet connection when this page is built
    checkConnectivity();
    // function called to check when there's a change in the inter connection
    connectivitySubscription = connectivity.onConnectivityChanged.listen((event)=> checkConnectivity());
    // function to get plans
    loading();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    connectivitySubscription.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.only(top: scale_height(33.1, context), bottom: scale_height(3.5, context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 210.0, height: 53.0,
                child: Stack(
                  children: [
                    Container(child: Image.asset('assets/logo.png')),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          child: Text('#TheDataPlug', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0, color: Colors.white,),)
                      ),
                    ),
                  ],
                ),
              ),
            ),
//              Container(
//                  child: Text('Powered by: HWP Labs', style: TextStyle(fontStyle: FontStyle.italic),)
//              ),
            Column(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: scale_height(5.0, context)),
                    child:  CircularProgressIndicator(backgroundColor: Colors.white, valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      child: Text('© 2020 | HWP Labs', style: TextStyle(letterSpacing: 1.0, fontSize: scale_width(2.9, context), color: Colors.white,),)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//child: SpinKitRing(color: Colors.white, size: 40.0, lineWidth: 5.0,),
//margin: EdgeInsets.only(top: MediaQuery.of(context).size.height > 800 ? 330.0 : 200, bottom: MediaQuery.of(context).size.height > 800 ? 40: 20),

//              Center(
//                child: Container(
//                  margin: EdgeInsets.only(left: scale_width(37.75, context), top: 0.0),
//                    child: Text('#TheDataPlug', style: TextStyle(fontWeight: FontWeight.w700, fontSize: scale_width(3.8, context), color: Colors.white,),)
//                ),
//              ),
