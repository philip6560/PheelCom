import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
//Contains HTML parsers to generate a document object
import 'package:html/dom.dart';
//Contains DOM related classes for extracting data from elements

class Network{
  String network_id;
  String network_name;
  String network_image;

  Network({this.network_image, this.network_name, this.network_id});

}

// function to login into Queenspalm's webapp
Future login() async{

  // login details to QueensPalm
  var loginDetails = <String, String>{
    'username':'Philip6560',
    'Password': 'philip6560',
    'login': '',
  };

  int total_time_to_retry_in_minutes = 3;
  int requestInterval = 8;
  String url = 'https://queenspalm.com/login.php';
  String requestType = 'post';
  http.Response response;
  Map data;

  try{

    response = await retryRequests(total_time_to_retry_in_minutes, requestInterval, url, requestType, null, loginDetails);
    data = response.headers;
    return data;
  }
  catch(error){
    String status = 'Could not Login:$error';
    print(status);
  }

}

class Plan{

  List mtn_plan = [], glo_plan = [], airtel_plan = [], etisalat_plan= [], templist = [];
  String plan_id;
  List<Map> plan;
  List<Map> all_plans = [];
  List<Map> priceList;
  List<Map<dynamic, List>> valueList;

  Plan({this.plan_id});

  Future getPlans() async{

    int total_time_to_retry_in_minutes = 3;
    int requestInterval = 8;
    String url = 'https://queenspalm.com/home/data-request.php';
    String requestType = 'post';
    http.Response response;

      // block to get plans for a particular network using their id{1: MTN, 2: Glo, 3: Airtel, 4: 9mobile} from QueensPalm
      for (int network_id = 1, count = 4; network_id <= count; network_id++) {
//        initialize response to make request
        response = null;

        try{

            Map body_data = {
              'id': network_id.toString(),
            };

            // retryRequests function to ensure each request are made again if connection timed out
            response = await retryRequests(total_time_to_retry_in_minutes, requestInterval, url, requestType, null, body_data);
            var document = parse(response.body);
            List <Element> plans = document.querySelectorAll('option');

            // list of type map to get the values after querying the parsed html document
            List<Map<String, dynamic>> plans_value = [];

            // loop to get individual plans from plans(the parsed body from the response after selecting option)
            for (var plan in plans) {
              plans_value.add({
                'value': plan.attributes['value'],
              });
            }


            switch (network_id.toString()) {
            // Mtn plan
              case '1':
                if(response != null){
                  all_plans.add({'1': plans_value});
                }
                print('got MTN plan');
                break;

            // Glo plan
              case '2':
                if(response != null){
                  all_plans.add({'2': plans_value});
                }
                print('got GLO plan');
                break;

            // Airtel plan
              case '3':
                if(response != null){
                  all_plans.add({'3': plans_value});
                }
                print('got AIRTEL plan');
                break;

            // 9Mobile plan
              case '4':
                if(response != null){
                  all_plans.add({'4': plans_value});
                }
                print('got 9mobile plan');
                break;
            }
        }
        catch (error) {
          String status = 'could not fetch plans: $error';
          network_id--;// logic controlling the recalling of request
          print(status);
        }
      }

    if(all_plans.length == 4){
      // Section get preloaded plans

      // MTN plans
      templist = all_plans[0].values.map((e) => e).toList();
      mtn_plan = templist[0].map((plan) => plan).toList();

      // GLO plans
      templist = all_plans[1].values.map((e) => e).toList();
      glo_plan = templist[0].map((plan) => plan).toList();

      // AIRTEL plans
      templist = all_plans[2].values.map((e) => e).toList();
      airtel_plan = templist[0].map((plan) => plan).toList();

      // 9MOBILE plans
      templist = all_plans[3].values.map((e) => e).toList();
      etisalat_plan = templist[0].map((plan) => plan).toList();
    }
  }


}

// function to make purchase of data
Future processOrder(network, plan, phoneNumber)async{
  // login to purchase data and get header details
  Map data = await login();

  // header details containing the cookie to maintain a persistent connection
  Map<String, String> header_details = {
    'cookie': data['set-cookie'],
  };
  print('$plan');
  // conversion of the plan into parsable string
  plan = plan.toString().substring(3, (plan.toString().length)-3);

  var purchaseDetails = <String, String>{
    'select': network,
    'plan': plan,
    'number': phoneNumber,
    'bypass': 'bypass',
    'data':'',
  };

  int total_time_to_retry_in_minutes = 3;
  int requestInterval = 8;
  String url = 'https://queenspalm.com/home/data.php';
  String requestType = 'post';
  http.Response response;


  try{
    response = await retryRequests(total_time_to_retry_in_minutes, requestInterval, url, requestType, header_details, purchaseDetails);
    if (response.statusCode.toString() == '302'){
      print(response.statusCode);
      String message = 'Payment Successful!';
      return message;
    }
    else{
      print(response.body.substring(9000, 10000));
      var document = parse(response.body);
      List<Element> status = document.getElementsByClassName('alert alert-danger alert-dismissible');
      String message = status.map((value) => value.text).toString();
      print(message);
      return 'Error: Contact Administrator';
    }
  }

  catch(error){
    String status = 'could not place purchase: $error';
    print(status);
  }

}

retryRequests(time_in_minutes, requestInterval, url, urlRequestType, headerDetails, bodyDetails) async{

  var time_in_seconds = time_in_minutes * 60;
  var retry = time_in_seconds / requestInterval;
  String timeout_error = 'Connection Timed Out';
  var response;


  for (var initialCount = 0; initialCount <= retry; initialCount++){
    retry = retry + 2;
    if (urlRequestType == 'post'){
      try{
        if (headerDetails != null && bodyDetails != null){
          response = await http.post(url, headers: headerDetails, body: bodyDetails).timeout(Duration(seconds: requestInterval), onTimeout: (){ throw TimeoutException(timeout_error); });
          return response;
        }
        else{
          response = await http.post(url, body: bodyDetails).timeout(Duration(seconds: requestInterval), onTimeout: () { throw TimeoutException(timeout_error); });
          return response;
        }
      }
      catch(error){
        String status = 'Error: $error';
        print(status);
      }
      if (urlRequestType == 'get'){
        try{
          if (headerDetails != null){
            response = await http.get(url, headers: headerDetails).timeout(Duration(seconds: requestInterval), onTimeout: (){ throw TimeoutException(timeout_error); });
            return response;
          }
          else{
            response = await http.get(url).timeout(Duration(seconds: requestInterval), onTimeout: (){ throw TimeoutException(timeout_error); });
            return response;
          }
        }
        catch(error){
          String status = 'Error: $error';
          print(status);
        }
      }
    }
  }
}


//// function that takes us to the Queenspalm login page
//makeCall() async{
//  var response = await http.get('https://queenspalm.com/login.php',);
//  print(response.headers);
//  Map data = response.headers;
//  return data;
//  print(response.statusCode);
//}


//  Map data = await makeCall();
//
//  Map<String, String> headerDetails = {
//    'set-cookie': data['set-cookie'],
//  };


///////////////////// this section is not needed because once you have logged in you can make a call to 'https://queenspalm.com/home/data-request.php'
////////////////////  directly, therefore there is no need to go through 'https://queenspalm.com/home/data.php'
//    try{
//      // header details to gain access to QueensPalm data page
//      var response = await http.get('https://queenspalm.com/home/data.php', headers: header_data);
//      print(response.statusCode);
////      print(response.body.substring(10000, 11000));
//    }
//    catch(error){
//      var status = 'could not access data.php';
//      print(status);
//    }