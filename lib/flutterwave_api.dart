
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:pheel_com/pheelcom_api.dart';

transRef(phoneNumber, dataValue, amount){
  var first = Random().nextInt(10000);
  var transRefNum = first.toString() + '#' + amount.toString() + '#' + dataValue.toString() + '#' + phoneNumber.toString();
  print(transRefNum);
  return transRefNum;
}

makePayment(context, amount, transRef, dataValue, network, phoneNumber, plan) async{

  final flutterWave = Flutterwave.forUIPayment(
    context: context,
    publicKey: 'FLWPUBK-8db85650462cc9aa68fc5c4d6c520468-X',
    encryptionKey: '14a88cd56f57b32953567858',
    currency: 'NGN',
    amount: amount.toString(),
    email: 'okhaephilip2@gmail.com',
    fullName: 'philip',
    txRef: transRef.toString(),
    isDebugMode: false,
    phoneNumber: '08060421709',
    acceptCardPayment: true,
    acceptUSSDPayment: true,
    acceptAccountPayment: true,
  );

  try{
    // call to initialize the payment user interface
    final ChargeResponse response = await flutterWave.initializeForUiPayments();

//     verify if the transaction is successful
    if (response != null) {

      // loading Dialog to keep the screen busy while trying to verify payment was successful to enable purchase of data
      showLoading(context, 'verifying payment...');

      print('$response');
      print('we are good');

      // validate payment is successful
      bool isSuccessful = validatePayment(response, amount, transRef);

      if (isSuccessful) {

        // call to make purchase of data
        var status = await processOrder(network, plan, phoneNumber);

        if(status == 'Payment Successful!'){

          // call to dismiss loading after data purchase has been made
          closeShowLoading(context);

          // once done with the placing the order route to success page to show transaction details of payment and data purchase
          Navigator.pushNamed(context, '/success', arguments: {
            'status_of_transaction': status,
            'network': network,
            'data_value': dataValue,
            'price': amount,
            'phone_number': phoneNumber,
          });

        }
        else{

          // call to dismiss loading after failure to make data purchase due to
          // insufficient balance has been detected
          closeShowLoading(context);

          // once done with the placing the order route to success page to show transaction details of payment and data purchase
          Navigator.pushNamed(context, '/failed', arguments: {
            'status_of_transaction': status,
            'network': network,
            'data_value': dataValue,
            'price': amount,
            'phone_number': phoneNumber,
          });

        }

      }
      else{

        // call to dismiss loading after failed payment has been detected
        closeShowLoading(context);

        // once done with the placing the order route to success page to show transaction details of payment and data purchase
        Navigator.pushNamed(context, '/failed', arguments: {
          'status_of_transaction': 'Payment Failed',
          'network': network,
          'data_value': dataValue,
          'price': amount,
          'phone_number': phoneNumber,
          'plan': plan,
          'trans_ref': transRef,
        });

//         check message
        print(response.message);

//         check status
        print(response.status);

//         check processor error
        print(response.data.processorResponse);
      }
    }
    else{
      print('no response');
    }
  }

  catch(error){
    print(error);
  }
}

// Test Keys
//'FLWPUBK_TEST-2e482f2ecfdf5635abb9adec00d753bc-X'
//'FLWSECK_TEST67fd39b84664'

// Live Keys
// 'FLWPUBK-77d311cbe875cfbaf4b36e1dbd6ce625-X'
// '621c8b052098079763f83e72'

bool validatePayment(ChargeResponse response, amount, transRef,){
  return response.data.processorResponse.toString() == 'Transaction Successful' && response.data.amount.toString() == amount && response.data.txRef.toString() == transRef;
}

showLoading(context, String message){
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(Colors.black),),
            SizedBox(width: 30.0,),
            Text(message),
          ],
        ),
      );
    }
  );
}

closeShowLoading(BuildContext loadingContext){
  if (loadingContext != null){
    Navigator.of(loadingContext).pop();
  }
}