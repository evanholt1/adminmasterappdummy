import 'package:admin_eshop/common/blocs/locale/locale_cubit.dart';
import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:admin_eshop/modules/product/providers/product_edit/product_edit_provider.dart';
import 'package:admin_eshop/modules/product/screens/product_details/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailsScreenTextField extends StatelessWidget {
  const ProductDetailsScreenTextField({
    Key? key,
    required this.name,
    required this.label,
    required this.onChanged,
    required this.isEnglishField,
    required this.colorSwitchCondition,
    required this.initialValue,
    required this.resetMethod,
    this.keyboardType,
    this.maxLines,
    this.maxLength,
  }) : super(key: key);

  final String name;
  final String label;
  final void Function(String?)? onChanged;
  final bool isEnglishField;
  final bool Function() colorSwitchCondition;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final String initialValue;
  final void Function()? resetMethod;

  @override
  Widget build(BuildContext context) {
    final product = context.watch<ProductEditProvider>().eProduct;

    return Padding(
      padding: EdgeInsetsDirectional.only(start: 2.5.w, top: 1.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 65.0.w,
            padding: EdgeInsetsDirectional.only(start: 2.0.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: this.colorSwitchCondition()
                        ? AppColors.lightBlack
                        : AppColors.primary)),
            child: FormBuilderTextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(this.maxLength ?? 99)
              ],
              initialValue: this.initialValue,
              keyboardType: this.keyboardType ??
                  (this.maxLines != null && this.maxLines! > 1
                      ? TextInputType.multiline
                      : TextInputType.text),
              maxLines: this.maxLines ?? 1,
              name: this.name,
              textAlign: _getTextAlign(),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: this.label,
              ),
              onChanged: this.onChanged,
            ),
          ),
          OutlinedButton(
            onPressed: this.resetMethod,
            child: Text(AppLocalizations.of(context)!.reset),
          )
        ],
      ),
    );
  }

  TextAlign _getTextAlign() {
    final isEnglish = (LocaleCubit().state as LocaleSetSuccess).isEnglish;

    if (isEnglish && this.isEnglishField)
      return TextAlign.start;
    else if (isEnglish) return TextAlign.end;

    if (!isEnglish && !this.isEnglishField)
      return TextAlign.start;
    else
      return TextAlign.end;
  }
}
