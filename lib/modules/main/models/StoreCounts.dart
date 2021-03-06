class StoreCounts {
  final int orderCount;
  final int productCount;
  final int usersCount;
  final int driverCount;
  final int unavailableItemsCount;
  final int categoriesCount;

  StoreCounts(
      {required this.orderCount,
      required this.productCount,
      required this.usersCount,
      required this.driverCount,
      required this.categoriesCount,
      required this.unavailableItemsCount});

  StoreCounts.fromJson(Map<String, dynamic> json)
      : this.orderCount = json['orders'],
        this.productCount = json['items'],
        this.usersCount = json['users'],
        this.driverCount = json['drivers'],
        this.categoriesCount = json['categories'],
        this.unavailableItemsCount = json['unavailableItems'];
}
