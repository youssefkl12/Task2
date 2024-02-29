import 'package:flutter/material.dart';
import 'package:lg_connection/components/connection_flag.dart';
import 'package:flutter/material.dart';
import 'package:lg_connection/components/connection_flag.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lg_connection/connections/ssh.dart';
import 'package:dartssh2/dartssh2.dart';

import '../components/reusable_card.dart';

bool connectionStatus = false;

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  @override
  void initState() {
    super.initState();
    // ssh = SSH();
    // _connectToLG();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              'https://raw.githubusercontent.com/youssefkl12/images/main/logo%20light.png',
              // Set width and height as per your requirements
              width: 500,
              height: 300,
              // Adjust fit property as needed
              fit: BoxFit.contain,
            ),
            //
            TextButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                ),
              ),
              onPressed: () async {
                await Navigator.pushNamed(context, '/home');
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Start',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
