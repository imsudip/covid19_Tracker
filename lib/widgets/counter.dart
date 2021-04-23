import 'package:covid_19/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:countup/countup.dart';

class Counter extends StatelessWidget {
  final int number, recent;
  final Color color;
  final String title, subTitle;
  const Counter({
    Key key,
    this.number,
    this.color,
    this.title,
    this.recent = -1,
    this.subTitle = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(.26),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NumberSlideAnimation(
            //   number: "$number",
            //   duration: const Duration(seconds: 2),
            //   curve: Curves.fastOutSlowIn,
            //   textStyle: TextStyle(fontSize: 30, color: color, height: 1),
            // ),
            Countup(
                begin: 0,
                end: number.toDouble(),
                duration: Duration(milliseconds: 1000),
                curve: Curves.elasticIn,
                precision: 0,
                separator: ',',
                style: GoogleFonts.rubik(
                    textStyle:
                        TextStyle(fontSize: 30, color: color, height: 1))),
            // Text(
            //   "$number",
            //   style: TextStyle(fontSize: 30, color: color, height: 1),
            // ),
            recent == -1 ? 0.heightBox : 4.heightBox,
            recent == -1
                ? 0.heightBox
                : Text("+ $recent",
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: Vx.coolGray500,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              height: 1),
                        ))
                    .px(8)
                    .py(4)
                    .box
                    .color(color.withOpacity(0.1))
                    .make()
                    .cornerRadius(6),
          ],
        ).py(8),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(title, style: kSubTextStyle),
            subTitle.isNotEmpty
                ? Text(
                    subTitle,
                    style: kSubTextStyle.copyWith(
                        fontSize: 14, height: 1, color: Vx.coolGray400),
                  )
                : Container()
          ],
        ),
      ],
    );
  }
}
