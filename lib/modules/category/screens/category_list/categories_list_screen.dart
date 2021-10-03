import 'dart:async';
import 'dart:convert';

import 'package:admin_eshop/Helper/AppBtn.dart';
import 'package:admin_eshop/Helper/Constant.dart';
import 'package:admin_eshop/Helper/Session.dart';
import 'package:admin_eshop/Helper/SimBtn.dart';
import 'package:admin_eshop/Helper/String.dart';
import 'package:admin_eshop/Search.dart';
import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:admin_eshop/modules/category/providers/categories_list_provider.dart';
import 'package:admin_eshop/modules/category/screens/category_list/widgets/categories_list_screen_content.dart';
import 'package:admin_eshop/modules/product/models/DBProduct.dart';
import 'package:admin_eshop/modules/product/providers/product_list/product_list_cubit.dart';
import 'package:admin_eshop/modules/product/providers/selected_product_category/SelectedProductCategoryProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoriesListScreen extends StatefulWidget {
  const CategoriesListScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => StateProduct();
}

class StateProduct extends State<CategoriesListScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true, _isProgress = false;
  List<DBProduct> productList = [];
  List<DBProduct> tempList = [];

  @override
  void initState() {}

  @override
  void dispose() {}

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoriesListProvider>(
      create: (_) => CategoriesListProvider(),
      child: Scaffold(
          backgroundColor: lightWhite,
          appBar: getAppbar(context),
          body: Consumer<CategoriesListProvider>(
              builder: (context, categoriesListP, __) {
            if (!categoriesListP.loading)
              return CategoriesListScreenContent();
            else
              return shimmer();
          })),
    );
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

  getAppbar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: lightWhite,
      iconTheme: IconThemeData(color: primary),
      title: Text(
        AppLocalizations.of(context)!.categories,
        style: TextStyle(
          color: fontColor,
        ),
      ),
      elevation: 5,
      leading: Builder(builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.all(10),
          decoration: shadow(),
          child: Card(
            elevation: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 4.0),
                child: Icon(Icons.keyboard_arrow_left, color: primary),
              ),
            ),
          ),
        );
      }),
    );
  }
}
