import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:weeb_republic_app/pages/anime/anime-loading.dart';
import 'package:weeb_republic_app/pages/anime/anime-search.dart';
import 'package:weeb_republic_app/pages/anime/anime-show.dart';
import 'package:weeb_republic_app/pages/home/home.dart';
import 'package:weeb_republic_app/pages/profile/profile.dart';
import 'package:weeb_republic_app/pages/splash.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  runApp(MaterialApp(
    routes: {
      "/" : (context)=>Splash(),
      "/home" : (context)=>App(),
      "/anime-loading" : (context)=>AnimeLoading(context: context),
      "/anime" : (context)=>AnimeShow(context : context),
      "/anime-search" : (context)=>AnimeSearch(),
    },
  ));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int pageIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var page = <Widget>[Home(onSearchBarTap: (){
      setState(() {
        pageIndex = 1;
      });
    }), AnimeSearch(), Profile()];
    return Scaffold(
      extendBody: true,
      body: page[pageIndex],
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: Container(
        color: Colors.white.withOpacity(0.6),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: GNav(
          gap: 20,
          backgroundColor: Colors.transparent,
          color: Colors.purple,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.purple,
          tabs: [
            GButton(
              icon: MdiIcons.home,
              text: "Home",
            ),
            GButton(
              icon: MdiIcons.databaseSearch,
              text : "Search"
            ),
            GButton(
              icon: MdiIcons.history,
              text : "watchlist"
            )
          ],
          onTabChange: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          selectedIndex: pageIndex,
        ),
      ),
    );
  }
}
