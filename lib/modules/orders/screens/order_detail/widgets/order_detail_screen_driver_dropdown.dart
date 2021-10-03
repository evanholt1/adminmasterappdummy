import 'package:admin_eshop/Models/driver.dart';
import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:admin_eshop/modules/orders/models/order.dart';
import 'package:admin_eshop/modules/orders/providers/driver_list_provider.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class OrderDetailScreenDriverDropdown extends StatelessWidget {
  final Order order;

  const OrderDetailScreenDriverDropdown(this.order);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Order>.value(
      value: order,
      child: Consumer<Order>(
        builder: (_, order, __) => Consumer<DriverListProvider>(
          builder: (_, driverListP, __) {
            print('rebuilding here');
            print(order.driver);
            print(driverListP.loading);
            if (!driverListP.loading)
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //if (driverListP.availableDrivers.length > 0)
                  CustomSearchableDropDown(
                    initialIndex: order.driver == null
                        ? null
                        : _getDriverIndex(driverListP, order),
                    items: driverListP.availableDrivers,
                    primaryColor: AppColors.primary,
                    label: driverListP.availableDrivers.length > 0
                        ? AppLocalizations.of(context)!.available_drivers
                        : AppLocalizations.of(context)!.no_available_drivers,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary)),
                    prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(Icons.search)),
                    dropDownMenuItems: driverListP.availableDrivers
                        .map((item) => item.name)
                        .toList(),
                    onChanged: (value) {
                      if (value != null) order.assignDriver(value as Driver);
                      //return this.order.assignDriver(value as VendorDriver);
                    },
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          driverListP.startLoading();
                          order.clearDriver();

                          driverListP.endLoading();
                        },
                        child: Text(AppLocalizations.of(context)!.clear),
                      ),
                    ],
                  )
                ],
              );
            if (driverListP.loading)
              return Center(
                  child: Container(
                      width: 9.0.w,
                      height: 4.0.h,
                      child: CircularProgressIndicator()));
            else
              return Container();
          },
        ),
      ),
    );
  }

  int? _getDriverIndex(DriverListProvider driverListP, Order order) {
    final index = driverListP.availableDrivers.indexOf(order.driver!);
    if (index != -1) return index;
    return null;
  }
}
