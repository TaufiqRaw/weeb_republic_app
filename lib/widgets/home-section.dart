import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeSection extends StatefulWidget {
  final List<dynamic> data;
  final String title;
  final IconData icon;
  const HomeSection({super.key, required this.data, required this.icon, required this.title});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(
          color: Color(0xFF000000).withOpacity(0.25),
          offset: Offset(0, 5),
          blurRadius: 4,
          spreadRadius: 1,
        )],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Icon(widget.icon),
                SizedBox.fromSize(size : Size(10,10)),
                Text(
                    widget.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                )
              ],
            ),
          ),
          Container(
            height: 250.0,
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(bottom: 20),
            child: ListView.builder(
              itemCount: widget.data.length,
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: ()=>{
                    Navigator.pushNamed(context, "/anime-loading", arguments: {
                      'id' : widget.data[index]['id']
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
                      tags: widget.data[index]['tags'].length > 0 ?
                      [
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5)
                              )
                          ),
                          child: Text(
                            "${widget.data[index]['tags'][0]['name']}",
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                        ...(widget.data[index]['tags'].length > 1 ? [
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5)
                                )
                            ),
                            child: Text(
                              "+ ${widget.data[index]['tags'].length-1}",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ] : [])
                      ] : [],
                      tagSpacing: 3,
                      tagRunSpacing: 2,
                      imageProvider: NetworkImage("${widget.data[index]['picture']}"),
                      title: Text("${widget.data[index]['title']}", maxLines: 1),
                      description: Text("${widget.data[index]['season']['year']} | ${widget.data[index]['season']['season']}"),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
