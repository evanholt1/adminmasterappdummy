import 'package:admin_eshop/Helper/Session.dart';
import 'package:admin_eshop/Helper/String.dart';
import 'package:admin_eshop/common/blocs/locale/locale_cubit.dart';
import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:admin_eshop/modules/category/models/category.dart';
import 'package:admin_eshop/modules/product/models/DBProduct.dart';
import 'package:flutter/material.dart';

class CategoriesListScreenItem extends StatelessWidget {
  final Category category;
  const CategoriesListScreenItem({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isEnglish = (LocaleCubit().state as LocaleSetSuccess).isEnglish;
    final itemName = isEnglish ? category.name.en : category.name.ar;
    return Card(
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: "${category.id}",
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(7.0),
                      child: FadeInImage(
                        image: NetworkImage(category.imageUrl),
                        height: 80.0,
                        width: 80.0,
                        fit: BoxFit.cover,
                        placeholder: placeHolder(80),
                      )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          itemName!,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                  color: lightBlack,
                                  fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
