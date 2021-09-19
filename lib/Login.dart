import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import 'Helper/AppBtn.dart';
import 'Helper/Constant.dart';
import 'Helper/Session.dart';
import 'Helper/String.dart';
import 'Privacy_Policy.dart';
import 'Send_Otp.dart';
import 'config/themes/base_theme_colors.dart';
import 'modules/main/screens/home/HomeScreen.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<Login> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  String? countryName;
  FocusNode passFocus = FocusNode(), monoFocus = FocusNode();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool visible = false;
  String? password, mobile, username, email, id, mobileno;
  bool _isNetworkAvail = true;
  late Animation buttonSqueezeanimation;

  late AnimationController buttonController;

  @override
  void initState() {
    super.initState();
    buttonController = new AnimationController(duration: new Duration(milliseconds: 2000), vsync: this);

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
    setState(() {
      mobileController.text = "9876543210";
      passwordController.text = "12345678";
    });
  }

  @override
  void dispose() {
    buttonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

  Future<void> checkNetwork() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      getLoginUser();
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) async {
        await buttonController.reverse();
        setState(() {
          _isNetworkAvail = false;
        });
      });
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: fontColor),
      ),
      backgroundColor: lightWhite,
      elevation: 1.0,
    ));
  }

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: kToolbarHeight),
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
                      context, MaterialPageRoute(builder: (BuildContext context) => super.widget));
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

  Future<void> getLoginUser() async {
    var data = {MOBILE: mobile, PASSWORD: password};
    try {
      var response = await post(getUserLoginApi, body: data, headers: headers).timeout(Duration(seconds: timeOut));

      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);

        bool error = getdata["error"];
        String msg = getdata["message"];
        await buttonController.reverse();
        if (!error) {
          setSnackbar(msg);
          var i = getdata["data"][0];
          id = i[ID];
          username = i[USERNAME];
          email = i[EMAIL];
          mobile = i[MOBILE];

          CUR_USERID = id!;
          CUR_USERNAME = username!;

          saveUserDetail(id!, username!, email!, mobile!);
          setPrefrenceBool(isLogin, true);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
        } else {
          setSnackbar(msg);
        }
      } else {
        await buttonController.reverse();
      }
    } on TimeoutException catch (_) {
      await buttonController.reverse();
      setSnackbar(somethingMSg);
    }
  }

  _subLogo() {
    return Expanded(
      flex: 4,
      child: Center(
        child: new Image.asset(
          'assets/images/homelogo.png',
        ),
      ),
    );
  }

  signInTxt() {
    return Padding(
        padding: EdgeInsets.only(
          top: 30.0,
        ),
        child: Align(
          alignment: Alignment.center,
          child: new Text(
            SIGNIN_LBL,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: fontColor, fontWeight: FontWeight.bold),
          ),
        ));
  }

  termAndPolicyTxt() {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.0, left: 25.0, right: 25.0, top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(CONTINUE_AGREE_LBL,
              style: Theme.of(context).textTheme.caption!.copyWith(color: fontColor, fontWeight: FontWeight.normal)),
          SizedBox(
            height: 3.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacyPolicy(
                                title: TERM,
                              )));
                },
                child: Text(
                  TERMS_SERVICE_LBL,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: fontColor, decoration: TextDecoration.underline, fontWeight: FontWeight.normal),
                )),
            SizedBox(
              width: 5.0,
            ),
            Text(AND_LBL,
                style: Theme.of(context).textTheme.caption!.copyWith(color: fontColor, fontWeight: FontWeight.normal)),
            SizedBox(
              width: 5.0,
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacyPolicy(
                                title: PRIVACY,
                              )));
                },
                child: Text(
                  PRIVACY_POLICY_LBL,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: fontColor, decoration: TextDecoration.underline, fontWeight: FontWeight.normal),
                )),
          ]),
        ],
      ),
    );
  }

  setMobileNo() {
    return Container(
      width: deviceWidth * 0.7,
      padding: EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(passFocus);
        },
        keyboardType: TextInputType.number,
        controller: mobileController,
        style: TextStyle(color: fontColor, fontWeight: FontWeight.normal),
        focusNode: monoFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: validateMob,
        onSaved: (String? value) {
          mobile = value!;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.call_outlined,
            color: fontColor,
            size: 17,
          ),
          hintText: MOBILEHINT_LBL,
          hintStyle:
              Theme.of(this.context).textTheme.subtitle2!.copyWith(color: fontColor, fontWeight: FontWeight.normal),
          filled: true,
          fillColor: lightWhite,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 20),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: fontColor),
            borderRadius: BorderRadius.circular(7.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: lightWhite),
            borderRadius: BorderRadius.circular(7.0),
          ),
        ),
      ),
    );
  }

  setPass() {
    return Container(
        width: deviceWidth * 0.7,
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
          keyboardType: TextInputType.text,
          obscureText: true,
          focusNode: passFocus,
          style: TextStyle(color: fontColor),
          controller: passwordController,
          validator: validatePass,
          onSaved: (String? value) {
            password = value!;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock_outline,
              color: fontColor,
              size: 17,
            ),
            hintText: PASSHINT_LBL,
            hintStyle:
                Theme.of(this.context).textTheme.subtitle2!.copyWith(color: fontColor, fontWeight: FontWeight.normal),
            filled: true,
            fillColor: lightWhite,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 25),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: fontColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: lightWhite),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ));
  }

  forgetPass() {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              onTap: () {
                setPrefrence(ID, id!);
                setPrefrence(MOBILE, mobile!);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SendOtp(
                              title: FORGOT_PASS_TITLE,
                            )));
              },
              child: Text(FORGOT_PASSWORD_LBL,
                  style:
                      Theme.of(context).textTheme.subtitle2!.copyWith(color: fontColor, fontWeight: FontWeight.normal)),
            ),
          ],
        ));
  }

  loginBtn() {
    return AppBtn(
      title: SIGNIN_LBL,
      btnAnim: buttonSqueezeanimation,
      btnCntrl: buttonController,
      onBtnSelected: () async {
        validateAndSubmit();
      },
    );
  }

  _expandedBottomView() {
    return Expanded(
      flex: 6,
      child: Container(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _formkey,
            child: Card(
              elevation: 0.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  signInTxt(),
                  setMobileNo(),
                  setPass(),
                  forgetPass(),
                  loginBtn(),
                  termAndPolicyTxt(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        body: _isNetworkAvail
            ? Container(
                color: lightWhite,
                padding: EdgeInsets.only(
                  bottom: 20.0,
                ),
                child: Column(
                  children: <Widget>[
                    _subLogo(),
                    _expandedBottomView(),
                  ],
                ))
            : noInternet(context));
  }
}
