import 'package:admin_eshop/modules/category/providers/categories_list_provider.dart';
import 'package:admin_eshop/modules/category/screens/category_list/widgets/product_list_screen_item.dart';
import 'package:admin_eshop/modules/product/providers/product_list/product_list_cubit.dart';
import 'package:admin_eshop/modules/product/providers/selected_product_category/SelectedProductCategoryProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class CategoriesListScreenList extends StatelessWidget {
  const CategoriesListScreenList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoriesListProvider>().categories;
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (_, i) =>
            CategoriesListScreenItem(category: categories[i]),
        separatorBuilder: (_, __) => SizedBox(height: 1.0.h),
        itemCount: categories.length);
  }
}
