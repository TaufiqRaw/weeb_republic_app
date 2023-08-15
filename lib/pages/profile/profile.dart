import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:weeb_republic_app/pages/profile/login.dart';
import 'package:weeb_republic_app/pages/profile/register.dart';
import 'package:weeb_republic_app/services/auth.service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final dio = Dio();
  var isError = false;
  var isLoading = false;
  final authService = AuthService.instance;
  var watchlist = [];
  var isLogin = true;

  void getWatchlist() async {
    if(authService.user == null){
      return;
    }
    try{
      Response res = await dio.get(
          Uri.http(dotenv.env['BACKEND_URL']!, 'watchlist').toString(),
        options: Options(
          headers: {
            "authorization" : "Bearer ${authService.user!.accessToken}"
          }
        )
      );
      setState(() {
        watchlist = res.data[0];
      });
    } catch (err){
      await authService.refresh();
      setState(() {});
    }
  }

  void register({required String email, required String password, required String username})async{
    try{
      Response res = await dio.post(
          Uri.http(dotenv.env['BACKEND_URL']!, 'auth/register').toString(),
          data: jsonEncode({
            'name' : username,
            'email' : email,
            'password' : password
          }), options: Options(
          contentType: Headers.jsonContentType
      ));
      Fluttertoast.showToast(msg: "Successfully registered, you can login now",toastLength: Toast.LENGTH_LONG);
      setState(() {
        isLogin = true;
      });
    } catch (err){
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  void login({required String email,required String password}) async{
    try{
      Response res = await dio.post(
          Uri.http(dotenv.env['BACKEND_URL']!, 'auth/login').toString(),
          data: jsonEncode({
            'email' : email,
            'password' : password
          }), options: Options(
        contentType: Headers.jsonContentType
      ));
      setState(() {
        authService.login(refreshToken: res.data['rt'], accessToken: res.data['at']);
      });
      getWatchlist();
    } catch (err){
      Fluttertoast.showToast(msg: "invalid username/password");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(authService.user != null){
      getWatchlist();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(authService.user == null) {
      if(isLogin) {
        return SafeArea(
            bottom: false,
            child: Login(
              onSubmit: ({required String email, required String password}) {
                login(email: email, password: password);
              }, onRegisterButton: (){setState(() {
              isLogin = false;
            });}));
      }else{
        return SafeArea(
            bottom: false,
            child: Register(
                onSubmit: ({required String username ,required String email, required String password}) {
                  register(username: username,email: email, password: password);
                }, onLoginButton: (){setState(() {
              isLogin = true;
            });}));
      }
    }
    return SafeArea(
        bottom: false,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000).withOpacity(0.25),
                        offset: Offset(0, 5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "${authService.user!.username}/watchlist",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        (authService.user != null ? ElevatedButton(onPressed: (){setState(() {
                          this.authService.logout();
                        });}, child: Text('Logout')): Text('')),
                        (watchlist.length == 0 ?
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text("No watchlist added yet.\nGo search your favorite anime then add it to watchlist !"),
                        ) : Text(""))
                        //TODO: map watchlist here
                      ])
              ),
              ...(watchlist.length > 0 ? [
                Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: ListView.builder(itemCount: watchlist.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: ()=> Navigator.pushNamed(context, "/anime-loading", arguments: {
                              'id' : watchlist[index]['anime']['id']
                            }),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Row(
                                children: [
                                  Image.network(watchlist[index]['anime']['picture'], fit: BoxFit.cover, height: 200, width: 150,),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            watchlist[index]['anime']['title'],
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox.fromSize(size : Size(10,4)),
                                          Text("${watchlist[index]['anime']['season']['year']} | ${watchlist[index]['anime']['season']['season']}"),
                                          SizedBox.fromSize(size : Size(10,20)),
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(right: 4),
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    color: Colors.purple,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(5)
                                                    )
                                                ),
                                                child: Text(
                                                  "${watchlist[index]['anime']['tags'][0]['name']}",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                  ),
                                                ),
                                              ),
                                              ...(watchlist[index]['anime']['tags'].length > 1 ? [
                                                Container(
                                                  padding: EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                      color: Colors.purple,
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(5)
                                                      )
                                                  ),
                                                  child: Text(
                                                    "+ ${watchlist[index]['anime']['tags'].length-1}",
                                                    style: TextStyle(
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                              ] : [])
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                      ),
                    )
                ),
              ] : [])
            ]
        )
    );
  }
}
