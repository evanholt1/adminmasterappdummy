import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'Helper/AppBtn.dart';
import 'Helper/Color.dart';
import 'Helper/Constant.dart';
import 'Helper/Session.dart';
import 'Helper/String.dart';
import 'Model/Person_Model.dart';

class DeliveryBoy extends StatefulWidget {
  final bool isDelBoy;

  const DeliveryBoy({Key key, this.isDelBoy}) : super(key: key);
  @override
  _DeliveryBoyState createState() => _DeliveryBoyState();
}

class _DeliveryBoyState extends State<DeliveryBoy>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // ScrollController controller = new ScrollController();
  List<PersonModel> tempList = [];
  Animation buttonSqueezeanimation;
  AnimationController buttonController;
  bool _isNetworkAvail = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  List<PersonModel> notiList = [];
  // int offset = 0;
  int total = 0;
  //bool isLoadingmore = true;
  bool _isLoading = true;
  final TextEditingController _controller = TextEditingController();
  Icon iconSearch = Icon(
    Icons.search,
    color: primary,
  );
  Widget appBarTitle;
  ScrollController notificationcontroller;

  ///currently is searching
  bool isSearching;
  String _searchText = "", _lastsearch = "";

  bool notificationisloadmore = true,
      notificationisgettingdata = false,
      notificationisnodata = false;
  int notificationoffset = 0;

  @override
  void initState() {
    appBarTitle = Text(
      widget.isDelBoy ? Del_LBL : CUST_LBL,
      style: TextStyle(color: primary),
    );
    notificationoffset = 0;
    Future.delayed(Duration.zero, this.getDetails);
    //getDetails();

    // controller.addListener(_scrollListener);
    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    notificationcontroller = ScrollController(keepScrollOffset: true);
    notificationcontroller.addListener(_transactionscrollListener);

    buttonSqueezeanimation = new Tween(
      begin: deviceWidth * 0.7,
      end: 50.0,
    ).animate(new CurvedAnimation(
      parent: buttonController,
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
          (_searchText == '' || (_searchText.length >= 2))) {
        _lastsearch = _searchText;
        notificationisloadmore = true;
        notificationoffset = 0;
        getDetails();
      }
    });

    super.initState();
  }

  _transactionscrollListener() {
    if (notificationcontroller.offset >=
            notificationcontroller.position.maxScrollExtent &&
        !notificationcontroller.position.outOfRange) {
      if (mounted)
        setState(() {
       
          notificationisloadmore = true;
          getDetails();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: getAppbar(),
        body: _isNetworkAvail
            ? _isLoading
                ? shimmer()
                : notificationisnodata
                    ? Padding(
                        padding: const EdgeInsetsDirectional.only(
                            top: kToolbarHeight),
                        child: Center(child: Text('No Items Found')))
                    : NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {},
                        child: Column(
                          children: <Widget>[
                            Expanded(
                                child: RefreshIndicator(
                                    key: _refreshIndicatorKey,
                                    onRefresh: _refresh,
                                    child: ListView.builder(
                                      controller: notificationcontroller,

                                      // shrinkWrap: true,
                                      //  controller: controller,
                                      itemCount: notiList.length,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        // return (index == notiList.length && isLoadingmore)
                                        //     ? Center(child: CircularProgressIndicator())
                                        //     : listItem(index);

                                        PersonModel item;
                                        try {
                                          item = notiList.isEmpty
                                              ? null
                                              : notiList[index];
                                          if (notificationisloadmore &&
                                              index == (notiList.length - 1) &&
                                              notificationcontroller
                                                      .position.pixels <=
                                                  0) {
                                            getDetails();
                                          }
                                        } on Exception catch (_) {}

                                        return item == null
                                            ? Container()
                                            : listItem(index);
                                      },
                                    ))),
                            notificationisgettingdata
                                ? Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        top: 5, bottom: 5),
                                    child: CircularProgressIndicator(),
                                  )
                                : Container(),
                          ],
                        ),
                      )
            : noInternet(context));
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
                  getDetails();
                } else {
                  await buttonController.reverse();
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
          icon: iconSearch,
          onPressed: () {
          
            if (!mounted) return;
            setState(() {
              if (iconSearch.icon == Icons.search) {
                iconSearch = Icon(
                  Icons.close,
                  color: primary,
                );
                appBarTitle = TextField(
                  controller: _controller,
                  autofocus: true,
                  style: TextStyle(
                    color: primary,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: primary),
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: primary),
                  ),
                  //  onChanged: searchOperation,
                );
                _handleSearchStart();
              } else {
                _handleSearchEnd();

              
              }
            });
          },
        )
      ],
    );
  }

  void _handleSearchStart() {
    if (!mounted) return;
    setState(() {
      isSearching = true;
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
        widget.isDelBoy ? Del_LBL : CUST_LBL,
        style: TextStyle(color: primary),
      );
      isSearching = false;
      _controller.clear();
    });
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  Widget listItem(int index) {
    PersonModel model = notiList[index];

 
    String add = model.street + " " + model.area + " " + model.city;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    model.name,
                    style: TextStyle(color: primary),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                      color: model.status == "1" ? Colors.green : Colors.red,
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(4.0))),
                  child: Text(
                    model.status == "1" ? "Active" : "Deactive",
                    style: TextStyle(color: white, fontSize: 11),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      add.length > 2
                          ? Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(model.street +
                                  " " +
                                  model.area +
                                  " " +
                                  model.city))
                          : Container(),
                      model.email != ""
                          ? InkWell(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  model.email,
                                  style: TextStyle(
                                      color: fontColor,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              onTap: () {
                                _launchMail(model.email);
                              },
                            )
                          : Container(),
                      InkWell(
                        child: Text(
                          model.mobile,
                          style: TextStyle(
                              color: fontColor,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          _launchCaller(model.mobile);
                        },
                      ),
                      Text(model.balance)
                    ],
                  ),
                ),
                model.img != null && model.img != ''
                    ? Container(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(3.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(model.img),
                              radius: 25,
                            )),
                      )
                    : Container(
                        height: 0,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _launchCaller(String mobile) async {
    var url = "tel:$mobile";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Null> _refresh() {
    if (mounted)
      setState(() {
        notiList.clear();
        notificationisloadmore = true;
        notificationoffset = 0;
      });

    total = 0;
    notiList.clear();
    return getDetails();
  }

  Future<Null> getDetails() async {
    if (widget.isDelBoy && readDel || !widget.isDelBoy && readCust) {
      _isNetworkAvail = await isNetworkAvailable();
      if (_isNetworkAvail) {
        try {
          if (notificationisloadmore) {
            if (mounted)
              setState(() {
                notificationisloadmore = false;
                notificationisgettingdata = true;
                if (notificationoffset == 0) {
                  notiList = [];
                }
              });
            var parameter = {
              LIMIT: perPage.toString(),
              OFFSET: notificationoffset.toString(),
              SEARCH: _searchText.trim(),
            };

            Response response = await post(
                    widget.isDelBoy ? getDelBoyApi : getCustApi,
                    headers: headers,
                    body: parameter)
                .timeout(Duration(seconds: timeOut));

          

            if (response.statusCode == 200) {
              var getdata = json.decode(response.body);
              bool error = getdata["error"];
              String msg = getdata["message"];
              notificationisgettingdata = false;
              if (notificationoffset == 0) notificationisnodata = error;

              if (!error) {
                tempList.clear();
                var mainList = getdata["data"];

                if (mainList.length != 0) {
                  tempList = (mainList as List)
                      .map((data) => new PersonModel.fromJson(data))
                      .toList();

                  notiList.addAll(tempList);
                  notificationisloadmore = true;
                  notificationoffset = notificationoffset + perPage;
                } else {
                  notificationisloadmore = false;
                }
              } else {
                // if (msg != "Products Not Found !") setSnackbar(msg);
                // isLoadingmore = false;
                notificationisloadmore = false;
              }
            }
            if (mounted)
              setState(() {
                notificationisloadmore = false;
                _isLoading = false;
              });
          }
        } on TimeoutException catch (_) {
          setSnackbar(somethingMSg);
          if (mounted)
            setState(() {
              _isLoading = false;
              // isLoadingmore = false;
            });
        }
      } else if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    } else {
      setState(() {
        _isLoading = false;
      });
      setSnackbar('You have not authorized permission for read.!!');
    }
    return null;
  }

  _launchMail(String email) async {
    var url = "mailto:${email}";
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
}
