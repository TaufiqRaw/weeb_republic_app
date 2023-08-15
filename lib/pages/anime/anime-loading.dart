import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weeb_republic_app/widgets/loading.dart';

class AnimeLoading extends StatefulWidget {
  final BuildContext context;
  const AnimeLoading({super.key, required this.context});

  @override
  State<AnimeLoading> createState() => _AnimeLoadingState();
}

class _AnimeLoadingState extends State<AnimeLoading> {

  bool isError = false;
  int id = 0;
  final dio = Dio();

  Future<void> getData(int id) async{
    try{
      setState(() {
        isError = false;
      });
      Response res = await dio.get(Uri.http(dotenv.env['BACKEND_URL']!, 'anime/$id').toString());
      Navigator.pushReplacementNamed(context, "/anime", arguments: {
        'data' : res.data,
      });
    }on Exception catch(err){
      setState(() {
        isError = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dynamic data = ModalRoute.of(widget.context)!.settings.arguments;
    setState(() {
      id = data['id'];
    });
    getData(data['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child : Loading(
            onClickReload: () {getData(id);},
            isError: isError,
          )
      ),
    );
  }
}
