import 'package:bot_toast/bot_toast.dart';
import 'package:covid_19/business/historyModel.dart';
import 'package:covid_19/business/latestmodel.dart';
import 'package:covid_19/business/services.dart';
import 'package:covid_19/constant.dart';
import 'package:covid_19/widgets/charts.dart';
import 'package:covid_19/historyPage.dart';
import 'package:covid_19/info_screen.dart';

import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:menu_button/menu_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()],
      title: 'Covid 19 Tracker',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            body1: TextStyle(color: kBodyTextColor),
          )),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    super.initState();
    _fetchApi();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  String selectedKey = 'West Bengal';
  List<String> keys = <String>[];
  Latest latestData;
  History historyData;

  _fetchApi() async {
    latestData = await CovidDataServices.getLatestData();
    latestData.data.regional.forEach((element) {
      keys.add(element.loc);
    });
    setState(() {});
    historyData = await CovidDataServices.getHistoryData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Widget normalChildButton = Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Color(0xFFE5E5E5),
        ),
      ),
      child: Row(
        children: <Widget>[
          SvgPicture.asset("assets/icons/maps-and-flags.svg"),
          SizedBox(width: 20),
          Expanded(child: Text(selectedKey)),
          SvgPicture.asset("assets/icons/dropdown.svg")
        ],
      ),
    );

    return Scaffold(
      body: LayoutBuilder(builder: (context, dimen) {
        if (dimen.maxWidth > 650) {
          return webView(normalChildButton, context);
        }
        return mobileView(normalChildButton, context);
      }),
    );
  }

  Widget webView(Widget normalChildButton, BuildContext context) {
    return Row(
      children: [
        Hero(
          tag: 'sidebar',
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
                    left: 30,
                    child: SvgPicture.asset(
                      "assets/images/fight.svg",
                      height: context.percentHeight * 40,
                      //height: context.percentHeight * 40,
                      fit: BoxFit.fill,
                      alignment: Alignment.topLeft,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: Text(
                      "All you need is to\nstay at home.",
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
                controller: controller,
                child: Column(
                  children: <Widget>[
                    latestData != null && historyData != null
                        ? Column(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  child: [
                                    "STAR ME ON"
                                        .text
                                        .size(16)
                                        .blueGray400
                                        .make(),
                                    12.widthBox,
                                    SvgPicture.string(
                                        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/></svg>'),
                                  ].hStack(),
                                ),
                              ).onTap(() async {
                                await launch(
                                    "https://github.com/imsudip/covid19_Tracker/tree/web",
                                    webOnlyWindowName: "blank");
                              }),
                              // Divider(
                              //   color: kPrimaryColor,
                              //   height: 1,
                              // ),
                              20.heightBox,
                              context.screenWidth > 1050
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _indiaCard(context, isweb: true)
                                            .expand(),
                                        30.widthBox,
                                        _stateCard(context, normalChildButton)
                                            .expand()
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        _indiaCard(context),
                                        20.heightBox,
                                        _stateCard(context, normalChildButton)
                                      ],
                                    ),
                            ],
                          )
                        : Container(
                            height: 60,
                            child: CircularProgressIndicator().centered(),
                          ),
                    30.heightBox,
                    "Know More"
                        .text
                        .size(24)
                        .semiBold
                        .letterSpacing(0.8)
                        .make(),
                    20.heightBox,
                    ExtendedImage.network(
                      "https://i.ibb.co/Fq3TPzn/banner.png",

                      fit: BoxFit.fitWidth,
                      cache: true,

                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      //cancelToken: cancellationToken,
                    ).px(16).onInkTap(() {
                      context.push((context) => InfoScreen());
                    }),
                    60.heightBox
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container _stateCard(BuildContext context, Widget normalChildButton) {
    return Container(
      child: Column(
        children: [
          "Regional".text.size(24).semiBold.letterSpacing(0.8).make(),
          20.heightBox,
          MenuButton<String>(
            child: normalChildButton,
            items: keys,
            topDivider: false,
            decoration: BoxDecoration(color: Colors.white),
            scrollPhysics: BouncingScrollPhysics(),
            popupHeight: context.percentHeight * 42,
            itemBuilder: (String value) => Container(
              height: 40,
              alignment: Alignment.centerLeft,
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
              child: Row(
                children: [
                  SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                  30.widthBox,
                  Expanded(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            toggledChild: Container(
              child: Container(),
            ),
            onItemSelected: (String value) {
              setState(() {
                selectedKey = value;
              });
            },
            onMenuButtonToggle: (bool isToggle) {
              print(isToggle);
            },
          ).px(16),
          25.heightBox,
          regionCard(
              title: selectedKey,
              isState: true,
              update: DateTimeFormat.format(latestData.lastRefreshed,
                  format: 'D, M j, h:i a'),
              infected: _getRegion(latestData.data.regional).totalConfirmed,
              dead: _getRegion(latestData.data.regional).deaths,
              recovered: _getRegion(latestData.data.regional).discharged,
              prevD: _getRegion(
                      historyData.data[historyData.data.lastIndex].regional)
                  .deaths,
              prevI: _getRegion(
                      historyData.data[historyData.data.lastIndex].regional)
                  .totalConfirmed,
              prevR: _getRegion(
                      historyData.data[historyData.data.lastIndex].regional)
                  .discharged),
        ],
      ),
    );
  }

  Container _indiaCard(BuildContext context, {bool isweb = false}) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          "India".text.size(24).semiBold.letterSpacing(0.8).make(),
          20.heightBox,
          isweb ? 75.heightBox : 0.heightBox,
          regionCard(
              title: "India",
              update: DateTimeFormat.format(latestData.lastRefreshed,
                  format: 'D, M j, h:i a'),
              infected: latestData.data.summary.total,
              dead: latestData.data.summary.deaths,
              recovered: latestData.data.summary.discharged,
              prevD:
                  historyData.data[historyData.data.lastIndex].summary.deaths,
              prevI: historyData.data[historyData.data.lastIndex].summary.total,
              prevR: historyData
                  .data[historyData.data.lastIndex].summary.discharged),
        ],
      ),
    );
  }

  SingleChildScrollView mobileView(
      Widget normalChildButton, BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        children: <Widget>[
          MyHeader(
            image: "assets/images/fight.svg",
            textTop: "All you need  is to",
            textBottom: "stay at home.",
            offset: offset,
          ),
          latestData != null && historyData != null
              ? Column(
                  children: [
                    Column(
                      children: [
                        _indiaCard(context),
                        20.heightBox,
                        _stateCard(context, normalChildButton)
                      ],
                    ),
                  ],
                )
              : Container(
                  height: 60,
                  child: CircularProgressIndicator().centered(),
                ),
          20.heightBox,
          "Know More".text.size(24).semiBold.letterSpacing(0.8).make(),
          20.heightBox,
          ExtendedImage.network(
            "https://i.ibb.co/Fq3TPzn/banner.png",

            fit: BoxFit.fitWidth,
            cache: true,

            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            //cancelToken: cancellationToken,
          ).px(16).onInkTap(() {
            context.push((context) => InfoScreen());
          }),
          60.heightBox
        ],
      ),
    );
  }

  Regional _getRegion(List<Regional> data) {
    return data.firstWhere((element) => element.loc == selectedKey);
  }

  Padding regionCard(
      {String title,
      String update,
      int infected,
      int dead,
      int recovered,
      int prevI,
      int prevD,
      bool isState = false,
      int prevR}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$title\n",
                      style: kTitleTextstyle,
                    ),
                    TextSpan(
                      text: "Updated $update",
                      style: TextStyle(
                        color: kTextLightColor,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Text(
                "See details",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ).onTap(() {
                if (isState) {
                  context.push((context) => HistoryPage(
                        history: historyData,
                        latest: latestData,
                        isState: true,
                        stateIndex: latestData.data.regional.indexWhere(
                            (element) => element.loc == selectedKey),
                        stateName: selectedKey,
                      ));
                } else
                  context.push((context) => HistoryPage(
                        history: historyData,
                        latest: latestData,
                      ));
              }),
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 30,
                  color: kShadowColor,
                ),
              ],
            ),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Counter(
                  color: kInfectedColor,
                  number: infected,
                  recent: infected - prevI,
                  title: "Infected",
                ),
                Counter(
                  color: kDeathColor,
                  number: dead,
                  recent: dead - prevD,
                  title: "Deaths",
                ),
                Counter(
                  color: kRecovercolor,
                  number: recovered,
                  recent: recovered - prevR,
                  title: "Recovered",
                ),
              ],
            ),
          ),
          12.heightBox,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 3,
                  color: kShadowColor,
                ),
              ],
            ),
            child: Container(
              height: 12,
              width: 300,
              child: Stack(
                children: [
                  AnimatedPositioned(
                      right: 0,
                      duration: Duration(milliseconds: 500),
                      top: 0,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 300 * ((infected - recovered - dead) / infected),
                        color: kInfectedColor.withOpacity(0.7),
                      )),
                  AnimatedPositioned(
                      duration: Duration(milliseconds: 500),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 300 * (recovered / infected),
                        color: kRecovercolor.withOpacity(0.7),
                      )),
                  AnimatedPositioned(
                      duration: Duration(milliseconds: 500),
                      left: 300 * (recovered / infected),
                      top: 0,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 300 * (dead / infected),
                        color: kDeathColor.withOpacity(0.7),
                      ))
                ],
              ),
            ).cornerRadius(20),
          )
          // SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     Text(
          //       "Spread of Virus",
          //       style: kTitleTextstyle,
          //     ),
          //     Text(
          //       "See details",
          //       style: TextStyle(
          //         color: kPrimaryColor,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ],
          // ),
          // Container(
          //   margin: EdgeInsets.only(top: 20),
          //   padding: EdgeInsets.all(20),
          //   height: 178,
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(20),
          //     color: Colors.white,
          //     boxShadow: [
          //       BoxShadow(
          //         offset: Offset(0, 10),
          //         blurRadius: 30,
          //         color: kShadowColor,
          //       ),
          //     ],
          //   ),
          //   child: Image.asset(
          //     "assets/images/map.png",
          //     fit: BoxFit.contain,
          //   ),
          // ),
        ],
      ),
    );
  }
}
