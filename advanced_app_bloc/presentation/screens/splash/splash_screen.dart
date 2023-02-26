import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/screens.dart'as screens;
import '../../styles/colors.dart';
import '../../widgets/default_text.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      animationBehavior: AnimationBehavior.preserve,
      value: 1,
      vsync: this,

    )..repeat(reverse: true,);
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));

    Timer(const Duration(milliseconds: 3000), () {
      Navigator.of(context).pushNamedAndRemoveUntil(screens.HOME_SCREEN, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(milliseconds:1500), (){
      _controller.stop(canceled: true);
    });

    return Scaffold(
      backgroundColor: lightBlue,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: Image(
                      height: 30.h,
                      width: 70.w,
                      image: const AssetImage(
                        "assets/todo.png",
                      ),
                  ),
                ),
              ),
              Flexible(
                child: DefaultText(
                  text: 'MY TO-DO LIST',
                  color: darkBlue,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
      ),
    );
  }
}
