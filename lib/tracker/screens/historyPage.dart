import 'package:covid_19/tracker/business/latestmodel.dart';
import 'package:covid_19/widgets/charts.dart';
import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import '../business/historyModel.dart';
import '../../constant.dart';

class HistoryPage extends StatefulWidget {
  final History history;
  final Latest latest;
  final int stateIndex;
  final String stateName;
  final bool isState;
  HistoryPage(
      {Key key,
      this.history,
      this.latest,
      this.stateIndex,
      this.isState = false,
      this.stateName})
      : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final controller = ScrollController();
  double offset = 0;
  History history;
  @override
  void initState() {
    super.initState();
    history = widget.history;
    if (widget.isState) {
      List<Datum> data = [];
      widget.history.data.forEach((ele) {
        if (ele.regional
                .indexWhere((element) => element.loc == widget.stateName) !=
            -1) {
          data.add(ele);
        }
      });
      history.data = data;
    }
    controller.addListener(onScroll);

    latestData = widget.latest.data;
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

  Data latestData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              MyHeader(
                image: "https://i.ibb.co/p3zPsqM/doctor.png",
                isImage: true,
                textTop: "Details",
                textBottom: "",
                offset: offset,
                height: 250,
              ),
              "History".text.size(24).semiBold.letterSpacing(0.8).make(),
              "${widget.isState ? widget.stateName : "India"}"
                  .text
                  .size(16)
                  .lineHeight(1)
                  .letterSpacing(0.8)
                  .make(),
              4.heightBox,
              "( ${DateTimeFormat.format(history.data[0].day, format: 'M j,Y')} - ${DateTimeFormat.format(history.data[history.data.lastIndex].day, format: 'M j,Y')} )"
                  .text
                  .size(16)
                  .coolGray400
                  .lineHeight(1)
                  .letterSpacing(0.8)
                  .make(),
              16.heightBox,
              ChartView(
                history: history,
                isState: widget.isState,
                stateName: widget.stateName,
              ),
              24.heightBox,
              "More details".text.size(24).semiBold.letterSpacing(0.8).make(),
              "Today".text.size(16).lineHeight(1).letterSpacing(0.8).make(),
              12.heightBox,
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
                      number: widget.isState
                          ? latestData
                              .regional[widget.stateIndex].totalConfirmed
                          : latestData.summary.total,
                      title: "Infected",
                    ),
                    Counter(
                      color: kInfectedColor,
                      number: widget.isState
                          ? latestData
                              .regional[widget.stateIndex].confirmedCasesIndian
                          : latestData.summary.confirmedCasesIndian,
                      title: "Indian",
                      subTitle: "cases",
                    ),
                    Counter(
                      color: kInfectedColor,
                      number: widget.isState
                          ? latestData
                              .regional[widget.stateIndex].confirmedCasesForeign
                          : latestData.summary.confirmedCasesForeign,
                      title: "Foreign",
                      subTitle: "cases",
                    ),
                    !widget.isState
                        ? Counter(
                            color: kInfectedColor,
                            number: latestData
                                .summary.confirmedButLocationUnidentified,
                            subTitle: "Location",
                            title: "Unidentified",
                          )
                        : 0.heightBox,
                    Counter(
                      color: kDeathColor,
                      number: widget.isState
                          ? latestData.regional[widget.stateIndex].deaths
                          : latestData.summary.deaths,
                      title: "Deaths",
                    ),
                    Counter(
                      color: kRecovercolor,
                      number: widget.isState
                          ? latestData.regional[widget.stateIndex].discharged
                          : latestData.summary.discharged,
                      title: "Recovered",
                    ),
                  ],
                ),
              ).px(16),
            ],
          )),
    );
  }
}
