import 'dart:async';
import 'dart:io';

import 'package:admin_eshop/Helper/AppBtn.dart';
import 'package:admin_eshop/Helper/Constant.dart';
import 'package:admin_eshop/Helper/Session.dart';
import 'package:admin_eshop/Helper/String.dart';
import 'package:admin_eshop/Models/Person_Model.dart';
import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:admin_eshop/modules/orders/enums/order_status.dart';
import 'package:admin_eshop/modules/orders/models/order.dart';
import 'package:admin_eshop/modules/orders/providers/driver_list_provider.dart';
import 'package:admin_eshop/modules/orders/screens/order_detail/widgets/order_detail_items.dart';
import 'package:admin_eshop/modules/orders/screens/order_detail/widgets/order_detail_screen_driver_dropdown.dart';
import 'package:admin_eshop/modules/orders/screens/order_detail/widgets/order_detail_status_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order order;
  final Function? updateHome;

  const OrderDetailsScreen({
    Key? key,
    required this.order,
    this.updateHome,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateOrder();
  }
}

class StateOrder extends State<OrderDetailsScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController controller = new ScrollController();
  late Animation? buttonSqueezeanimation;
  late AnimationController? buttonController;
  bool _isNetworkAvail = true;
  //List<String> statusList = [PLACED, PROCESSED, SHIPPED, DELIVERED, CANCELLED, RETURNED, WAITING];
  late bool _isCancleable, _isReturnable, _isLoading = true;
  bool _isProgress = false;
  late String? curStatus;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late TextEditingController? otpC;
  final List<DropdownMenuItem> items = [];
  List<PersonModel> searchList = [];
  late String? selectedValue;
  late int? selectedDelBoy;
  final TextEditingController _controller = TextEditingController();
  late StateSetter? delBoyState;

  bool fabIsVisible = true;

  @override
  void initState() {
    super.initState();

    // for (int i = 0; i < widget.model.itemList.length; i++)
    //   widget.model.itemList[i].curSelected = widget.model.itemList[i].status;

    //searchList.addAll(delBoyList); // use api to get list in this screen

    // if (widget.model.deliveryBoyId != null)
    //   selectedDelBoy = delBoyList.indexWhere((f) => f.id == widget.model.deliveryBoyId);

    //if (selectedDelBoy == -1) selectedDelBoy = null;

    // if (widget.model.payMethod == "Bank Transfer") {
    //   statusList.removeWhere((element) => element == PLACED);
    // }

    controller = ScrollController();
    controller.addListener(() {
      setState(() {
        fabIsVisible =
            controller.position.userScrollDirection == ScrollDirection.forward;
      });
    });
    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    buttonSqueezeanimation = new Tween(
      begin: 70.0.w,
      end: 50.0,
    ).animate(new CurvedAnimation(
      parent: buttonController!,
      curve: new Interval(
        0.0,
        0.150,
      ),
    ));
    //curStatus = widget.model.activeStatus;
    _controller.addListener(() {
      searchOperation(_controller.text);
    });
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                } else {
                  await buttonController!.reverse();
                  setState(() {});
                }
              });
            },
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String pDate, prDate, sDate, dDate, cDate, rDate;

    // if (model.listStatus.contains(PLACED)) {
    //   pDate = model.listDate[model.listStatus.indexOf(PLACED)];
    //
    //   if (pDate != null) {
    //     List d = pDate.split(" ");
    //     pDate = d[0] + "\n" + d[1];
    //   }
    // }
    // if (model.listStatus.contains(PROCESSED)) {
    //   prDate = model.listDate[model.listStatus.indexOf(PROCESSED)];
    //   if (prDate != null) {
    //     List d = prDate.split(" ");
    //     prDate = d[0] + "\n" + d[1];
    //   }
    // }
    // if (model.listStatus.contains(SHIPPED)) {
    //   sDate = model.listDate[model.listStatus.indexOf(SHIPPED)];
    //   if (sDate != null) {
    //     List d = sDate.split(" ");
    //     sDate = d[0] + "\n" + d[1];
    //   }
    // }
    // if (model.listStatus.contains(DELIVERED)) {
    //   dDate = model.listDate[model.listStatus.indexOf(DELIVERED)];
    //   if (dDate != null) {
    //     List d = dDate.split(" ");
    //     dDate = d[0] + "\n" + d[1];
    //   }
    // }
    // if (model.listStatus.contains(CANCELLED)) {
    //   cDate = model.listDate[model.listStatus.indexOf(CANCELLED)];
    //   if (cDate != null) {
    //     List d = cDate.split(" ");
    //     cDate = d[0] + "\n" + d[1];
    //   }
    // }
    // if (model.listStatus.contains(RETURNED)) {
    //   rDate = model.listDate[model.listStatus.indexOf(RETURNED)];
    //   if (rDate != null) {
    //     List d = rDate.split(" ");
    //     rDate = d[0] + "\n" + d[1];
    //   }
    // }

    // _isCancleable = model.isCancleable == "1" ? true : false;
    // _isReturnable = model.isReturnable == "1" ? true : false;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DriverListProvider()),
      ],
      child: Consumer<DriverListProvider>(
        builder: (_, driverListP, __) => Scaffold(
          key: _scaffoldKey,
          backgroundColor: lightWhite,
          appBar: getAppBar(ORDER_DETAIL, context),
          // floatingActionButton: AnimatedOpacity(
          //   child: Padding(
          //     padding: const EdgeInsets.only(bottom: 108.0),
          //     child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          //       FloatingActionButton(
          //         backgroundColor: lightWhite,
          //         child: Image.asset(
          //           'assets/images/whatsapp.png',
          //           width: 25,
          //           height: 25,
          //           color: fontColor,
          //         ),
          //         onPressed: () async {
          //           String text =
          //               '''Hello ${widget.order.username},\n
          //               Your order with id : ${widget.order.displayId} is ${describeEnum(widget.order.status)}
          //               . If you have further query feel free to contact us.Thank you.''';
          //           await launch("https://wa.me/${widget.model.countryCode + "" + widget.model.mobile}?text=$text");
          //         },
          //         heroTag: null,
          //       ),
          //       SizedBox(
          //         height: 10
          //       ),
          //       FloatingActionButton(
          //         backgroundColor: lightWhite,
          //         child: Icon(
          //           Icons.message,
          //           color: fontColor,
          //         ),
          //         onPressed: () async {
          //           String text =
          //               'Hello ${widget.model.name},\nYour order with id : ${widget.model.id} is ${widget.model.activeStatus}. If you have further query feel free to contact us.Thank you.';
          //
          //           var uri = 'sms:${widget.model.mobile}?body=$text';
          //           await launch(uri);
          //         },
          //         // onPressed: () => _someFunc(),
          //         heroTag: null,
          //       )
          //     ]),
          //   ),
          //   duration: Duration(milliseconds: 100),
          //   opacity: fabIsVisible ? 1 : 0,
          // ),
          body: _isNetworkAvail
              ? Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            controller: controller,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Card(
                                      elevation: 0,
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ORDER_ID_LBL +
                                                    widget.order.displayId,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2!
                                                    .copyWith(
                                                        color: lightBlack2),
                                              ),
                                              Text(
                                                ORDER_DATE +
                                                    " - " +
                                                    DateFormat(
                                                            'dd-MM-yyyy hh:mm a')
                                                        .format(widget
                                                            .order.orderDate),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2!
                                                    .copyWith(
                                                        color: lightBlack2),
                                              ),
                                              Text(
                                                PAYMENT_MTHD +
                                                    " - " +
                                                    widget.order.paymentType,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2!
                                                    .copyWith(
                                                        color: lightBlack2),
                                              ),
                                              SizedBox(height: 1.0.h),
                                              Text(
                                                "Order Status - " +
                                                    describeEnum(
                                                        widget.order.status),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2!
                                                    .copyWith(
                                                        color: lightBlack2),
                                              ),
                                            ],
                                          ))),
                                  // model.delDate != null && model.delDate.isNotEmpty
                                  //     ? Card(
                                  //         elevation: 0,
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.all(12.0),
                                  //           child: Text(
                                  //             PREFER_DATE_TIME + ": " + model.delDate + " - " + model.delTime,
                                  //             style: Theme.of(context).textTheme.subtitle2!.copyWith(color: lightBlack2),
                                  //           ),
                                  //         ))
                                  //     : Container(),
                                  OrderDetailScreenOrderItems(
                                      orderItems: widget.order.items),
                                  // ListView.builder(
                                  //   shrinkWrap: true,
                                  //   itemCount: widget.order.items.length,
                                  //   physics: NeverScrollableScrollPhysics(),
                                  //   itemBuilder: (context, i) {
                                  //     OrderItem orderItem = widget.order.items[i];
                                  //     return productItem(orderItem, model, i);
                                  //   },
                                  // ),
                                  //widget.order.paymentType == "Bank Transfer" ? bankProof(widget.order) : Container(),
                                  shippingDetails(),
                                  priceDetails(),
                                  SizedBox(height: 1.0.h),
                                  if (widget.order.status ==
                                          OrderStatus.preparing ||
                                      widget.order.status ==
                                          OrderStatus.prepared)
                                    OrderDetailScreenDriverDropdown(
                                        widget.order),
                                  SizedBox(height: 2.0.h),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.5.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (widget.order.status.index < 2)
                                          OrderDetailScreenStatusButton(
                                              currStatus: widget.order.status,
                                              orderId: widget.order.id),
                                        Spacer(),
                                        if (widget.order.status.index != 4 &&
                                            widget.order.status.index != 5)
                                          OrderDetailScreenStatusButton(
                                              currStatus: widget.order.status,
                                              cancelled: true,
                                              orderId: widget.order.id),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4.0.h),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              // Expanded(
                              //   flex: 1,
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(right: 8.0),
                              //     child: DropdownButtonFormField(
                              //       isExpanded: true,
                              //       dropdownColor: lightWhite,
                              //       isDense: true,
                              //       iconEnabledColor: fontColor,
                              //       //iconSize: 40,
                              //       hint: new Text(
                              //         "Update Status",
                              //         style: Theme.of(this.context)
                              //             .textTheme
                              //             .subtitle2!
                              //             .copyWith(color: fontColor, fontWeight: FontWeight.bold),
                              //       ),
                              //       decoration: InputDecoration(
                              //         filled: true,
                              //         isDense: true,
                              //         fillColor: lightWhite,
                              //         contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              //         enabledBorder: OutlineInputBorder(
                              //           borderSide: BorderSide(color: fontColor),
                              //         ),
                              //       ),
                              //
                              //       value: describeEnum(widget.order.status),
                              //       onChanged: (newValue) {
                              //         setState(() {
                              //           curStatus = newValue! as String?;
                              //         });
                              //       },
                              //       items: statusList.map((String st) {
                              //         return DropdownMenuItem<String>(
                              //           value: st,
                              //           child: Text(
                              //             capitalize(st),
                              //             style: Theme.of(this.context)
                              //                 .textTheme
                              //                 .subtitle2!
                              //                 .copyWith(color: fontColor, fontWeight: FontWeight.bold),
                              //           ),
                              //         );
                              //       }).toList(),
                              //     ),
                              //   ),
                              // ),
                              // Expanded(
                              //     flex: 1,
                              //     child: InkWell(
                              //       child: Container(
                              //           decoration: BoxDecoration(
                              //               color: lightWhite,
                              //               border: Border.all(
                              //                 color: fontColor,
                              //               ),
                              //               borderRadius: BorderRadius.all(Radius.circular(5))),
                              //           padding: EdgeInsets.all(10),
                              //           child: Row(
                              //             children: [
                              //               Expanded(
                              //                   child: Text(
                              //                 widget.order.driver ?? 'Driver',
                              //                 maxLines: 1,
                              //                 overflow: TextOverflow.ellipsis,
                              //                 style: Theme.of(this.context)
                              //                     .textTheme
                              //                     .subtitle2!
                              //                     .copyWith(color: fontColor, fontWeight: FontWeight.bold),
                              //               )),
                              //               Icon(
                              //                 Icons.arrow_drop_down,
                              //                 color: fontColor,
                              //               )
                              //             ],
                              //           )),
                              //       onTap: () {
                              //         //delboyDialog();
                              //       },
                              //     ))
                            ],
                          ),
                        ),
                        // Container(
                        //     margin: EdgeInsets.all(10),
                        //     width: double.maxFinite,
                        //     height: 45,
                        //     child: ElevatedButton(
                        //         style: ElevatedButton.styleFrom(
                        //           primary: fontColor,
                        //           onPrimary: Colors.white,
                        //           onSurface: Colors.grey,
                        //         ),
                        //         onPressed: () async {
                        //           _isNetworkAvail = await isNetworkAvailable();
                        //           if (_isNetworkAvail) {
                        //             if (model.otp != null &&
                        //                 model.otp.isNotEmpty &&
                        //                 model.otp != "0" &&
                        //                 curStatus == DELIVERED)
                        //               otpDialog(curStatus!, model.otp, model.id, false, 0);
                        //             else
                        //               updateOrder(curStatus!, updateOrderApi, model.id, false, 0);
                        //           } else {
                        //             await buttonController!.reverse();
                        //             setState(() {});
                        //           }
                        //         },
                        //         child: Text(
                        //           UPDATE_ORDER,
                        //           style: TextStyle(fontWeight: FontWeight.bold),
                        //         )))
                      ],
                    ),
                    showCircularProgress(_isProgress, primary),
                  ],
                )
              : noInternet(context),
        ),
      ),
    );
  }

  Future<void> searchOperation(String searchText) async {
    searchList.clear();
    // for (int i = 0; i < delBoyList.length; i++) {
    //   PersonModel map = delBoyList[i];
    //
    //   if (map.name.toLowerCase().contains(searchText)) {
    //     searchList.add(map);
    //   }
    // }
    //
    // if (mounted) delBoyState!(() {});
  }

  delboyDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStater) {
            delBoyState = setStater;
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                      child: Text(
                        'Select Delivery Boy',
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: fontColor),
                      )),
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
                      prefixIcon: Icon(Icons.search, color: primary, size: 17),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: primary.withOpacity(0.5)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: white),
                      ),
                    ),
                    // onChanged: (query) => updateSearchQuery(query),
                  ),
                  Divider(color: lightBlack),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: getLngList()),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  List<Widget> getLngList() {
    return searchList
        .asMap()
        .map(
          (index, element) => MapEntry(
              index,
              InkWell(
                  onTap: () {
                    if (mounted)
                      setState(() {
                        selectedDelBoy = index;

                        Navigator.of(context).pop();
                      });
                  },
                  child: Container(
                    width: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        searchList[index].name,
                      ),
                    ),
                  ))),
        )
        .values
        .toList();
  }

  otpDialog(
      String curSelected, String otp, String id, bool item, int index) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                            child: Text(
                              OTP_LBL,
                              style: Theme.of(this.context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: fontColor),
                            )),
                        Divider(color: lightBlack),
                        Form(
                            key: _formkey,
                            child: new Column(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      validator: (String? value) {
                                        if (value!.length == 0)
                                          return FIELD_REQUIRED;
                                        else if (value.trim() != otp)
                                          return OTPERROR;
                                        else
                                          return null;
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        hintText: OTP_ENTER,
                                        hintStyle: Theme.of(this.context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                                color: lightBlack,
                                                fontWeight: FontWeight.normal),
                                      ),
                                      controller: otpC,
                                    )),
                              ],
                            ))
                      ])),
              actions: <Widget>[
                new FlatButton(
                    child: Text(
                      CANCEL,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: lightBlack, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new FlatButton(
                    child: Text(
                      SEND_LBL,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: fontColor, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      final form = _formkey.currentState;
                      if (form!.validate()) {
                        form.save();
                        setState(() {
                          Navigator.pop(context);
                        });
                        //updateOrder(curSelected, updateOrderApi, id, item, index);
                      }
                    })
              ],
            );
          });
        });
  }

  _launchMap(lat, lng) async {
    var url = '';

    if (Platform.isAndroid) {
      url =
          "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving&dir_action=navigate";
    } else {
      url =
          "http://maps.apple.com/?saddr=&daddr=$lat,$lng&directionsmode=driving&dir_action=navigate";
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  priceDetails() {
    return Card(
        elevation: 0,
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(PRICE_DETAIL,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: fontColor, fontWeight: FontWeight.bold))),
              Divider(
                color: lightBlack,
              ),
              if (widget.order.subTotal != null)
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(PRICE_LBL + " " + ":",
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: lightBlack2)),
                      Text(
                          CUR_CURRENCY +
                              " " +
                              widget.order.subTotal!.toStringAsFixed(2),
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: lightBlack2))
                    ],
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DELIVERY_CHARGE + " " + ":",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: lightBlack2)),
                    Text(
                        "+ " +
                            CUR_CURRENCY +
                            " " +
                            widget.order.deliveryFee.toStringAsFixed(2),
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: lightBlack2))
                  ],
                ),
              ),
              SizedBox(height: 1.0.h),
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text(TAXPER + " (" + widget.model.taxPer + ")" + " " + ":",
                    //     style: Theme.of(context).textTheme.button!.copyWith(color: lightBlack2)),
                    Text("Tax",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: lightBlack2)),
                    Text(
                        "+ " +
                            CUR_CURRENCY +
                            " " +
                            widget.order.tax.toStringAsFixed(2),
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: lightBlack2))
                  ],
                ),
              ),
              SizedBox(height: 1.0.h),
              if (widget.order.promocode != null)
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(PROMO_CODE_DIS_LBL + " " + ":",
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: lightBlack2)),
                      Text(
                          "- " +
                              CUR_CURRENCY +
                              " " +
                              widget.order.promocodeValue!.toStringAsFixed(2),
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: lightBlack2))
                    ],
                  ),
                ),
              SizedBox(height: 1.0.h),
              // Padding(
              //   padding: EdgeInsets.only(left: 15.0, right: 15.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(WALLET_BAL + " " + ":",
              //           style: Theme.of(context).textTheme.button!.copyWith(color: lightBlack2)),
              //       Text("- " + CUR_CURRENCY + " " + widget.model.walBal,
              //           style: Theme.of(context).textTheme.button!.copyWith(color: lightBlack2))
              //     ],
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(PAYABLE + " " + ":",
                        style: Theme.of(context).textTheme.button!.copyWith(
                            color: lightBlack, fontWeight: FontWeight.bold)),
                    Text(
                        CUR_CURRENCY +
                            " " +
                            widget.order.totalPrice.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.button!.copyWith(
                            color: lightBlack, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ])));
  }

  shippingDetails() {
    return Card(
        elevation: 0,
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    children: [
                      Text(SHIPPING_DETAIL,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                  color: fontColor,
                                  fontWeight: FontWeight.bold)),
                      Spacer(),
                      Container(
                        height: 30,
                        child: IconButton(
                            icon: Icon(
                              Icons.location_on,
                              color: fontColor,
                            ),
                            onPressed: () {
                              _launchMap(widget.order.deliveryAddress.lat,
                                  widget.order.deliveryAddress.long);
                            }),
                      )
                    ],
                  )),
              Divider(color: lightBlack),
              Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(widget.order.username)),
              SizedBox(height: 1.0.h),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3),
                  child: Text(widget.order.deliveryAddress.streetAddress ?? "",
                      style: TextStyle(color: lightBlack2))),
              if (widget.order.userPhoneNumber != null)
                InkWell(
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                      child: Row(
                        children: [
                          Icon(Icons.call, size: 15, color: fontColor),
                          Text(" " + widget.order.userPhoneNumber.toString(),
                              style: TextStyle(
                                  color: fontColor,
                                  decoration: TextDecoration.underline)),
                        ],
                      )),
                  onTap: _launchCaller,
                ),
            ])));
  }

  // productItem(OrderItem orderItem, Order_Model model, int i) {
  //   List? att, val;
  //   if (orderItem.attr_name!.isNotEmpty) {
  //     att = orderItem.attr_name!.split(',');
  //     val = orderItem.varient_values!.split(',');
  //   }
  //
  //   return Card(
  //       elevation: 0,
  //       child: Padding(
  //           padding: EdgeInsets.all(10.0),
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   ClipRRect(
  //                       borderRadius: BorderRadius.circular(10.0),
  //                       child: FadeInImage(
  //                         fadeInDuration: Duration(milliseconds: 150),
  //                         image: NetworkImage(orderItem.image!),
  //                         height: 90.0,
  //                         width: 90.0,
  //                         placeholder: placeHolder(90),
  //                       )),
  //                   Expanded(
  //                     child: Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             orderItem.name ?? '',
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .subtitle1!
  //                                 .copyWith(color: lightBlack, fontWeight: FontWeight.normal),
  //                             maxLines: 2,
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                           orderItem.attr_name!.isNotEmpty
  //                               ? ListView.builder(
  //                                   physics: NeverScrollableScrollPhysics(),
  //                                   shrinkWrap: true,
  //                                   itemCount: att!.length,
  //                                   itemBuilder: (context, index) {
  //                                     return Row(children: [
  //                                       Flexible(
  //                                         child: Text(
  //                                           att![index].trim() + ":",
  //                                           overflow: TextOverflow.ellipsis,
  //                                           style: Theme.of(context).textTheme.subtitle2!.copyWith(color: lightBlack2),
  //                                         ),
  //                                       ),
  //                                       Padding(
  //                                         padding: EdgeInsets.only(left: 5.0),
  //                                         child: Text(
  //                                           val![index],
  //                                           style: Theme.of(context).textTheme.subtitle2!.copyWith(color: lightBlack),
  //                                         ),
  //                                       )
  //                                     ]);
  //                                   })
  //                               : Container(),
  //                           Row(children: [
  //                             Text(
  //                               QUANTITY_LBL + ":",
  //                               style: Theme.of(context).textTheme.subtitle2!.copyWith(color: lightBlack2),
  //                             ),
  //                             Padding(
  //                               padding: EdgeInsets.only(left: 5.0),
  //                               child: Text(
  //                                 orderItem.qty!,
  //                                 style: Theme.of(context).textTheme.subtitle2!.copyWith(color: lightBlack),
  //                               ),
  //                             )
  //                           ]),
  //                           Text(
  //                             CUR_CURRENCY + " " + orderItem.price!,
  //                             style: Theme.of(context).textTheme.subtitle1!.copyWith(color: fontColor),
  //                           ),
  //                           widget.model.itemList.length > 1
  //                               ? Padding(
  //                                   padding: const EdgeInsets.symmetric(vertical: 10.0),
  //                                   child: Row(
  //                                     children: [
  //                                       Expanded(
  //                                         child: Padding(
  //                                           padding: const EdgeInsets.only(right: 8.0),
  //                                           child: DropdownButtonFormField(
  //                                             dropdownColor: lightWhite,
  //                                             isDense: true,
  //                                             iconEnabledColor: fontColor,
  //                                             //iconSize: 40,
  //                                             hint: new Text(
  //                                               "Update Status",
  //                                               style: Theme.of(this.context)
  //                                                   .textTheme
  //                                                   .subtitle2!
  //                                                   .copyWith(color: fontColor, fontWeight: FontWeight.bold),
  //                                             ),
  //                                             decoration: InputDecoration(
  //                                               filled: true,
  //                                               isDense: true,
  //                                               fillColor: lightWhite,
  //                                               contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //                                               enabledBorder: OutlineInputBorder(
  //                                                 borderSide: BorderSide(color: fontColor),
  //                                               ),
  //                                             ),
  //                                             value: orderItem.status,
  //                                             onChanged: (newValue) {
  //                                               setState(() {
  //                                                 orderItem.curSelected = newValue as String;
  //                                               });
  //                                             },
  //                                             items: statusList.map((String st) {
  //                                               return DropdownMenuItem<String>(
  //                                                 value: st,
  //                                                 child: Text(
  //                                                   capitalize(st),
  //                                                   style: Theme.of(this.context)
  //                                                       .textTheme
  //                                                       .subtitle2!
  //                                                       .copyWith(color: fontColor, fontWeight: FontWeight.bold),
  //                                                 ),
  //                                               );
  //                                             }).toList(),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       RawMaterialButton(
  //                                         constraints: BoxConstraints.expand(width: 42, height: 42),
  //                                         onPressed: () {
  //                                           if (model.otp != null &&
  //                                               model.otp.isNotEmpty &&
  //                                               model.otp != "0" &&
  //                                               orderItem.curSelected == DELIVERED)
  //                                             otpDialog(orderItem.curSelected!, model.otp, model.id, true, i);
  //                                           else
  //                                             updateOrder(orderItem.curSelected!, updateOrderApi, model.id, true, i);
  //                                         },
  //                                         elevation: 2.0,
  //                                         fillColor: fontColor,
  //                                         padding: EdgeInsets.only(left: 5),
  //                                         child: Align(
  //                                           alignment: Alignment.center,
  //                                           child: Icon(
  //                                             Icons.send,
  //                                             size: 20,
  //                                             color: white,
  //                                           ),
  //                                         ),
  //                                         shape: CircleBorder(),
  //                                       )
  //                                     ],
  //                                   ),
  //                                 )
  //                               : Container()
  //                         ],
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ],
  //           )));
  // }

  // Future<void> updateOrder(String status, Uri api, String id, bool item, int index) async {
  //   _isNetworkAvail = await isNetworkAvailable();
  //   if (editOrder) {
  //     if (_isNetworkAvail) {
  //       try {
  //         setState(() {
  //           _isProgress = true;
  //         });
  //
  //         var parameter = {
  //           ORDERID: id,
  //           STATUS: status,
  //         };
  //
  //         if (item) parameter[ORDERITEMID] = widget.model.itemList[index].id!;
  //         if (selectedDelBoy != null) parameter[DEL_BOY_ID] = searchList[selectedDelBoy!].id;
  //
  //         Response response = await post(item ? updateOrderItemApi : updateOrderApi, body: parameter, headers: headers)
  //             .timeout(Duration(seconds: timeOut));
  //
  //         var getdata = json.decode(response.body);
  //         bool error = getdata["error"];
  //         String msg = getdata["message"];
  //         setSnackbar(msg);
  //         if (!error) {
  //           if (item)
  //             widget.model.itemList[index].status = status;
  //           else
  //             widget.model.activeStatus = status;
  //           if (selectedDelBoy != null) widget.model.deliveryBoyId = searchList[selectedDelBoy!].id;
  //         }
  //
  //         setState(() {
  //           _isProgress = false;
  //         });
  //       } on TimeoutException catch (_) {
  //         setSnackbar(somethingMSg);
  //       }
  //     } else {
  //       setState(() {
  //         _isNetworkAvail = false;
  //       });
  //     }
  //   } else {
  //     setSnackbar('You have not authorized permission for update order!!');
  //   }
  // }

  _launchCaller() async {
    var url = "tel:${widget.order.userPhoneNumber}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

  // bankProof(Order_Model model) {
  //   return Card(
  //       elevation: 0,
  //       child: ListView.builder(
  //         shrinkWrap: true,
  //         itemCount: model.attachList.length,
  //         physics: NeverScrollableScrollPhysics(),
  //         itemBuilder: (context, i) {
  //           return Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 InkWell(
  //                   child: Text(
  //                     "Attachment " + (i + 1).toString(),
  //                     style: TextStyle(decoration: TextDecoration.underline, color: fontColor),
  //                   ),
  //                   onTap: () {
  //                     _launchURL(model.attachList[i].attachment);
  //                   },
  //                 ),
  //                 InkWell(
  //                   child: Icon(
  //                     Icons.delete,
  //                     color: fontColor,
  //                   ),
  //                   onTap: () {
  //                     deleteBankProof(i, model);
  //                   },
  //                 )
  //               ],
  //             ),
  //           );
  //         },
  //       ));
  // }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  // Future<void> deleteBankProof(int i, Order_Model model) async {
  //   _isNetworkAvail = await isNetworkAvailable();
  //   if (editOrder) {
  //     if (_isNetworkAvail) {
  //       try {
  //         setState(() {
  //           _isProgress = true;
  //         });
  //
  //         var parameter = {
  //           ID: model.attachList[i].id,
  //         };
  //
  //         Response response =
  //             await post(deleteBankProofApi, body: parameter, headers: headers).timeout(Duration(seconds: timeOut));
  //
  //         var getdata = json.decode(response.body);
  //         bool error = getdata["error"];
  //         String msg = getdata["message"];
  //         setSnackbar(msg);
  //         if (!error) {
  //           model.attachList.removeWhere((item) => item.id == model.attachList[i].id);
  //         }
  //
  //         setState(() {
  //           _isProgress = false;
  //         });
  //       } on TimeoutException catch (_) {
  //         setSnackbar(somethingMSg);
  //       }
  //     } else {
  //       setState(() {
  //         _isNetworkAvail = false;
  //       });
  //     }
  //   } else {
  //     setSnackbar('You have not authorized permission for update order!!');
  //   }
  // }
}
