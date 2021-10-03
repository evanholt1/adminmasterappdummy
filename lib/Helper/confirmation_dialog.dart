import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<T?> showConfirmationDialog<T>(
    {required BuildContext context,
    required void Function()? onYes,
    void Function()? onNo,
    Widget? content,
    required String text}) {
  return showDialog(
    context: context,
    builder: (ctx) {
      return _ConfirmationDialog(
          ctx: ctx, onYes: onYes, onNo: onNo, content: content, text: text);
    },
  );
}

class _ConfirmationDialog extends StatelessWidget {
  final BuildContext ctx;
  final void Function()? onYes;
  final void Function()? onNo;
  final Widget? content;
  final String text;

  const _ConfirmationDialog(
      {required this.ctx,
      required this.onYes,
      this.onNo,
      this.content,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.text, textAlign: TextAlign.center),
      content: this.content,
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.white)),
          onPressed: this.onYes,
          child: Text(AppLocalizations.of(context)!.yes,
              style: Theme.of(context).textTheme.bodyText1),
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: AppColors.black),
          onPressed: this.onNo ?? () => Navigator.of(ctx).pop(),
          child: Text(
            AppLocalizations.of(context)!.no,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: AppColors.white),
          ),
        ),
      ],
    );
  }
}
