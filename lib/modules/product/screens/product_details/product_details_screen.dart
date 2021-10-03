import 'package:admin_eshop/Helper/Session.dart';
import 'package:admin_eshop/common/blocs/locale/locale_cubit.dart';
import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:admin_eshop/modules/product/models/DBProduct.dart';
import 'package:admin_eshop/modules/product/providers/product_edit/product_edit_provider.dart';
import 'package:admin_eshop/modules/product/providers/product_edit/widgets/product_details_screen_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ProductDetailsScreen extends StatefulWidget {
  final DBProduct product;

  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final isEnglish = (LocaleCubit().state as LocaleSetSuccess).isEnglish;
    return ChangeNotifierProvider<ProductEditProvider>(
      create: (_) => ProductEditProvider(widget.product),
      child: Scaffold(
        backgroundColor: lightWhite,
        appBar: _getAppbar(),
        body: FormBuilder(
          key: _formKey,
          child: Consumer<ProductEditProvider>(
            builder: (context, productEditP, __) {
              print('rebuilding');
              return ListView(
                shrinkWrap: true,
                children: [
                  Text("Item Name"),
                  ProductDetailsScreenTextField(
                    name: "name.en",
                    initialValue: productEditP.oProduct.name.en!,
                    onChanged: (newVal) {
                      context
                          .read<ProductEditProvider>()
                          .updateProductName(newVal, true);
                    },
                    resetMethod: () =>
                        context.read<ProductEditProvider>().resetName(true),
                    isEnglishField: true,
                    label: "Name - English",
                    colorSwitchCondition: () =>
                        context.read<ProductEditProvider>().namesAreEqual(true),
                  ),
                  ProductDetailsScreenTextField(
                    name: "name.ar",
                    initialValue: productEditP.oProduct.name.ar!,
                    onChanged: (newVal) {
                      context
                          .read<ProductEditProvider>()
                          .updateProductName(newVal, false);
                    },
                    resetMethod: () =>
                        context.read<ProductEditProvider>().resetName(false),
                    isEnglishField: true,
                    label: "Name - Arabic",
                    colorSwitchCondition: () => context
                        .read<ProductEditProvider>()
                        .namesAreEqual(false),
                  ),
                  // Align(
                  //   child: Container(
                  //     width: 75.0.w,
                  //     child: FormBuilderTextField(
                  //       initialValue: widget.product.name.ar,
                  //       name: "name_ar",
                  //       textAlign: isEnglish ? TextAlign.end : TextAlign.start,
                  //     ),
                  //   ),
                  // ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _getAppbar() {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: lightWhite,
      iconTheme: IconThemeData(color: primary),
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
