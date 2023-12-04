import 'package:flutter/material.dart';
import 'package:mirror_wall_pr2/Screen1.dart';

class Splace_Screen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Splace_ScreenState();
  }

}
class Splace_ScreenState extends State<Splace_Screen>with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
  _controller=AnimationController(vsync: this,duration: Duration(seconds: 1));
  _animation=Tween<double>(begin: 0,end: 1).animate(_controller);
  _controller.forward();
    super.initState();
  _controller.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Screen1()),
      );
    }
  });
  }
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
                offset: Offset(100*_animation.value,0),
              child: Row(
                children: [
                  Text("Mirro Wall",style: TextStyle(color: Colors.white,fontSize: 30),),
                  SizedBox(width: 10,),
                  Image(image: NetworkImage("https://cdn-icons-png.flaticon.com/512/720/720255.png"),height: 40,width: 40,),

                ],
              ),);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}