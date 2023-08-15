import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:weeb_republic_app/services/auth.service.dart';

class Login extends StatefulWidget {
  final void Function({required String email, required String password}) onSubmit;
  final void Function() onRegisterButton;
  const Login({super.key, required this.onSubmit, required this.onRegisterButton});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(MdiIcons.email),
                  hintText: "johndoe@example.com",
                )
            ),
            TextField(
              controller: passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(MdiIcons.asterisk),
                  hintText: "Password",
                )
            ),
            SizedBox.fromSize(size: Size(10, 30)),
            ElevatedButton(
                onPressed: (){
                  widget.onSubmit(email: emailController.text, password: passwordController.text);
                },
                child: Text("Login"),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.purple)
                )
            ),
            SizedBox.fromSize(size: Size(10, 10)),
            Center(
              child: GestureDetector(
                onTap: widget.onRegisterButton,
                child: Text("Create New Account"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
