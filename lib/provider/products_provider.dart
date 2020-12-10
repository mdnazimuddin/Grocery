import 'package:Uthbay/models/product.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class SortBy {
  String value;
  String text;
  String sortOrder;
  SortBy(this.value, this.text, this.sortOrder);
}

enum LoadMoreStatus { INITIAL, LOADING, STABLE }

class ProductProvider with ChangeNotifier {
  APIService _apiService;
  List<Product> _productsList;
  SortBy _sortBy;

  int pageSize = 10;

  List<Product> get allProducts => _productsList;
  double get totalRecords => _productsList.length.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  getLoadMoreStatus() => _loadMoreStatus;

  ProductProvider() {
    _sortBy = SortBy("updated_at", "Latest", "asc");
  }

  void resetStreams() {
    _apiService = APIService();
    _productsList = List<Product>();
  }

  setLoadingState(LoadMoreStatus loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }

  setSortOrder(SortBy sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  fetchProducts(
    pageNumber, {
    String strSerach,
    String tagId,
    String categoryId,
    String sortBy,
    String sortOrder = 'asc',
  }) async {
    List<Product> itemModel = await _apiService.getProducts(
        categoryId: categoryId,
        strSerach: strSerach,
        tagId: tagId,
        pageNumber: pageNumber,
        pageSize: this.pageSize.toString(),
        sortBy: this._sortBy.value,
        sortOrder: this._sortBy.sortOrder);
    if (itemModel.length > 0) {
      _productsList.addAll(itemModel);
    }
    setLoadingState(LoadMoreStatus.STABLE);
    notifyListeners();
  }
}
