import 'package:flutter/material.dart';
import 'package:medicine_reminder/pages/auth/login_screen.dart';
import 'package:medicine_reminder/pages/auth/signup_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Top Icon
              Icon(
                Icons.health_and_safety,
                size: 100,
                color: Colors.white,
              ),

              SizedBox(height: 20.0),

              Text(
                'Welcome to MedFlicks',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),

              SizedBox(height: 15.0),

              Text(
                'Timely meds, healthier you!',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: 50.0),

              // Login Button
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    elevation: 6,
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: 15.0),

              // Signup Button
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    elevation: 6,
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}