import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pheel_com/UI%20responsiveness.dart';
import 'package:pheel_com/pheelcom_api.dart';
import 'package:pheel_com/flutterwave_api.dart';


class Successful extends StatefulWidget {
  @override
  _SuccessfulState createState() => _SuccessfulState();
}

class _SuccessfulState extends State<Successful> {

  Map data = Map();
  Network network_profile = Network();
  Plan instance = Plan();

  List mtn_plan = [], glo_plan = [], airtel_plan = [], etisalat_plan= [];

  loading() async{
    showLoading(context, 'Loading...');
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
  Widget build(BuildContext context) {

    // data passed when this screen is called
//    data = data.isNotEmpty? data: ModalRoute.of(context).settings.arguments;

      switch(data['network']){

        case '1':
          network_profile = Network(network_image: 'assets/mtn.png', network_name: 'MTN', network_id: '1');
          break;

        case '2':
          network_profile = Network(network_image: 'assets/glo.png', network_name: 'GLO', network_id: '2');
          break;

        case '3':
          network_profile = Network(network_image: 'assets/airtel.png', network_name: 'AIRTEL', network_id: '3');
          break;

        case '4':
          network_profile = Network(network_image: 'assets/9mobile.png', network_name: '9MOBILE', network_id: '4');
          break;
      }

    return Scaffold(
      backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.only(top: scale_height(28.0, context), right: scale_width(5.0, context), left: scale_width(5.0, context), bottom: scale_height(3.0, context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Icon(Icons.check, color: Colors.black, size: scale_width(21.0, context),),
                  Text('${data['status_of_transaction']}', style: TextStyle(fontSize: scale_width(7.1, context), fontWeight: FontWeight.w500),),
                  Container(
                    margin: EdgeInsets.only(top: 16.0, bottom: scale_height(6.5, context)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Image.asset(network_profile.network_image, width: 25.0, height: 25.0,),
                        SizedBox(width: 7.0,),
                      Text('${network_profile.network_name.toString()} Data of ${data['data_value']} has been sent to ${data['phone_number']}', style: TextStyle(fontSize: scale_width(3.55, context), fontWeight: FontWeight.w700),),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(vertical: 22.0),
                          color: Colors.black,
                          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(4.0)),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Text('Exit', style: TextStyle(color: Colors.white, fontSize: scale_width(3.0, context), fontWeight: FontWeight.w700),),
                        ),
                      ),
                      SizedBox(width: scale_width(8.0, context),),
                      Expanded(
                        flex: 1,
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(vertical: 22.0),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(4.0)),
                          onPressed: loading,
                          child: Text('Make Another Purchase',style: TextStyle(fontSize: scale_width(3.0, context), fontWeight: FontWeight.w700),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 125.0,
                    height: 34.0,
                    child: Stack(
                      children: [
                        Image.asset('assets/logo.png',),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text('#TheDataPlug', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10.0, color: Colors.black,)),
                        ),
                      ],
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
