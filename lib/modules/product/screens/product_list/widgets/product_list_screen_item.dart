import 'package:admin_eshop/Helper/Session.dart';
import 'package:admin_eshop/Helper/String.dart';
import 'package:admin_eshop/common/blocs/locale/locale_cubit.dart';
import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:admin_eshop/constants/AppRoutes.dart';
import 'package:admin_eshop/modules/product/models/DBProduct.dart';
import 'package:admin_eshop/modules/product/screens/product_details/product_details_screen.dart';
import 'package:flutter/material.dart';

class ProductListScreenItem extends StatelessWidget {
  final DBProduct item;
  const ProductListScreenItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isEnglish = (LocaleCubit().state as LocaleSetSuccess).isEnglish;
    final itemName = isEnglish ? item.name.en : item.name.ar;
    final itemDesc = isEnglish ? item.description.en : item.description.ar;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: item),
          ),
        );
      },
      child: Card(
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
                    tag: "${item.id}",
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(7.0),
                        child: FadeInImage(
                          image: NetworkImage(item.imageUrl),
                          height: 80.0,
                          width: 80.0,
                          // fit: extendImg ? BoxFit.fill : BoxFit.contain,
                          placeholder: placeHolder(80),
                        )),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            itemName!,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(color: lightBlack),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                  CUR_CURRENCY +
                                      " " +
                                      item.price.toStringAsFixed(3) +
                                      " ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          // Text(
                          //   'Available: ${item.isActive}',
                          // ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star, color: primary, size: 12),
                                  Text(
                                    " " + item.rating.toStringAsFixed(2),
                                    style: Theme.of(context).textTheme.overline,
                                  ),
                                  Text(
                                    " (" + item.ratingCount.toString() + ")",
                                    style: Theme.of(context).textTheme.overline,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            !item.isActive
                ? Text('Unavailable',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: Colors.red, fontWeight: FontWeight.bold))
                : Container(),
          ]),
        ),
      ),
    );
  }
}
