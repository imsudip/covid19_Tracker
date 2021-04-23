import 'package:covid_19/constant.dart';
import 'package:covid_19/info_screen.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

class MyHeader extends StatefulWidget {
  final String image;
  final String textTop;
  final String textBottom;
  final double offset, height;
  final bool isImage;
  const MyHeader(
      {Key key,
      this.image,
      this.textTop,
      this.textBottom,
      this.offset,
      this.isImage = false,
      this.height = 300})
      : super(key: key);

  @override
  _MyHeaderState createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeader> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 50, right: 16),
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF3383CD),
              Color(0xFF11249F),
            ],
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/virus.png"),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: (widget.offset < 0) ? 0 : widget.offset,
                    //left: -30,
                    child: widget.isImage
                        ? ExtendedImage.network(
                            widget.image,
                            width: context.percentWidth * 33,
                            fit: BoxFit.fill,
                            alignment: Alignment.topCenter,
                          )
                        : SvgPicture.asset(
                            widget.image,
                            width: context.percentWidth * 40,
                            //height: context.percentHeight * 40,
                            fit: BoxFit.fill,
                            alignment: Alignment.topLeft,
                          ),
                  ),
                  Positioned(
                    top: 20 - widget.offset / 2,
                    right: 0,
                    child: Text(
                      "${widget.textTop} \n${widget.textBottom}",
                      textAlign: TextAlign.right,
                      style: kHeadingTextStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(), // I dont know why it can't work without container
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
