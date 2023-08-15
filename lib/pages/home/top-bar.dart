import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  final void Function() onTap;
  final void Function(String) onSubmit;
  final TextEditingController? controller;
  const TopBar({super.key, required this.onTap, required this.onSubmit, this.controller});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          color: Colors.purple,
          margin: EdgeInsets.only(bottom: 30),
          padding: EdgeInsets.only(bottom: 20),
          child: const Center(
            child: Text(
              "Weeb's Republic",
              style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Buran',
                  color: Colors.white
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: 60,
              child: TextField(
                onTap: widget.onTap,
                controller: widget.controller,
                onSubmitted: widget.onSubmit,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search Anime Title...",
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.purple,
                        width: 3,
                      ),borderRadius: BorderRadius.circular(10.0)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.purple,
                        width: 3,
                      ),borderRadius: BorderRadius.circular(10.0)
                  ),filled: true, fillColor: Colors.grey[50],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
