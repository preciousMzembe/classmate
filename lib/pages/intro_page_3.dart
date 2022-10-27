import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(127, 188, 250, 1),
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
                Image.asset('assets/images/timetable.png', height: 150, width: 150,
                ),
                SizedBox(height:40),
                Text("Timetable", style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
                ),
                SizedBox(height:20),
                Text('You can manage your timetable!',
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

