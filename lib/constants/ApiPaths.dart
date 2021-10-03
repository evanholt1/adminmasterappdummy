class ApiPaths {
  static const base = "small-mart.herokuapp.com";
  static const _ordersBase = '/order';
  static const _ItemsBase = '/item';
  static const _driversBase = '/driver';
  static const _categoriesBase = '/category';
  static const _settingsBase = '/settings';
  static const _entityBase = '/user';

  static const ordersToday = '$_ordersBase/today';
  static const allBranchOrders = '$_ordersBase/allBranchOrders';
  static const updateOrderStatus = '$_ordersBase/updateStatus';
  static const categoriesWithItems = '$_categoriesBase/withItems';
  static const counts = '/counts';
  static const currentDay = '$_settingsBase/currentDay';
  static const availableDrivers = '$_entityBase/availableDrivers';
  static const assignDriver = '$_ordersBase/assignDriver';
  static const clearDriver = '$_ordersBase/clearDriver';
  static const allCategories = '$_categoriesBase';
}
