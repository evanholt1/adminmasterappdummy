import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:admin_eshop/modules/product/providers/product_list/product_list_cubit.dart';
import 'package:admin_eshop/modules/product/providers/selected_product_category/SelectedProductCategoryProvider.dart';
import 'package:admin_eshop/modules/product/screens/product_list/widgets/product_list_screen_category.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListScreenCategoriesList extends StatelessWidget {
  const ProductListScreenCategoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedCatI =
        context.watch<SelectedProductCategoryProvider>().selectedCatIndex;
    final categories =
        (context.watch<ProductListCubit>().state as ProductListGetSuccess)
            .categories;

    return Container(
      height: 10.0.h,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (_, i) => ProductListScreenCategory(
                category: categories[i],
                index: i,
              ),
          itemCount: categories.length),
    );
  }
}
