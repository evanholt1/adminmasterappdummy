import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:admin_eshop/modules/main/providers/HomeScreenProvider.dart';
import 'package:admin_eshop/modules/main/screens/home/widgets/CategoryProductChart/HomeScreenCategoryProductChartIndicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenCategoryProductChart extends StatefulWidget {
  const HomeScreenCategoryProductChart({Key? key}) : super(key: key);

  @override
  _HomeScreenCategoryProductChartState createState() => _HomeScreenCategoryProductChartState();
}

class _HomeScreenCategoryProductChartState extends State<HomeScreenCategoryProductChart> {
  @override
  Widget build(BuildContext context) {
    var touchedIndex = context.select((HomeScreenProvider p) => p.touchedIndex);
    var colorList = context.select((HomeScreenProvider p) => p.colorList);
    var catList = context.select((HomeScreenProvider p) => p.catList);
    var catCountList = context.select((HomeScreenProvider p) => p.catCountList);

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: AspectRatio(
        aspectRatio: 1.23,
        child: Card(
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Categories product count",
                  style: Theme.of(context).textTheme.headline6!.copyWith(color: AppColors.primary),
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    const SizedBox(height: 18),
                    Expanded(
                      flex: 2,
                      child: AspectRatio(
                        aspectRatio: .8,
                        child: Stack(
                          children: [
                            PieChart(
                              PieChartData(
                                  pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      final desiredTouch = event is! FlPointerExitEvent && event is! FlTapUpEvent;
                                      if (desiredTouch && pieTouchResponse?.touchedSection != null) {
                                        touchedIndex = pieTouchResponse!.touchedSection!.touchedSectionIndex;
                                      } else {
                                        touchedIndex = -1;
                                      }
                                    });
                                  }),
                                  borderData: FlBorderData(show: false),
                                  sectionsSpace: 0,
                                  startDegreeOffset: 180,
                                  centerSpaceRadius: 40,
                                  sections: _showingSections(
                                      touchedIndex: touchedIndex, colorList: colorList, catCountList: catCountList)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shrinkWrap: true,
                        itemCount: colorList.length,
                        itemBuilder: (context, i) {
                          return HomeScreenCategoryProductCountIndicator(
                              color: colorList[i],
                              text: catList[i] + " " + catCountList[i],
                              textColor: touchedIndex == i ? Colors.black : Colors.grey,
                              isSquare: true);
                        },
                      ),
                    ),
                    const SizedBox(width: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections(
      {required int touchedIndex, required List catCountList, required List<Color> colorList}) {
    return List.generate(catCountList.length, (i) {
      final isTouched = i == touchedIndex;
      //  final double opacity = isTouched ? 1 : 0.6;

      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;

      return PieChartSectionData(
        color: colorList[i],
        value: double.parse(catCountList[i].toString()),
        title: "",
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, color: const Color(0xffffffff)),
      );
    });
  }
}
