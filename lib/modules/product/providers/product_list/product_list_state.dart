part of 'product_list_cubit.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();
}

class ProductListInitial extends ProductListState {
  @override
  List<Object> get props => [];
}

class ProductListLoadInProgress extends ProductListState {
  @override
  List<Object> get props => [];
}

class ProductListGetSuccess extends ProductListState {
  final List<ProductCategory> categories;

  ProductListGetSuccess(this.categories);

  @override
  List<Object> get props => [categories];
}
