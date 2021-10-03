import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:admin_eshop/modules/product/models/Category.dart';
import 'package:admin_eshop/modules/product/providers/product_list/product_list_cubit.dart';
import 'package:admin_eshop/modules/product/providers/selected_product_category/SelectedProductCategoryProvider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class ProductListScreenCategory extends StatelessWidget {
  final ProductCategory category;
  final int index;
  const ProductListScreenCategory(
      {required this.category, required this.index, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected =
        context.read<SelectedProductCategoryProvider>().selectedCatIndex ==
            index;
    return InkWell(
      onTap: () {
        context.read<SelectedProductCategoryProvider>().selectCat(index);
        //context.read<ProductListCubit>().;
      },
      child: Card(
        child: Container(
          // decoration: BoxDecoration(
          //   color: isSelected ? primary : lightWhite,
          //   border: Border.all(width: 1, color: black),
          //   //borderRadius: BorderRadius.circular(30),
          // ),
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          constraints: BoxConstraints(
            minWidth: 15.0.w,
            maxHeight: 6.0.h,
            minHeight: 6.0.h,
          ),
          alignment: Alignment.center,
          child: Text(
            category.name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? primary : black),
          ),
        ),
      ),
    );
  }
}
