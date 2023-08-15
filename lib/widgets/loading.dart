import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  final bool isError;
  final void Function() onClickReload;
  const Loading({super.key, required this.isError, required this.onClickReload});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/splash.png", width: 200),
            SizedBox.fromSize(size: Size(20.0,20.0)),
            !widget.isError
              ? SpinKitThreeBounce(color: Color(0xFFCA22D9))
              : Column(
                children: [
                  Text("Something Went Wrong"),
                  ElevatedButton(onPressed: widget.onClickReload,
                      child:Text("Reload")),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
