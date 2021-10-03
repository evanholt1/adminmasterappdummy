import 'package:admin_eshop/modules/product/providers/product_list/product_list_cubit.dart';
import 'package:admin_eshop/modules/product/providers/selected_product_category/SelectedProductCategoryProvider.dart';
import 'package:admin_eshop/modules/product/screens/product_list/widgets/product_list_screen_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ProductListScreenItemsList extends StatelessWidget {
  const ProductListScreenItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryIndex =
        context.watch<SelectedProductCategoryProvider>().selectedCatIndex;
    final categories =
        (context.watch<ProductListCubit>().state as ProductListGetSuccess)
            .categories;
    final products = categories[categoryIndex].products;
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (_, i) => ProductListScreenItem(item: products[i]),
        separatorBuilder: (_, __) => SizedBox(height: 1.0.h),
        itemCount: products.length);
  }
}
