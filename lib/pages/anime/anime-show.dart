import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_card/image_card.dart';
import 'package:marqueer/marqueer.dart';
import 'package:weeb_republic_app/services/auth.service.dart';

class AnimeShow extends StatefulWidget {
  final BuildContext context;
  const AnimeShow({super.key, required this.context});

  @override
  State<AnimeShow> createState() => _AnimeShowState();
}

class _AnimeShowState extends State<AnimeShow> {
  final authService = AuthService.instance;
  final dio = Dio();
  var watchlisted = false;

  late dynamic data;

  var isPostingWatchlist = false;
  
  void addToWatchlist() async {
    if(isPostingWatchlist)
      return;
    isPostingWatchlist = true;
    try{
      Response res = await dio.post(
          Uri.http(dotenv.env['BACKEND_URL']!, 'watchlist/').toString(),
          data: jsonEncode({
            'animeId' : data['id'],
            'isLiked' : true,
          }),
          options: Options(
              contentType: Headers.jsonContentType,
              headers: {
                "authorization" : "Bearer ${authService.user!.accessToken}"
              }
          )
      );
      setState(() {
        watchlisted = true;
      });
      isPostingWatchlist = false;
    } catch (err){
      await authService.refresh();
      if(authService.user == null){
        Fluttertoast.showToast(msg: "Unauthorized, Please login");
      }
      setState(() {});
      isPostingWatchlist = false;
    }
  }

  void getWatchlisted() async {
    try{
      Response res = await dio.post(
          Uri.http(dotenv.env['BACKEND_URL']!, 'watchlist/check').toString(),
          data: jsonEncode({
            'animeId' : data['id'],
          }),
          options: Options(
              contentType: Headers.jsonContentType,
              headers: {
                "authorization" : "Bearer ${authService.user!.accessToken}"
              }
          )
      );
      setState(() {
        watchlisted = (res.data == 'true');
      });
    } catch (err){
      await authService.refresh();
      setState(() {});
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = (ModalRoute.of(widget.context)!.settings.arguments! as dynamic)['data'];
    if(authService.user != null) {
      getWatchlisted();
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: SizedBox(
          height: 20,
          child: Marqueer(
            child: Padding(
              padding: const EdgeInsets.only(right: 50),
              child: Text(
                data['title'],
                style: TextStyle(fontFamily: 'buran', color: Colors.white),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.purple,
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                height: 300,
                child: Stack(
                  children: [
                    Image.network(data['picture'], height: 300,fit: BoxFit.cover, width: MediaQuery.of(context).size.width,),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius:
                                BorderRadius.only(topRight: Radius.circular(20))),
                      ),
                    )
                  ],
                )),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "Details",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Aired : ${data['season']['season'] != "undefined" ? data['season']['season'] : "" } "
                            "${data['season']['year'] ?? data['season']['year'] }"
                            "\nEpisodes : ${data['episodes']} \nType : ${data['type']} "
                      ),
                    ),
                  )
                ])
            ),
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
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Tags",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Wrap(
                              children: (data['tags'] as List<dynamic>).map((tag)=>
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 3, 3),
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)
                                      )
                                  ),
                                  child: Text(
                                    "${tag['name']}",
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ).toList(),
                          ),
                        ),
                      )
                    ])
            ),
            ...(authService.user != null ? [Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: !watchlisted ? ElevatedButton(
                onPressed: ()=>addToWatchlist(),
                child: Text("Add To Watchlist"),
              ) : Center(child : Text("Already in watchlist")),
            )]: []),
            ...(data['related'].length > 0 ? [Container(
              margin: EdgeInsets.fromLTRB(0,20,0,20),
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
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "Related Anime",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Container(
                    height: 250.0,
                    padding: EdgeInsets.only(bottom: 20),
                    child: ListView.builder(
                      itemCount: data['related'].length,
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: ()=>{
                            Navigator.pushNamed(context, "/anime-loading", arguments: {
                              'id' : data['related'][index]['id']
                            })
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF000000).withOpacity(0.10),
                                    offset: Offset(0, 3),
                                    blurRadius: 8,
                                    spreadRadius: -1,
                                  ),
                                ]
                            ),
                            child: FillImageCard(
                              width: 200,
                              heightImage: 140,
                              tags: data['related'][index]['tags'].length > 0 ?
                              [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)
                                      )
                                  ),
                                  child: Text(
                                    "${data['related'][index]['tags'][0]['name']}",
                                    style: const TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                ...(data['related'][index]['tags'].length > 1 ? [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                        color: Colors.purple,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)
                                        )
                                    ),
                                    child: Text(
                                      "+ ${data['related'][index]['tags'].length-1}",
                                      style: const TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                ] : [])
                              ] : [],
                              tagSpacing: 3,
                              tagRunSpacing: 2,
                              imageProvider: NetworkImage("${data['related'][index]['picture']}"),
                              title: Text("${data['related'][index]['title']}", maxLines: 1),
                              description: Text("${data['related'][index]['season']['year']} | ${data['related'][index]['season']['season']}"),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )] : [])
          ],
        ),
      ),
    );
  }
}
