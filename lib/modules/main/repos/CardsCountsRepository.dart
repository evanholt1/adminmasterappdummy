import 'dart:convert';

import 'package:admin_eshop/constants/ApiPaths.dart';
import 'package:admin_eshop/modules/main/models/StoreCounts.dart';
import 'package:admin_eshop/utils/services/RestApiService.dart';

class CardsCountsRepository {
  static Future<StoreCounts> getCounts() async {
    final res = await RestApiService.get(ApiPaths.counts);

    if (res.statusCode == 200)
      return StoreCounts.fromJson(jsonDecode(res.body));
    else
      throw res.body;
  }
}
