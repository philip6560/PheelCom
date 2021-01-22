import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pheel_com/pheelcom_api.dart';
import 'package:pheel_com/flutterwave_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pheel_com/UI responsiveness.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {

  Map plan = {};
  List<Map> selected_plan = [];
  Plan instance = Plan();
  var status;
  var priceList;
  var amount;
  var dataValue;
  var transRefNum;
  var selectedNetwork;
  var selectedPlan;
  var phoneNumber;
  int maxLength = 11;
  FocusNode _focusNode;
  final myController = TextEditingController();
  Color spinkitColor = Colors.transparent;
  String purchaseStatus = 'Successful!';
  Color successColor = Colors.transparent;


  List<Network> networks = [ Network(network_image: 'assets/mtn.png', network_name: 'MTN', network_id: '1'), Network(network_image: 'assets/glo.png', network_name: 'GLO', network_id: '2'),
  Network(network_image: 'assets/airtel.png', network_name: 'AIRTEL', network_id: '3'), Network(network_image: 'assets/9mobile.png', network_name: '9MOBILE', network_id: '4')];

  List<Plan> plans = [Plan(plan_id: '1'), Plan(plan_id: '2'), Plan(plan_id: '3'), Plan(plan_id: '4')];


  void currentPlan(value){
    for (Map prices in priceList){
      if (prices.keys.toString() == value.toString()){
        // extract the list with the prices and dataValues from the main list
        var first_cleaning = prices.values.toList();
        // the list with amount and dataValue are passed for processing
        var second_cleaning = first_cleaning[0];
        setState(() {
          selectedPlan = value;
          amount = second_cleaning[0].toString();
          dataValue = second_cleaning[1].toString();
        });
      }
      else{
        continue;
      }
    }
    print(selectedPlan);
    print(amount);
    print(dataValue);
    }

  void requestFocus(){
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  savePhoneNumber() {
    setState(() {
      phoneNumber = myController.text;
      transRefNum = transRef(phoneNumber, dataValue, amount);
    });
    print(phoneNumber);
    print(transRefNum);
  }

  void startTransaction()async{
    await makePayment(context, amount, transRefNum, dataValue, selectedNetwork, phoneNumber, selectedPlan);
  }


  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    myController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    plan = plan.isNotEmpty? plan: ModalRoute.of(context).settings.arguments;

    void currentNetwork(value) {
      Plan instance = plans[int.parse(value)-1];

      // case statement to select plans based on the selected network
      switch(value){

        // Mtn plan
        case '1':
        List<Map> plans_value = [];
        for (Map mtn in plan['mtn_plan']){
        plans_value.add({
        'value': mtn.values,
        });
        }
        instance.plan = [
          {'1GB   at   #370': plans_value[0].values},
          {'2GB   at   #700': plans_value[1].values},
          {'3GB   at   #1,000': plans_value[2].values},
          {'5GB   at   #1,800': plans_value[3].values},
        ];
        instance.priceList = [
          {plans_value[0].values: ['370', '1GB']},
          {plans_value[1].values: ['700', '2GB']},
          {plans_value[2].values: ['1000', '3GB']},
          {plans_value[3].values: ['1800', '5GB']},
        ];
        break;

        // Glo plan
        case '2':
        List<Map> plans_value = [];
        for (Map glo in plan['glo_plan']){
        plans_value.add({
        'value': glo.values,
        });
        }
        instance.plan = [
          {'1.35GB    at   #500 (2 weeks plan)': plans_value[0].values},
          {'2.5GB     at   #950': plans_value[1].values},
          {'5.8GB     at   #1,900': plans_value[2].values},
          {'7.7GB     at   #2,400': plans_value[3].values},
          {'10GB      at   #2,850': plans_value[4].values},
          {'13.25GB   at   #3,800': plans_value[5].values},
          {'18.25GB   at   #4,800': plans_value[6].values},
          {'29.5GB    at   #7,500': plans_value[7].values},
          {'50GB      at   #9,500': plans_value[8].values},
        ];
        instance.priceList = [
          {plans_value[0].values: ['500','1.35GB']},
          {plans_value[1].values: ['950', '2.5GB']},
          {plans_value[2].values: ['1900', '5.8GB']},
          {plans_value[3].values: ['2400', '7.7GB']},
          {plans_value[4].values: ['2850', '10GB']},
          {plans_value[5].values: ['3800', '13.25GB']},
          {plans_value[6].values: ['4800', '18.25GB']},
          {plans_value[7].values: ['7500', '29.5GB']},
          {plans_value[8].values: ['9500', '50GB']},
        ];
        break;

        // Airtel plan
        case '3':
        List<Map> plans_value = [];
        for (Map airtel in plan['airtel_plan']){
        plans_value.add({
        'value': airtel.values,
        });
        }
        instance.plan = [
          {'1.5GB   at   #970': plans_value[0].values},
          {'2GB     at   #1,200': plans_value[1].values},
          {'3GB     at   #1,450': plans_value[2].values},
          {'4.5GB   at   #1,950': plans_value[3].values},
          {'6GB     at   #2,430': plans_value[4].values},
          {'8GB     at   #2,850': plans_value[5].values},
          {'11GB    at   #3,850': plans_value[6].values},
        ];
        instance.priceList = [
          {plans_value[0].values: ['950', '1.5GB']},
          {plans_value[1].values: ['1200', '2GB']},
          {plans_value[2].values: ['1450', '3GB']},
          {plans_value[3].values: ['1950', '4.5GB']},
          {plans_value[4].values: ['2430', '6GB']},
          {plans_value[5].values: ['2850', '8GB']},
          {plans_value[6].values: ['3850', '11GB']}
        ];
        break;

        case '4':
        List<Map> plans_value = [];
        for (Map etisalat in plan['9mobile_plan']){
        plans_value.add({
        'value': etisalat.values,
        });
        }
        instance.plan = [
          {'1GB     at   #950': plans_value[0].values},
          {'2GB     at   #1,100': plans_value[1].values},
          {'4.5GB   at   #1,900': plans_value[2].values},
          {'11GB    at   #3,750': plans_value[3].values},
          {'15GB    at   #4,700': plans_value[4].values},
          {'40GB    at   #9,300': plans_value[5].values},
        ];
        instance.priceList = [
          {plans_value[0].values: ['950', '1GB']},
          {plans_value[1].values: ['1100', '2GB']},
          {plans_value[2].values: ['1900', '4.5GB']},
          {plans_value[3].values: ['3750', '11GB']},
          {plans_value[4].values: ['4700', '15GB']},
          {plans_value[5].values: ['9300', '40GB']}
        ];
        break;
      }

      setState((){
        selectedNetwork = value;
        selectedPlan = null;
        selected_plan = instance.plan;
        priceList = instance.priceList;
      });
      print(selectedNetwork);
    }


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Column(
          children: [
            Container(
//              color: Colors.white,
              margin: EdgeInsets.only(left: 15.0,),
              width: 200.0,
              height: 35.0,
                child: Image.asset('assets/logo.png',)
            ),
            Container(
              margin: EdgeInsets.only(left: 98.0),
              child: Text('#TheDataPlug', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0, color: Colors.white,)),
            ),
          ],
        ),
        actions: [
          Row(
           children: [
             Container(
               margin: EdgeInsets.only(top: 10.0),
               child: FlatButton(
                 onPressed: ()async{
                     String url = 'https://api.whatsapp.com/send?phone=2348060421709&text=Hello%2C%20Good%20day%20and%20how%20may%20we%20be%20of%20service%20to%20you%3F';
                     if(await canLaunch(url)){
                       await launch(url);
                     }
                     else{
                       throw 'Could not contact help center';
                     }
                 },
                 child: Column(
                   children: [
                     Icon(Icons.live_help_outlined, color: Colors.white,),
                     SizedBox(height: 2.5),
                     Text('support centre', style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500),),
                   ],
                 ),
               ),
             ),
           ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: scale_height(4.0, context)),
            width: scale_width(94.4, context),
            child: Card(
              elevation: 1.5,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 40.0,
                    color: Colors.black,
                    child: Text('Place Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: scale_width(4.75, context), letterSpacing: 1.0),),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(scale_width(2.0, context), 0.0, scale_width(2.0, context), 0.0),
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top: scale_height(9.45, context), bottom: scale_height(0.6, context)),
                            child: Text('Network', style: TextStyle(fontSize: scale_width(4.3, context), fontWeight: FontWeight.w700),)
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          margin: EdgeInsets.only(bottom: scale_height(3.55,context)),
                          alignment: Alignment.center,
                          child: DropdownButton(
                            underline: Container(),
                            hint: Padding(
                              padding: const EdgeInsets.only(left: 14.0),
                              child: Text('Please select...'),
                            ),
                            isExpanded: true,
                            value: selectedNetwork,
                            onChanged: currentNetwork,
                            items: networks.map((network) => DropdownMenuItem(
                              value: network.network_id,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 1.0),
                                      child: Image.asset(network.network_image, width: 22.0, height: 22.0,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(network.network_name),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            ).toList(),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: scale_width(0.4, context), bottom: scale_height(0.6, context)),
                            alignment: Alignment.topLeft,
                            child: Text('Plan', style: TextStyle(fontSize: scale_width(4.3, context), fontWeight: FontWeight.w700),)
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: scale_height(3.35,context)),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: DropdownButton(
                            hint: Padding(
                              padding: const EdgeInsets.only(left:14.0),
                              child: Text('Select network first...'),
                            ),
                            underline: Container(),
                            isExpanded: true,
                            value: selectedPlan,
                            onChanged: currentPlan,
                            items: List.generate(selected_plan.length, (index)  => DropdownMenuItem(
                              value: selected_plan[index].values.toString(),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 14),
                                child: Text(selected_plan[index].keys.toString()),
                              ),
                            )),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: scale_width(0.4, context), bottom: scale_height(0.6, context)),
                            alignment: Alignment.topLeft,
                            child: Text('Mobile Number', style: TextStyle(fontSize: scale_width(4.3, context), fontWeight: FontWeight.w700),)
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: scale_height(3.9,context)),
                          alignment: Alignment.center,
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            controller: myController,
                            cursorColor: _focusNode.hasFocus? Colors.black: Colors.transparent,
                            focusNode: _focusNode,
                            onFieldSubmitted: savePhoneNumber(),
                            onTap: requestFocus,
                            maxLength: maxLength,
                            maxLengthEnforced: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 17.0),
                              hintText: 'Enter mobile number',
                              prefixIcon: Icon(Icons.phone_android_sharp, color: _focusNode.hasFocus? Colors.black: null,),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: _focusNode.hasFocus? Colors.black: Colors.transparent)),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: scale_height(5.5, context)),
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: scale_height(1.8, context)),
                            color: Colors.black,
                            splashColor: Colors.white,
                            onPressed: myController.text.isNotEmpty && myController.text.length == maxLength? startTransaction : (){},
                            child: Container(
                                alignment: Alignment.center,
                                child: Text('Proceed', style: TextStyle(color: Colors.white, fontSize: scale_width(3.8, context) ))
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}
//onPressed: myController.text.isNotEmpty && myController.text.length == maxLength? purchase: (){},
//Column(
//children: [
//Icon(Icons.check, color: successColor, size: 20.0,),
//Text(purchaseStatus, style: TextStyle(color: successColor, fontSize: 15.0, ),),
//],
////)

//Container(
//margin: EdgeInsets.only(top: 20.0),
//child: FlatButton(
//padding: EdgeInsets.all(0.0),
//height: 0.0,
//shape: Border(bottom: BorderSide(color: Colors.black)),
//onPressed: (){},
//child: Text('Any Issue? Contact Support Centre', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300),),
//),
//),