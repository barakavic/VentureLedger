import 'package:flutter/material.dart';

class LoginPageUI extends StatefulWidget{

  const LoginPageUI({super.key});

  @override 
  State<LoginPageUI> createState() => _LoginPageState();

}
class _LoginPageState extends State<LoginPageUI>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override 
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Icon(Icons.how_to_reg,
              size: 120,
              color: Colors.deepOrange,
              ),
              
              const SizedBox(
                height: 20.0,
              ),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email/username',
                  hintText: 'Enter Email or Username',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              
              

              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'password',
                  hintText: 'Enter Your Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,

                  ),
                  onPressed: (){
                    setState((){
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  )

                ),
              ),

              const SizedBox(
                height: 30,
              ),

              ElevatedButton(onPressed: (){
                print('login button tapped');
                print('Email: ${_emailController.text}');
                print('Password: ${_passwordController.text}');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login Button Tapped')));
              },
              child: const Text('Login'),
              ),

              const SizedBox(height: 20.0),

              TextButton(onPressed: (){
                print('Forgot Password Pressed');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Forgot password tapped')),
                );
                
              }, child: const Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.deepOrange),
              )),
              const SizedBox(height: 5),

              TextButton(onPressed: (){
                  return null;
              },
               child: const Text(
                'Not a user? Signup',
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                ),
              ))

            ],
          ),

        ),
      ),
    );
  }
}