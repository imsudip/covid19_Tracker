import 'package:covid_19/tracker/business/historyModel.dart';
import 'package:covid_19/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart' as slider;
import 'package:syncfusion_flutter_core/theme.dart';

class ChartView extends StatefulWidget {
  final History history;
  // final int stateIndex;
  final bool isState;
  final String stateName;
  ChartView({Key key, this.history, this.isState = false, this.stateName})
      : super(key: key);

  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  List<Datum> allList;
  slider.SfRangeValues yearList;
  bool enableAnimation = true;
  @override
  void initState() {
    super.initState();

    allList = widget.history.data;
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        enableAnimation = false;
      });
    });
    print(allList[allList.lastIndex].day.day);
    yearList =
        slider.SfRangeValues(allList[0].day, allList[allList.lastIndex].day);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: context.percentHeight * 40,
            child: _buildDefaultPanningChart(yearList).px(10)),
        "Isolate particualar section".text.make(),
        _yearRangeSlider().px(30)
      ],
    );
  }

  SfRangeSliderTheme _yearRangeSlider() {
    return SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
            tooltipBackgroundColor: Colors.black.withOpacity(0.68),
            activeTrackColor: kPrimaryColor,
            overlayRadius: 16,
            thumbStrokeColor: kPrimaryColor,
            thumbColor: Colors.white,
            thumbStrokeWidth: 1,
            thumbRadius: 7),
        child: slider.SfRangeSlider(
          min: allList[0].day,
          max: allList[allList.lastIndex].day,
          showLabels: true,
          interval: 3,
          dateFormat: DateFormat.MMM(),
          //labelPlacement: slider.LabelPlacement.betweenTicks,
          dateIntervalType: slider.DateIntervalType.months,
          showTicks: true,
          values: yearList,

          onChanged: (slider.SfRangeValues values) {
            //ignore date between 2021-6-30 to 2021-8-01
            print(values.start);
            print(values.end);
            if (values.start.isAfter(DateTime(2021, 6, 30)) &&
                values.start.isBefore(DateTime(2021, 7, 31))) {
              print("in else");
              var newStart = DateTime(2021, 8, 1);
              var newValues = slider.SfRangeValues(newStart, values.end);
              setState(() {
                yearList = newValues;
              });
            } else if (values.end.isBefore(DateTime(2021, 8, 1)) &&
                values.end.isAfter(DateTime(2021, 7, 01))) {
              var newEnd = DateTime(2021, 6, 30);
              var newValues = slider.SfRangeValues(values.start, newEnd);
              setState(() {
                yearList = newValues;
              });
            } else {
              setState(() {
                yearList = values;
              });
            }
          },
          enableTooltip: true,
          tooltipTextFormatterCallback:
              (dynamic actualLabel, String formattedText) {
            return DateFormat.yMMMd().format(actualLabel);
          },
        ));
  }

  /// Returns the cartesian chart with pinch zoomings.
  SfCartesianChart _buildDefaultPanningChart(slider.SfRangeValues yearList) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,

      primaryXAxis: DateTimeAxis(
          majorGridLines: MajorGridLines(width: 0),
          //intervalType: DateTimeIntervalType.months,
          //  interval: 2.5,
          rangePadding: ChartRangePadding.auto,
          associatedAxisName: "date"),
      primaryYAxis: NumericAxis(
        name: "people",
        axisLine: AxisLine(width: 1),
        numberFormat: NumberFormat.compact(),
        rangePadding: ChartRangePadding.round,
        majorGridLines: MajorGridLines(width: 0),
      ),

      series: getDefaultPanningSeries(yearList),
      legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          overflowMode: LegendItemOverflowMode.none,
          toggleSeriesVisibility: true),

      /// To set the track ball as true and customized trackball behaviour.
      trackballBehavior: TrackballBehavior(
        enable: true,
        markerSettings: TrackballMarkerSettings(
          markerVisibility: TrackballVisibilityMode.visible,
          height: 10,
          width: 10,
          borderWidth: 1,
        ),
        hideDelay: 1000,
        activationMode: ActivationMode.singleTap,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        shouldAlwaysShow: true,
      ),
    );
  }

  /// Returns the list of chart series
  /// which need to render on the chart with pinch zooming.
  _getColorList(Color color1, Color color2, Color color3) {
    final List<Color> colors = <Color>[];
    colors.add(color3);

    colors.add(color2);
    colors.add(color1);
    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.7);
    stops.add(1.0);
    final LinearGradient gradientColors = LinearGradient(
        colors: colors,
        stops: stops,
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter);
    return gradientColors;
  }

  List<AreaSeries<Datum, DateTime>> getDefaultPanningSeries(
      slider.SfRangeValues yearList) {
    var start = allList.indexWhere((element) =>
        element.day ==
        DateTime(
            yearList.start.year, yearList.start.month, yearList.start.day));
    var end = allList.indexWhere((element) =>
        element.day ==
        DateTime(yearList.end.year, yearList.end.month, yearList.end.day));

    var historyData = allList.sublist(start, end + 1);
    return <AreaSeries<Datum, DateTime>>[
      AreaSeries<Datum, DateTime>(
        dataSource: historyData,
        animationDuration: enableAnimation ? 1000 : 0,

        emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
        name: "Infected",
        legendIconType: LegendIconType.circle,
        xValueMapper: (Datum sales, _) => sales.day,
        yValueMapper: (Datum sales, _) => widget.isState
            ? sales
                .regional[sales.regional
                    .indexWhere((element) => element.loc == widget.stateName)]
                .totalConfirmed
            : sales.summary.total,
        //  color: kInfectedColor
        gradient:
            _getColorList(kInfectedColor, Color(0xffFFB288), Color(0xffFEE3D6)),
      ),
      AreaSeries<Datum, DateTime>(
        dataSource: historyData,
        animationDuration: enableAnimation ? 1000 : 0,
        emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
        legendIconType: LegendIconType.circle,
        name: "Recovered",
        xValueMapper: (Datum sales, _) => sales.day,
        yValueMapper: (Datum sales, _) => widget.isState
            ? sales
                .regional[sales.regional
                    .indexWhere((element) => element.loc == widget.stateName)]
                .discharged
            : sales.summary.discharged,
        // color: kRecovercolor
        gradient:
            _getColorList(kRecovercolor, Color(0xff7BD775), Color(0xffD4F1D1)),
      ),
      AreaSeries<Datum, DateTime>(
        dataSource: historyData,
        animationDuration: enableAnimation ? 1000 : 0,
        emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
        legendIconType: LegendIconType.circle,
        name: "Deaths",
        xValueMapper: (Datum sales, _) => sales.day,
        yValueMapper: (Datum sales, _) => widget.isState
            ? sales
                .regional[sales.regional
                    .indexWhere((element) => element.loc == widget.stateName)]
                .deaths
            : sales.summary.deaths,
        // color: kDeathColor
        gradient:
            _getColorList(kDeathColor, Color(0xffFE7979), Color(0xffFFD7D5)),
      )
    ];
  }
}
