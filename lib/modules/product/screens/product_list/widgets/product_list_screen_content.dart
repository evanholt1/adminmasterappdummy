import 'package:admin_eshop/modules/product/screens/product_list/widgets/product_list_screen_categories_list.dart';
import 'package:admin_eshop/modules/product/screens/product_list/widgets/product_list_screen_items_list.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProductListScreenContent extends StatelessWidget {
  const ProductListScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ProductListScreenCategoriesList(),
        SizedBox(height: 2.0.h),
        ProductListScreenItemsList(),
      ],
    );
  }
}
