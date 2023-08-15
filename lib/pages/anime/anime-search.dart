import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weeb_republic_app/pages/home/top-bar.dart';

class AnimeSearch extends StatefulWidget {
  const AnimeSearch({super.key});

  @override
  State<AnimeSearch> createState() => _AnimeSearchState();
}

class _AnimeSearchState extends State<AnimeSearch> {

  final dio = Dio();

  String status = "finish" ;
  dynamic result = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> search() async {
    try{
      if(searchController.text.length <= 3) {
        throw Error();
      }
      setState(() {
        status="loading";
      });
      var res = await dio.get(Uri.http(dotenv.env['BACKEND_URL']!, 'anime').toString(), queryParameters: {
        'q' : searchController.text
      });
      setState(() {
        result = res.data[0];
        status = "success";
      });
    }catch(err){
      setState(() {
        status = "error";
      });
    }
  }


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          TopBar(
            controller: searchController,
            onTap: (){},
            onSubmit: (String s)=>search(),
          ),
            ...(status == "loading"? [const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: SpinKitCubeGrid(color: Colors.purple,),
              )),
            )] : []),
            ...(status == "error" ? [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: searchController.text.length <= 3 ? [
                    Text("Search must have > 3 characters")
                  ] : [
                    Text("Something Went Wrong"),
                    ElevatedButton(onPressed: search, child: Text("Reload"))
                  ],
                ),
              )
            ] : []),
            ...(status == "success" ? [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: ListView.builder(itemCount: result.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: ()=> Navigator.pushNamed(context, "/anime-loading", arguments: {
                          'id' : result[index]['id']
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
                                Image.network(result[index]['picture'], fit: BoxFit.cover, height: 200, width: 150,),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                            result[index]['title'],
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox.fromSize(size : Size(10,4)),
                                        Text("${result[index]['season']['year']} | ${result[index]['season']['season']}"),
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
                                                "${result[index]['tags'][0]['name']}",
                                                style: TextStyle(
                                                    color: Colors.white
                                                ),
                                              ),
                                            ),
                                            ...(result[index]['tags'].length > 1 ? [
                                              Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    color: Colors.purple,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(5)
                                                    )
                                                ),
                                                child: Text(
                                                  "+ ${result[index]['tags'].length-1}",
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
