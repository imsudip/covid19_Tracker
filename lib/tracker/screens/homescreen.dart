import 'package:bot_toast/bot_toast.dart';
import 'package:covid_19/tracker/business/historyModel.dart';
import 'package:covid_19/tracker/business/latestmodel.dart';
import 'package:covid_19/tracker/business/services.dart';
import 'package:covid_19/constant.dart';
import 'package:covid_19/widgets/charts.dart';
import 'package:covid_19/tracker/screens/historyPage.dart';
import 'package:covid_19/tracker/screens/info_screen.dart';

import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:menu_button/menu_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:date_time_format/date_time_format.dart';

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
      body: SingleChildScrollView(
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
                      "India".text.size(24).semiBold.letterSpacing(0.8).make(),
                      20.heightBox,
                      regionCard(
                          title: "India",
                          update: DateTimeFormat.format(
                              latestData.lastRefreshed,
                              format: 'D, M j, h:i a'),
                          infected: latestData.data.summary.total,
                          dead: latestData.data.summary.deaths,
                          recovered: latestData.data.summary.discharged,
                          prevD: historyData
                              .data[historyData.data.lastIndex].summary.deaths,
                          prevI: historyData
                              .data[historyData.data.lastIndex].summary.total,
                          prevR: historyData.data[historyData.data.lastIndex]
                              .summary.discharged),
                      20.heightBox,
                      "Regional"
                          .text
                          .size(24)
                          .semiBold
                          .letterSpacing(0.8)
                          .make(),
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 16),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                  "assets/icons/maps-and-flags.svg"),
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
                          update: DateTimeFormat.format(
                              latestData.lastRefreshed,
                              format: 'D, M j, h:i a'),
                          infected: _getRegion(latestData.data.regional)
                              .totalConfirmed,
                          dead: _getRegion(latestData.data.regional).deaths,
                          recovered:
                              _getRegion(latestData.data.regional).discharged,
                          prevD: _getRegion(historyData
                                  .data[historyData.data.lastIndex].regional)
                              .deaths,
                          prevI: _getRegion(historyData
                                  .data[historyData.data.lastIndex].regional)
                              .totalConfirmed,
                          prevR: _getRegion(historyData
                                  .data[historyData.data.lastIndex].regional)
                              .discharged),
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
              width: context.screenWidth - 50,
              child: Stack(
                children: [
                  AnimatedPositioned(
                      right: 0,
                      duration: Duration(milliseconds: 500),
                      top: 0,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: (context.screenWidth - 50) *
                            ((infected - recovered - dead) / infected),
                        color: kInfectedColor.withOpacity(0.7),
                      )),
                  AnimatedPositioned(
                      duration: Duration(milliseconds: 500),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width:
                            (context.screenWidth - 50) * (recovered / infected),
                        color: kRecovercolor.withOpacity(0.7),
                      )),
                  AnimatedPositioned(
                      duration: Duration(milliseconds: 500),
                      left: (context.screenWidth - 50) * (recovered / infected),
                      top: 0,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: (context.screenWidth - 50) * (dead / infected),
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
