import 'package:flutter/material.dart';

class LoginOptionsPage extends StatelessWidget{
  const LoginOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.asset(
            'assets/icon/output_no_bg_white.png',
            height: 100,
          ),

          const SizedBox(
            height: 40,
          ),

          ElevatedButton.icon(onPressed: (){}, 
          label: Text("Continue with Email"),
          icon: Icon(Icons.email,),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50)
          ),
          
          ),

          ElevatedButton.icon(onPressed: (){}, 
          label: Text("Continue With Google"),

          icon: Image.asset(
            'asset/icon/google_icon.png',
            height: 24
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: Colors.grey)
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          ElevatedButton.icon(onPressed: (){}, 
          label: const Text("continue with SSO"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          )

        ],

      ),
      ),
    )
    );
  }
  
}