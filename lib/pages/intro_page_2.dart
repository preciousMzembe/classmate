import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: PageView.builder(
        itemCount: 1,
        itemBuilder: (_,i){
          return Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                SizedBox(height:40),
                Image.asset('assets/images/calendar.png', height: 150, width: 150,
                ),
                SizedBox(height:40),
                Text("Calendar", style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
                ),
                SizedBox(height:20),
                Text('It automatically update \n your schedule to the calendar!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

