import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:weeb_republic_app/services/auth.service.dart';

class Register extends StatefulWidget {
  final void Function({required String email, required String password, required String username}) onSubmit;
  final void Function() onLoginButton;
  const Register({super.key, required this.onSubmit, required this.onLoginButton});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var usernameController = TextEditingController();
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
                controller: usernameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(MdiIcons.email),
                  hintText: "John Doe",
                )
            ),
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
                  widget.onSubmit(email: emailController.text, password: passwordController.text, username: usernameController.text);
                },
                child: Text("Register"),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.purple)
                )
            ),
            SizedBox.fromSize(size: Size(10, 10)),
            Center(
              child: GestureDetector(
                onTap: widget.onLoginButton,
                child: Text("Create New Account"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
