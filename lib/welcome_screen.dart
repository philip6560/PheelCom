import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.0, height: 50.0,
              margin: EdgeInsets.only(top: 200.0),
              child: Image.asset('assets/logo.png',),
            ),
            Container(
              margin: EdgeInsets.only(top: 430, right: 235.0),
              child: Text('WELCOME', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25.0, letterSpacing: 0.5),),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, right: 37.0),
              child: Text('We bring to you monthly data at pocket friendly prices to', style: TextStyle(),),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 130.0, vertical: 20.0),
                onPressed: (){},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                color: Colors.black,
                child: Text('GET STARTED', style: TextStyle(color: Colors.white),),
              ),
            ),
            Container(
              child: FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 149.0, vertical: 19.0),
                onPressed: (){},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0), side: BorderSide(color: Colors.black, width: 1.2)),
                child: Text('LOG IN'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
