class ApiPaths {
  static const base = "small-mart.herokuapp.com";
  static const _ordersBase = '/order';
  static const _ItemsBase = '/item';
  static const _driversBase = '/driver';
  static const _categoriesBase = '/category';

  static const ordersToday = '$_ordersBase/today';
  static const updateOrderStatus = '$_ordersBase/updateStatus';
  static const categoriesWithItems = '$_categoriesBase/withItems';
  static const counts = '/counts';
}
