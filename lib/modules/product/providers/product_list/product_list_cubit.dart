import 'package:admin_eshop/modules/product/models/Category.dart';
import 'package:admin_eshop/modules/product/providers/product_list/product_list_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final ProductListRepository _productListRepository = ProductListRepository();

  ProductListCubit() : super(ProductListInitial()) {
    _getProductList();
  }

  _getProductList() async {
    emit(ProductListLoadInProgress());
    final list = await _productListRepository.getProductList();
    emit(ProductListGetSuccess(list));
  }
}
