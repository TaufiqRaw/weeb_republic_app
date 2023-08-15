import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_card/image_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:weeb_republic_app/pages/home/top-bar.dart';
import 'package:weeb_republic_app/widgets/home-section.dart';

class Home extends StatefulWidget {
  final void Function() onSearchBarTap;
  const Home({super.key, required this.onSearchBarTap});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String status = "loading";
  dynamic featured;
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async{
    setState(() {
      status = "loading";
    });
    try {
      Response res = await dio.get(Uri.http(dotenv.env['BACKEND_URL']!, 'anime/featured').toString());
      setState(() {
        featured = res.data;
        status = "success";
      });
    } catch (err){
      Fluttertoast.showToast(msg: err.toString());
      setState(() {
        status = "error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TopBar(
              onTap: widget.onSearchBarTap,
              onSubmit: (String s){},
            ),
            ...(status == "error" ?[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Text("Something Went Wrong"),
                  ElevatedButton(onPressed: getData, child: Text("Reload"))
                ],
              ),
            )] : []),
            ...(status == "loading"? [const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: SpinKitCubeGrid(color: Colors.purple,),
              )),
            )] : []),
            ...(status == "success"? [
              HomeSection(data: featured['popularCurrentAir'], icon: MdiIcons.televisionClassic, title: "Popular Airing"),
              HomeSection(data: featured['season'], icon: MdiIcons.clockCheck, title: "Popular this season"),
              HomeSection(data: featured['top'], icon: MdiIcons.numeric1BoxMultiple, title: "Top Anime"),
              SizedBox.fromSize(size: Size(10, 100),)
            ] : [])
          ],
        ),
      ),
    );
  }
}
