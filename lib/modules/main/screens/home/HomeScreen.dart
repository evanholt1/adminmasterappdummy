import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:admin_eshop/DeliveryBoy.dart';
import 'package:admin_eshop/Helper/AppBtn.dart';
import 'package:admin_eshop/Helper/Constant.dart';
import 'package:admin_eshop/Helper/PushNotificationService.dart';
import 'package:admin_eshop/Helper/Session.dart';
import 'package:admin_eshop/Helper/String.dart';
import 'package:admin_eshop/Models/Order_Model.dart';
import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:admin_eshop/modules/main/blocs/selected_drawer/selected_drawer_cubit.dart';
import 'package:admin_eshop/modules/main/providers/CardsCountsProvider.dart';
import 'package:admin_eshop/modules/main/providers/HomeScreenProvider.dart';
import 'package:admin_eshop/modules/main/screens/home/widgets/CategoryProductChart/HomeScreenCategoryProductChartIndicator.dart';
import 'package:admin_eshop/modules/main/screens/home/widgets/Drawer/HomeScreenDrawer.dart';
import 'package:admin_eshop/modules/orders/screens/order_list/OrderList.dart';
import 'package:admin_eshop/modules/product/screens/product_list/ProductList.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateHome();
  }
}

List<Order_Model> orderList = [];

bool isLoadingmore = true;
// List<PersonModel> delBoyList = [];

class StateHome extends State<HomeScreen> with TickerProviderStateMixin {
  int curChart = 0;
  int touchedIndex = -1;
  bool _isNetworkAvail = true;
  List<Order_Model> tempList = [];
  late Animation buttonSqueezeanimation;
  late AnimationController buttonController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  late String profile;
  ScrollController controller = new ScrollController();
  late String? orderCount, productCount, custCount, delBoyCount, soldOutCount, lowStockCount;
  Map<int, LineChartData>? chartList;
  List days = [], dayEarning = [];
  List months = [], monthEarning = [];
  List weeks = [], weekEarning = [];
  List catCountList = [], catList = [];
  List colorList = [];
  bool _isLoading = true;

  @override
  void initState() {
    orderList.clear();
    final pushNotificationService = PushNotificationService(context: context);

    pushNotificationService.initialise();
    getStatics();
    //getOrder();
    // getDeliveryBoy();

    buttonController = new AnimationController(duration: new Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = new Tween(begin: 70.0.w, end: 50.0)
        .animate(new CurvedAnimation(parent: buttonController, curve: new Interval(0.0, 0.150)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SelectedDrawerCubit>(create: (_) => SelectedDrawerCubit()),
      ],
      child: MultiProvider(
        providers: [
          Provider<int>.value(value: touchedIndex), // to be removed
          ChangeNotifierProvider<HomeScreenProvider>(create: (_) => HomeScreenProvider()),
          ChangeNotifierProvider<CardsCountsProvider>(create: (_) => CardsCountsProvider()),
        ],
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: AppColors.lightWhite,
            appBar: AppBar(
                title: Text(appName, style: TextStyle(color: AppColors.grad2Color)),
                iconTheme: IconThemeData(color: AppColors.grad2Color),
                backgroundColor: AppColors.white),
            drawer: HomeScreenDrawer(),
            body: _isNetworkAvail
                ? _isLoading || context.watch<CardsCountsProvider>().loading
                    ? shimmer()
                    : RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: _refresh,
                        child: SingleChildScrollView(
                            controller: controller,
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  _detailHeader(context),
                                  _detailHeader2(context),
                                  Container(
                                    height: 250,
                                    child: Card(
                                      elevation: 0,
                                      margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                                      child: Stack(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                                                  child: Text(
                                                    'Product Sales',
                                                    style:
                                                        Theme.of(context).textTheme.headline6!.copyWith(color: primary),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                      style: curChart == 0
                                                          ? TextButton.styleFrom(
                                                              primary: Colors.white,
                                                              backgroundColor: primary,
                                                              onSurface: Colors.grey,
                                                            )
                                                          : null,
                                                      onPressed: () {
                                                        setState(() {
                                                          curChart = 0;
                                                        });
                                                      },
                                                      child: Text('Day')),
                                                  TextButton(
                                                      style: curChart == 1
                                                          ? TextButton.styleFrom(
                                                              primary: Colors.white,
                                                              backgroundColor: primary,
                                                              onSurface: Colors.grey,
                                                            )
                                                          : null,
                                                      onPressed: () {
                                                        setState(() {
                                                          curChart = 1;
                                                        });
                                                      },
                                                      child: Text('Week')),
                                                  TextButton(
                                                      style: curChart == 2
                                                          ? TextButton.styleFrom(
                                                              primary: Colors.white,
                                                              backgroundColor: primary,
                                                              onSurface: Colors.grey,
                                                            )
                                                          : null,
                                                      onPressed: () {
                                                        setState(() {
                                                          curChart = 2;
                                                        });
                                                      },
                                                      child: Text('Month'))
                                                ],
                                              ),
                                              SizedBox(height: 2.0.h),
                                              if (chartList != null)
                                                Expanded(
                                                  child: LineChart(
                                                    chartList![curChart]!,
                                                    swapAnimationDuration: const Duration(milliseconds: 250),
                                                  ),
                                                ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  catChart()
                                ]))))
                : noInternet(context),
          ),
        ),
      ),
    );
  }

  LineChartData dayData() {
    if (dayEarning.length == 0) {
      dayEarning.add(0);
      days.add(0);
    }
    List<FlSpot> spots = dayEarning.asMap().entries.map((e) {
      return FlSpot(double.parse(days[e.key].toString()), double.parse(e.value.toString()));
    }).toList();

    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 2,
          colors: [
            grad2Color,
          ],
          belowBarData: BarAreaData(
            show: true,
            colors: [primary.withOpacity(0.5)],
            //cutOffY: cutOffYValue,
            // applyCutOffY: true,
          ),
          aboveBarData: BarAreaData(
            show: true,
            colors: [fontColor.withOpacity(0.2)],
            // cutOffY: 0,
            // applyCutOffY: true,
          ),
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
      minY: 0,
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 3,
            //reservedSize: 22,
            getTextStyles: (value, __) => const TextStyle(
                  color: black,
                  fontSize: 9,
                ),
            margin: 10,
            getTitles: (value) {
              return value.toInt().toString();
            }),
        leftTitles: SideTitles(
          showTitles: true,
        ),
      ),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: fontColor.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
    );
  }

  catChart() {
    Size size = MediaQuery.of(context).size;
    double width = size.width > size.height ? size.height : size.width;
    double ratio;
    if (width > 600) {
      ratio = 0.5;
      // Do something for tablets here
    } else {
      ratio = 0.8;
      // Do something for phones
    }
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
                  "Category wise product's count",
                  style: Theme.of(context).textTheme.headline6!.copyWith(color: primary),
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      height: 18,
                    ),
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
                                      var touchedIndex = context.read<HomeScreenProvider>().touchedIndex;
                                      final desiredTouch = event is! FlPointerExitEvent && event is! FlTapUpEvent;
                                      if (desiredTouch && pieTouchResponse?.touchedSection != null) {
                                        touchedIndex = pieTouchResponse!.touchedSection!.touchedSectionIndex;
                                      } else {
                                        touchedIndex = -1;
                                      }
                                    });
                                  }),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  startDegreeOffset: 180,
                                  centerSpaceRadius: 40,
                                  sections: showingSections()),
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

  List<PieChartSectionData> showingSections() {
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

  Color generateRandomColor() {
    Random random = Random();
    // Pick a random number in the range [0.0, 1.0)
    double randomDouble = random.nextDouble();

    return Color((randomDouble * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  LineChartData weekData() {
    if (weekEarning.length == 0) {
      weekEarning.add(0);
      weeks.add(0);
    }
    List<FlSpot> spots = weekEarning.asMap().entries.map((e) {
      return FlSpot(double.parse(e.key.toString()), double.parse(e.value.toString()));
    }).toList();

    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 2,
          colors: [
            grad2Color,
          ],
          belowBarData: BarAreaData(
            show: true,
            colors: [primary.withOpacity(0.5)],
            //cutOffY: cutOffYValue,
            // applyCutOffY: true,
          ),
          aboveBarData: BarAreaData(
            show: true,
            colors: [fontColor.withOpacity(0.2)],
            //  cutOffY: 0,
            // applyCutOffY: true,
          ),
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
      minY: 0,
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 3,
            //reservedSize: 22,
            getTextStyles: (value, __) => const TextStyle(
                  color: black,
                  fontSize: 9,
                ),
            margin: 10,
            getTitles: (value) {
              return weeks[value.toInt()];
            }),
        leftTitles: SideTitles(
          showTitles: true,

//          getTitles: (value) {
//            if (value.toInt() % 500000 == 0) {
//                 int val = ((value.toInt()) ~/ 1000);
//              return '${val}K';
//            } else {
//              return '';
//            }
//          },
          // margin: 20,
          //reservedSize: 10,
        ),
      ),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: fontColor.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
    );
  }

  LineChartData monthData() {
    if (monthEarning.length == 0) {
      monthEarning.add(0);
      months.add(0);
    }

    List<FlSpot> spots = monthEarning.asMap().entries.map((e) {
      return FlSpot(double.parse(e.key.toString()), double.parse(e.value.toString()));
    }).toList();

    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 2,
          colors: [
            grad2Color,
          ],
          belowBarData: BarAreaData(
            show: true,
            colors: [primary.withOpacity(0.5)],
            //cutOffY: cutOffYValue,
            // applyCutOffY: true,
          ),
          aboveBarData: BarAreaData(
            show: true,
            colors: [fontColor.withOpacity(0.2)],
            // cutOffY: cutOffYValue,
            // applyCutOffY: true,
          ),
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
      minY: 0,
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 3,
            //reservedSize: 22,
            getTextStyles: (value, __) => const TextStyle(
                  color: black,
                  fontSize: 9,
                ),
            margin: 10,
            getTitles: (value) {
              return months[value.toInt()];
            }),

//        leftTitles: SideTitles(
//          showTitles: true,
//
//          getTitles: (value) {
//            if (value.toInt() % 2 == 0) {
//              return '$value';
//            } else {
//              return '';
//            }
//          },
//          // margin: 20,
//          //reservedSize: 10,
//        ),
      ),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: fontColor.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    buttonController.dispose();
    super.dispose();
  }

  Future<Null> _refresh() {
    orderList.clear();

    setState(() {
      _isLoading = true;
    });
    //getStatics();
    //orderList.clear();
    return getStatics();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: TRY_AGAIN_INT_LBL,
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: () async {
              _playAnimation();

              Future.delayed(Duration(seconds: 2)).then((_) async {
                _isNetworkAvail = await isNetworkAvailable();
                if (_isNetworkAvail) {
                  getStatics();
                } else {
                  await buttonController.reverse();
                  setState(() {});
                }
              });
            },
          )
        ]),
      ),
    );
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: Text(msg, textAlign: TextAlign.center, style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.white,
        elevation: 1.0));
  }

  orderItem(int index) {
    Order_Model model = orderList[index];
    Color back;

    if ((model.activeStatus) == DELIVERED)
      back = Colors.green;
    else if ((model.activeStatus) == SHIPPED)
      back = Colors.orange;
    else if ((model.activeStatus) == CANCELLED || model.activeStatus == RETURNED)
      back = Colors.red;
    else if ((model.activeStatus) == PROCESSED)
      back = Colors.indigo;
    else
      back = Colors.cyan;

    return Card(
      elevation: 0,
      margin: EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Order No." + model.id!),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration:
                          BoxDecoration(color: back, borderRadius: new BorderRadius.all(const Radius.circular(4.0))),
                      child: Text(
                        capitalize(model.activeStatus!),
                        style: TextStyle(color: white),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 14),
                          Expanded(
                            child: Text(
                              model.name != null && model.name!.length > 0 ? " " + capitalize(model.name!) : " ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          Icon(
                            Icons.call,
                            size: 14,
                            color: fontColor,
                          ),
                          Text(
                            " " + model.mobile!,
                            style: TextStyle(color: fontColor, decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                      onTap: () {
                        //  _launchCaller(index);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.money, size: 14),
                        Text(" Payable: " + CUR_CURRENCY + " " + model.payable!),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(Icons.payment, size: 14),
                        Text(" " + model.payMethod!),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Icon(Icons.date_range, size: 14),
                    Text(" Order on: " + model.orderDate!),
                  ],
                ),
              )
            ])),
        onTap: () async {
          // await Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => OrderDetail(model: orderList[index])),
          // );
          setState(() {});
          // getOrder();
        },
      ),
    );
  }

  _detailHeader(BuildContext context) {
    final storeCounts = context.watch<CardsCountsProvider>().storeCounts;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Card(
              elevation: 0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderList(),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: fontColor,
                      ),
                      Text(ORDER),
                      Text(
                        storeCounts.orderCount.toString(),
                        style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              )),
        ),
        Expanded(
          flex: 1,
          child: Card(
            elevation: 0,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductList(
                        flag: '',
                      ),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.dashboard,
                      color: fontColor,
                    ),
                    Text(PRO_LBL),
                    Text(
                      storeCounts.productCount.toString(),
                      style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Card(
            elevation: 0,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeliveryBoy(
                        isDelBoy: false,
                      ),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.group,
                      color: fontColor,
                    ),
                    Text(CUST_LBL),
                    Text(
                      //custCount ?? "",
                      storeCounts.usersCount.toString(),
                      style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _detailHeader2(BuildContext context) {
    final storeCounts = context.watch<CardsCountsProvider>().storeCounts;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Card(
              elevation: 0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeliveryBoy(
                          isDelBoy: true,
                        ),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.directions_bike,
                        color: fontColor,
                      ),
                      Text(
                        Del_LBL,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        storeCounts.driverCount.toString(),
                        style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              )),
        ),
        Expanded(
          flex: 1,
          child: Card(
            elevation: 0,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductList(
                        flag: "sold",
                      ),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.not_interested,
                      color: fontColor,
                    ),
                    Text(
                      SOLD_LBL,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      storeCounts.unavailableItemsCount.toString(),
                      style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        // Expanded(
        //   flex: 1,
        //   child: Card(
        //     elevation: 0,
        //     child: InkWell(
        //       onTap: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => ProductList(
        //                 flag: "low",
        //               ),
        //             ));
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.all(18.0),
        //         child: Column(
        //           children: [
        //             Icon(
        //               Icons.offline_bolt,
        //               color: fontColor,
        //             ),
        //             Text(
        //               LOW_LBL,
        //               textAlign: TextAlign.center,
        //               maxLines: 1,
        //               overflow: TextOverflow.ellipsis,
        //             ),
        //             Text(
        //               lowStockCount ?? "",
        //               style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Future<Null> getStatics() async {
    try {
      CUR_USERID = (await getPrefrence(ID)) ?? "";
      CUR_USERNAME = (await getPrefrence(USERNAME)) ?? "";

      var parameter = {USER_ID: CUR_USERID};

      Response response =
          await post(getStaticsApi, body: parameter, headers: headers).timeout(Duration(seconds: timeOut));

      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String msg = getdata["message"];

        if (!error) {
          CUR_CURRENCY = getdata["currency_symbol"];

          readOrder = getdata["permissions"]["orders"]["read"] == "on" ? true : false;
          editOrder = getdata["permissions"]["orders"]["update"] == "on" ? true : false;
          deleteOrder = getdata["permissions"]["orders"]["delete"] == "on" ? true : false;

          readProduct = getdata["permissions"]["product"]["read"] == "on" ? true : false;
          editProduct = getdata["permissions"]["product"]["update"] == "on" ? true : false;
          deletProduct = getdata["permissions"]["product"]["delete"] == "on" ? true : false;

          readCust = getdata["permissions"]["customers"]["read"] == "on" ? true : false;
          readDel = getdata["permissions"]["delivery_boy"]["read"] == "on" ? true : false;

          ticketRead = getdata["permissions"]["support_tickets"]["read"] == "on" ? true : false;

          ticketWrite = getdata["permissions"]["support_tickets"]["update"] == "on" ? true : false;

          var count = getdata['counts'][0];
          productCount = count["product_counter"];
          soldOutCount = count['count_products_sold_out_status'];
          lowStockCount = count["count_products_low_status"];
          delBoyCount = count["delivery_boy_counter"];
          custCount = count["user_counter"];
          orderCount = count["order_counter"];

          days = getdata['earnings'][0]["daily_earnings"]['day'];
          dayEarning = getdata['earnings'][0]["daily_earnings"]['total_sale'];
          months = getdata['earnings'][0]["monthly_earnings"]['month_name'];
          monthEarning = getdata['earnings'][0]["monthly_earnings"]['total_sale'];

          weeks = getdata['earnings'][0]["weekly_earnings"]['week'];
          weekEarning = getdata['earnings'][0]["weekly_earnings"]['total_sale'];

          if (chartList != null) chartList!.clear();
          chartList = {0: dayData(), 1: weekData(), 2: monthData()};

          catCountList = getdata['category_wise_product_count']['counter'];
          catList = getdata['category_wise_product_count']['cat_name'];
          colorList.clear();
          for (int i = 0; i < catList.length; i++) colorList.add(generateRandomColor());
        } else {
          setSnackbar(msg);
        }

        setState(() {
          _isLoading = false;
        });
      }
    } on TimeoutException catch (_) {
      setSnackbar(somethingMSg);
    }
    return null;
  }

  // Future<void> getDeliveryBoy() async {
  //   try {
  //     Response response = await post(getDelBoyApi, headers: headers).timeout(Duration(seconds: timeOut));
  //
  //     if (response.statusCode == 200) {
  //       var getdata = json.decode(response.body);
  //       bool error = getdata["error"];
  //       String msg = getdata["message"];
  //       if (!error) {
  //         delBoyList.clear();
  //         var data = getdata["data"];
  //         delBoyList = (data as List).map((data) => new PersonModel.fromJson(data)).toList();
  //       } else {
  //         setSnackbar(msg);
  //       }
  //     }
  //   } on TimeoutException catch (_) {
  //     setSnackbar(somethingMSg);
  //   }
  // }
}
