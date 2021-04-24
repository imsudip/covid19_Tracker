import 'package:covid_19/constant.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, dimen) {
        if (dimen.maxWidth > 650) {
          return webView();
        }
        return movileView();
      }),
    );
  }

  Widget webView() {
    return Row(
      children: [
        Hero(
          tag: "sidebar",
          child: Material(
            child: Container(
              width: 300,
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
              child: Stack(
                children: [
                  Positioned(
                      bottom: 30,
                      left: 60,
                      child: ExtendedImage.network(
                        "https://i.ibb.co/7z3D8RX/doctor2.png",
                        width: 150,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      )),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: Text(
                      "Get to know\nAbout Covid-19.",
                      textAlign: TextAlign.right,
                      style: kHeadingTextStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Flexible(
            child: Container(
          child: Scrollbar(
            controller: controller,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_back).onTap(() {
                        context.pop();
                      }),
                      "Know More".text.size(16).blueGray400.make(),
                    ],
                  ).px(20).py(8),
                  26.heightBox,
                  Text(
                    "Symptoms",
                    style: kTitleTextstyle,
                  ),
                  SizedBox(height: 20),
                  Container(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SymptomCard(
                          image: "assets/images/headache.png",
                          title: "Headache",
                          isActive: true,
                        ).expand(),
                        8.widthBox,
                        SymptomCard(
                          image: "assets/images/caugh.png",
                          title: "Caugh",
                        ).expand(),
                        8.widthBox,
                        SymptomCard(
                          image: "assets/images/fever.png",
                          title: "Fever",
                        ).expand(),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Prevention", style: kTitleTextstyle),
                  SizedBox(height: 20),
                  Container(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: ExtendedImage.network(
                      "https://i.ibb.co/bswZCTK/dos.png",

                      fit: BoxFit.fitWidth,
                      cache: true,

                      // borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      //cancelToken: cancellationToken,
                    ).px(0),
                  ),
                  12.heightBox,
                  Container(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: ExtendedImage.network(
                      "https://i.ibb.co/V3ktswB/donts.png",

                      fit: BoxFit.fitWidth,
                      cache: true,

                      // borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      //cancelToken: cancellationToken,
                    ).px(0),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ))
      ],
    );
  }

  SingleChildScrollView movileView() {
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MyHeader(
            image: "https://i.ibb.co/7z3D8RX/doctor2.png",
            isImage: true,
            textTop: "Get to know",
            textBottom: "About Covid-19.",
            offset: offset,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Symptoms",
                  style: kTitleTextstyle,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SymptomCard(
                      image: "assets/images/headache.png",
                      title: "Headache",
                      isActive: true,
                    ).expand(),
                    8.widthBox,
                    SymptomCard(
                      image: "assets/images/caugh.png",
                      title: "Caugh",
                    ).expand(),
                    8.widthBox,
                    SymptomCard(
                      image: "assets/images/fever.png",
                      title: "Fever",
                    ).expand(),
                  ],
                ),
                SizedBox(height: 20),
                Text("Prevention", style: kTitleTextstyle),
                SizedBox(height: 20),
                ExtendedImage.network(
                  "https://i.ibb.co/bswZCTK/dos.png",

                  fit: BoxFit.fitWidth,
                  cache: true,

                  // borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  //cancelToken: cancellationToken,
                ).px(0),
                12.heightBox,
                ExtendedImage.network(
                  "https://i.ibb.co/V3ktswB/donts.png",

                  fit: BoxFit.fitWidth,
                  cache: true,

                  // borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  //cancelToken: cancellationToken,
                ).px(0),
                SizedBox(height: 50),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PreventCard extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  const PreventCard({
    Key key,
    this.image,
    this.title,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 156,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: 136,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 8),
                    blurRadius: 24,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
            Image.asset(image),
            Positioned(
              left: 130,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                height: 136,
                width: MediaQuery.of(context).size.width - 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: kTitleTextstyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset("assets/icons/forward.svg"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SymptomCard extends StatelessWidget {
  final String image;
  final String title;
  final bool isActive;
  const SymptomCard({
    Key key,
    this.image,
    this.title,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          isActive
              ? BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 20,
                  color: kActiveShadowColor,
                )
              : BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  color: kShadowColor,
                ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Image.asset(image, height: 50),
          12.heightBox,
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
