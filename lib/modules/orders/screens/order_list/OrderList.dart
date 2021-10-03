import 'dart:async';
import 'dart:convert';

import 'package:admin_eshop/Helper/confirmation_dialog.dart';
import 'package:admin_eshop/common/providers/socket_provider.dart';
import 'package:admin_eshop/modules/orders/providers/order_list_provider.dart';
import 'package:admin_eshop/modules/orders/providers/selected_order_tab_provider.dart';
import 'package:admin_eshop/modules/orders/screens/order_list/widgets/order_item.dart';
import 'package:admin_eshop/modules/orders/screens/order_list/widgets/orders_list_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../Helper/AppBtn.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Helper/Session.dart';
import '../../../../Helper/String.dart';
import '../../../../Models/Order_Model.dart';
import '../../../../config/themes/base_theme_colors.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen>
    with TickerProviderStateMixin {
  bool _isNetworkAvail = true;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  String _searchText = "", _lastsearch = "";
  bool? isSearching;
  int scrollOffset = 0;
  ScrollController? scrollController;
  bool scrollLoadmore = true, scrollGettingData = false, scrollNodata = false;
  final TextEditingController _controller = TextEditingController();
  List<Order_Model> orderList = [];
  Icon iconSearch = Icon(
    Icons.search,
    color: primary,
  );
  Widget? appBarTitle;
  List<Order_Model> tempList = [];
  String? activeStatus;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String? start, end;
  String? all,
      received,
      processed,
      shipped,
      delivered,
      cancelled,
      returned,
      awaiting;
  List<String> statusList = [
    ALL,
    PLACED,
    PROCESSED,
    SHIPPED,
    DELIVERED,
    CANCELLED,
    RETURNED,
    awaitingPayment
  ];

  @override
  void initState() {
    context.read<OrderListProvider>().getOrderList();

    appBarTitle = Text(
      ORDER,
      style: TextStyle(color: primary),
    );
    scrollOffset = 0;
    //Future.delayed(Duration.zero, this.getOrder);
    // getOrder();

    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    scrollController = ScrollController(keepScrollOffset: true);
    scrollController!.addListener(_transactionscrollListener);

    buttonSqueezeanimation = new Tween(
      begin: deviceWidth * 0.7,
      end: 50.0,
    ).animate(new CurvedAnimation(
      parent: buttonController!,
      curve: new Interval(
        0.0,
        0.150,
      ),
    ));

    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        if (mounted)
          setState(() {
            _searchText = "";
          });
      } else {
        if (mounted)
          setState(() {
            _searchText = _controller.text;
          });
      }

      if (_lastsearch != _searchText &&
          (_searchText == '' || (_searchText.length > 2))) {
        _lastsearch = _searchText;
        scrollLoadmore = true;
        scrollOffset = 0;
        //getOrder();
      }
    });

    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<SocketProvider>(context, listen: false).connect();
    });
  }

  _transactionscrollListener() {
    if (scrollController!.offset >=
            scrollController!.position.maxScrollExtent &&
        !scrollController!.position.outOfRange) {
      if (mounted)
        setState(() {
          scrollLoadmore = true;
          getOrder();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedOrderTabProvider>(
      builder: (_, __, ___) => Consumer<OrderListProvider>(
        builder: (context, ordersListP, __) => Consumer<SocketProvider>(
          builder: (_, socketP, ___) {
            return Scaffold(
              backgroundColor: lightWhite,
              appBar: getAppbar(),
              body: _isNetworkAvail
                  ? (ordersListP.loading || socketP.loading
                      ? shimmer()
                      : _showContent(context))
                  : noInternet(context),
            );
          },
        ),
      ),
    );
  }

  void _handleSearchStart() {
    if (!mounted) return;
    setState(() {
      isSearching = true;
    });
  }

  Future<void> _startDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2020, 1),
        lastDate: DateTime.now()))!;
    if (picked != null)
      setState(() {
        startDate = picked;
        start = DateFormat('dd-MM-yyyy').format(startDate);

        if (start != null && end != null) {
          scrollLoadmore = true;
          scrollOffset = 0;
          getOrder();
        }
      });
  }

  Future<void> _endDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: startDate,
        lastDate: DateTime.now()))!;
    if (picked != null)
      setState(() {
        endDate = picked;
        end = DateFormat('dd-MM-yyyy').format(endDate);
        if (start != null && end != null) {
          scrollLoadmore = true;
          scrollOffset = 0;
          getOrder();
        }
      });
  }

  void _handleSearchEnd() {
    if (!mounted) return;
    setState(() {
      iconSearch = Icon(
        Icons.search,
        color: primary,
      );
      appBarTitle = Text(
        ORDER,
        style: TextStyle(color: primary),
      );
      isSearching = false;
      _controller.clear();
    });
  }

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: NO_INTERNET,
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: () async {
              _playAnimation();

              Future.delayed(Duration(seconds: 2)).then((_) async {
                _isNetworkAvail = await isNetworkAvailable();
                if (_isNetworkAvail) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                } else {
                  await buttonController!.reverse();
                  if (mounted) setState(() {});
                }
              });
            },
          )
        ]),
      ),
    );
  }

  AppBar getAppbar() {
    return AppBar(
      title: appBarTitle,
      backgroundColor: white,
      leading: Builder(builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.all(10),
          decoration: shadow(),
          child: Card(
            elevation: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => Navigator.of(context).pop(),
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_left,
                  color: primary,
                ),
              ),
            ),
          ),
        );
      }),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => ChangeNotifierProvider<OrderListProvider>.value(
                value: context.read<OrderListProvider>(),
                child: OrdersListScreenDialog(),
              ),
            );
          },
          icon: Icon(
            Icons.settings,
            color: AppColors.black,
          ),
        ),
        // InkWell(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: iconSearch,
        //   ),
        //   onTap: () {
        //     if (!mounted) return;
        //     setState(() {
        //       if (iconSearch.icon == Icons.search) {
        //         iconSearch = Icon(
        //           Icons.close,
        //           color: primary,
        //         );
        //         appBarTitle = TextField(
        //           controller: _controller,
        //           autofocus: true,
        //           style: TextStyle(
        //             color: primary,
        //           ),
        //           decoration: InputDecoration(
        //             prefixIcon: Icon(Icons.search, color: primary),
        //             hintText: 'Search...',
        //             hintStyle: TextStyle(color: primary),
        //           ),
        //           //  onChanged: searchOperation,
        //         );
        //         _handleSearchStart();
        //       } else {
        //         _handleSearchEnd();
        //       }
        //     });
        //   },
        // ),
        // InkWell(
        //     onTap: filterDialog,
        //     child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Icon(
        //           Icons.filter_alt_outlined,
        //           color: primary,
        //         )))
      ],
    );
  }

  _showContent(BuildContext context) {
    return scrollNodata
        ? getNoItem()
        : NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              return true;
            },
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: <Widget>[
                        _detailHeader(context),
                        _detailHeader2(context),
                        //_filterRow(),
                        if (context
                                .watch<OrderListProvider>()
                                .orderList
                                .length !=
                            0)
                          ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsetsDirectional.only(
                                  bottom: 5, start: 10, end: 10),
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: context
                                  .watch<OrderListProvider>()
                                  .orderList
                                  .length,
                              itemBuilder: (context, index) {
                                final order = context
                                    .watch<OrderListProvider>()
                                    .orderList[index];
                                return OrderListScreenOrder(order: order);
                                // Order_Model? item;
                                // try {
                                //   item = (orderList.isEmpty ? null : orderList[index])!;
                                //   if (scrollLoadmore &&
                                //       index == (orderList.length - 1) &&
                                //       scrollController!.position.pixels <= 0) {
                                //     getOrder();
                                //   }
                                // } on Exception catch (_) {}

                                //return this.orderItem(index);
                              }),
                        if (context
                                .watch<OrderListProvider>()
                                .orderList
                                .length ==
                            0)
                          Center(
                            child: Container(
                              height: 20.0.h,
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!.orders_empty,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                scrollGettingData
                    ? Padding(
                        padding: EdgeInsetsDirectional.only(top: 5, bottom: 5),
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
              ],
            ),
          );
  }

  _detailHeader(BuildContext context) {
    final selectedTab = context.watch<SelectedOrderTabProvider>().selectedTab;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Opacity(
              opacity: selectedTab == 0 ? 1.0 : 0.6,
              child: Card(
                elevation: 0,
                child: InkWell(
                  onTap: () {
                    context.read<OrderListProvider>().getOrderList(0);
                    context.read<SelectedOrderTabProvider>().selectedTab = 0;
                    // setState(() {
                    //   activeStatus = statusList[1];
                    //   scrollLoadmore = true;
                    //   scrollOffset = 0;
                    // });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.archive,
                          color: fontColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.pending_orders,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                        Text(
                          received ?? '',
                          style: TextStyle(
                              color: fontColor, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Opacity(
              opacity: selectedTab == 1 ? 1.0 : 0.6,
              child: Card(
                elevation: 0,
                child: InkWell(
                  onTap: () {
                    context.read<OrderListProvider>().getOrderList(1);
                    context.read<SelectedOrderTabProvider>().selectedTab = 1;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.work,
                          color: fontColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.preparing_orders,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                        Text(
                          processed ?? "",
                          style: TextStyle(
                              color: fontColor, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Opacity(
              opacity: selectedTab == 2 ? 1.0 : 0.6,
              child: Card(
                elevation: 0,
                child: InkWell(
                  onTap: () {
                    context.read<OrderListProvider>().getOrderList(2);
                    context.read<SelectedOrderTabProvider>().selectedTab = 2;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.history,
                          color: fontColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.prepared_orders,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                        Text(
                          awaiting ?? '',
                          style: TextStyle(
                              color: fontColor, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _detailHeader2(BuildContext context) {
    final selectedTab = context.watch<SelectedOrderTabProvider>().selectedTab;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Opacity(
            opacity: selectedTab == 3 ? 1.0 : 0.6,
            child: Card(
              elevation: 0,
              child: InkWell(
                onTap: () {
                  context.read<OrderListProvider>().getOrderList(3);
                  context.read<SelectedOrderTabProvider>().selectedTab = 3;
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.airport_shuttle,
                        color: fontColor,
                      ),
                      Text(
                        AppLocalizations.of(context)!.delivering_orders,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                      ),
                      Text(
                        shipped ?? "",
                        style: TextStyle(
                            color: fontColor, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Opacity(
            opacity: selectedTab == 4 ? 1.0 : 0.6,
            child: Card(
                elevation: 0,
                child: InkWell(
                  onTap: () {
                    context.read<OrderListProvider>().getOrderList(4);
                    context.read<SelectedOrderTabProvider>().selectedTab = 4;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.assignment_turned_in,
                          color: fontColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.delivered_orders,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                        Text(
                          delivered ?? "",
                          style: TextStyle(
                              color: fontColor, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                )),
          ),
        ),

        Expanded(
          flex: 1,
          child: Opacity(
            opacity: selectedTab == 5 ? 1.0 : 0.6,
            child: Card(
              elevation: 0,
              child: InkWell(
                onTap: () {
                  context.read<OrderListProvider>().getOrderList(5);
                  context.read<SelectedOrderTabProvider>().selectedTab = 5;
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cancel,
                        color: fontColor,
                      ),
                      Text(
                        AppLocalizations.of(context)!.cancelled_orders,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                      Text(
                        cancelled ?? "",
                        style: TextStyle(
                            color: fontColor, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
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
        //         setState(() {
        //           activeStatus = statusList[6];
        //           scrollLoadmore = true;
        //           scrollOffset = 0;
        //         });
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.all(0.0),
        //         child: Column(
        //           children: [
        //             Icon(
        //               Icons.upload,
        //               color: fontColor,
        //             ),
        //             Text(
        //               RETURNED_LBL,
        //               style: Theme.of(context).textTheme.caption!.copyWith(
        //                     fontWeight: FontWeight.bold,
        //                   ),
        //               maxLines: 1,
        //             ),
        //             Text(
        //               returned ?? "",
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

  orderItem(int index) {
    Order_Model model = orderList[index];
    Color back;

    if ((model.activeStatus) == DELIVERED)
      back = Colors.green;
    else if ((model.activeStatus) == SHIPPED)
      back = Colors.orange;
    else if ((model.activeStatus) == CANCELLED ||
        model.activeStatus == RETURNED)
      back = Colors.red;
    else if ((model.activeStatus) == PROCESSED)
      back = Colors.indigo;
    else if ((model.activeStatus) == PROCESSED)
      back = Colors.indigo;
    else if (model.activeStatus == "awaiting")
      back = Colors.black;
    else
      back = Colors.cyan;

    return Card(
      elevation: 0,
      margin: EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Order No." + model.id!),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          color: back,
                          borderRadius:
                              new BorderRadius.all(const Radius.circular(4.0))),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 14),
                          Expanded(
                            child: Text(
                              model.name != null && model.name!.length > 0
                                  ? " " + capitalize(model.name!)
                                  : " ",
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
                            style: TextStyle(
                                color: fontColor,
                                decoration: TextDecoration.underline),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.money, size: 14),
                        Text(
                            " Payable: " + CUR_CURRENCY + " " + model.payable!),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Icon(Icons.date_range, size: 14),
                    Text(" Order on: " + model.orderDate!),
                  ],
                ),
              )
            ])),
        onTap: () async {
          ///
          // await Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => OrderDetail(model: orderList[index])),
          // );
          setState(() {
            /* _isLoading = true;
             total=0;
             offset=0;
orderList.clear();*/
          });
          // getOrder();
        },
      ),
    );
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  Future<Null> getOrder() async {
    if (readOrder) {
      _isNetworkAvail = await isNetworkAvailable();
      if (_isNetworkAvail) {
        if (scrollLoadmore) {
          if (mounted)
            setState(() {
              scrollLoadmore = false;
              scrollGettingData = true;
              if (scrollOffset == 0) {
                orderList = [];
              }
            });

          try {
            CUR_USERID = (await getPrefrence(ID))!;
            CUR_USERNAME = (await getPrefrence(USERNAME))!;

            var parameter = {
              LIMIT: perPage.toString(),
              OFFSET: scrollOffset.toString(),
              SEARCH: _searchText.trim(),
            };
            if (start != null)
              parameter[START_DATE] = "${startDate.toLocal()}".split(' ')[0];
            if (end != null)
              parameter[END_DATE] = "${endDate.toLocal()}".split(' ')[0];
            if (activeStatus != null) {
              if (activeStatus == awaitingPayment) activeStatus = "awaiting";
              parameter[ACTIVE_STATUS] = activeStatus!;
            }

            Response response =
                await post(getOrdersApi, body: parameter, headers: headers)
                    .timeout(Duration(seconds: timeOut));

            var getdata = json.decode(response.body);
            bool error = getdata["error"];
            String msg = getdata["message"];
            // total = int.parse(getdata["total"]);
            scrollGettingData = false;
            if (scrollOffset == 0) scrollNodata = error;

            if (!error) {
              all = getdata["total"];
              received = getdata["received"];
              processed = getdata["processed"];
              shipped = getdata["shipped"];
              delivered = getdata["delivered"];
              cancelled = getdata["cancelled"];
              returned = getdata["returned"];
              awaiting = getdata["awaiting"];
              tempList.clear();
              var data = getdata["data"];
              if (data.length != 0) {
                tempList = (data as List)
                    .map((data) => new Order_Model.fromJson(data))
                    .toList();

                orderList.addAll(tempList);
                scrollLoadmore = true;
                scrollOffset = scrollOffset + perPage;
              } else {
                scrollLoadmore = false;
              }
            } else {
              scrollLoadmore = false;
            }
            if (mounted)
              setState(() {
                scrollLoadmore = false;
              });
          } on TimeoutException catch (_) {
            setSnackbar(somethingMSg);
            setState(() {
              scrollLoadmore = false;
            });
          }
        }
      } else {
        if (mounted)
          setState(() {
            _isNetworkAvail = false;
            scrollLoadmore = false;
          });
      }

      return null;
    } else {
      setSnackbar('You have not authorized permission for read order!!');
    }
  }

  void filterDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ButtonBarTheme(
            data: ButtonBarThemeData(
              alignment: MainAxisAlignment.center,
            ),
            child: new AlertDialog(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                contentPadding: const EdgeInsets.all(0.0),
                content: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                        padding:
                            EdgeInsetsDirectional.only(top: 19.0, bottom: 16.0),
                        child: Text(
                          'Filter By',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: fontColor),
                        )),
                    Divider(color: lightBlack),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: getStatusList()),
                      ),
                    ),
                  ]),
                )),
          );
        });
  }

  List<Widget> getStatusList() {
    return statusList
        .asMap()
        .map(
          (index, element) => MapEntry(
            index,
            Column(
              children: [
                Container(
                  width: double.maxFinite,
                  child: TextButton(
                      child: Text(capitalize(statusList[index]),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: lightBlack)),
                      onPressed: () {
                        setState(() {
                          activeStatus = index == 0 ? null : statusList[index];
                          scrollLoadmore = true;
                          scrollOffset = 0;
                        });

                        getOrder();

                        Navigator.pop(context, 'option $index');
                      }),
                ),
                Divider(
                  color: lightBlack,
                  height: 1,
                ),
              ],
            ),
          ),
        )
        .values
        .toList();
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: black),
      ),
      backgroundColor: white,
      elevation: 1.0,
    ));
  }

  _filterRow() {
    return Row(
      children: [
        Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * .375,
            height: 45,
            child: ElevatedButton(
              onPressed: () => _startDate(context),
              child: Text(
                start ?? 'Start Date',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: fontColor),
                primary: fontColor,
                onPrimary: Colors.white,
                onSurface: fontColor,
              ),
            )),
        Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: MediaQuery.of(context).size.width * .375,
            height: 45,
            child: ElevatedButton(
              onPressed: () => _endDate(context),
              child: Text(end ?? 'End Date'),
              style: ElevatedButton.styleFrom(
                primary: fontColor,
                onPrimary: Colors.white,
                onSurface: Colors.grey,
              ),
            )),
        Expanded(
          child: Container(
              margin: EdgeInsets.all(10),
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    start = null;
                    end = null;
                    startDate = DateTime.now();
                    endDate = DateTime.now();
                    scrollLoadmore = true;
                    scrollOffset = 0;
                  });
                  getOrder();
                },
                child: Center(
                  child: Icon(Icons.close),
                ),
                style: ElevatedButton.styleFrom(
                  primary: fontColor,
                  onPrimary: Colors.white,
                  onSurface: Colors.grey,
                  padding: EdgeInsets.all(0),
                ),
              )),
        ),
      ],
    );
  }
}
