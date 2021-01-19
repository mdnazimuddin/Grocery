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
  List<Product> _favouriteProductList;
  SortBy _sortBy;

  int pageSize = 10;

  List<Product> get allProducts => _productsList;
  double get totalRecords => _productsList.length.toDouble();

  List<Product> get allFavouriteProducts => _favouriteProductList;
  double get totalFavouriteRecords => _favouriteProductList.length.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  getLoadMoreStatus() => _loadMoreStatus;

  ProductProvider() {
    _sortBy = SortBy("updated_at", "Latest", "asc");
  }
  bool _favouriteProduct = false;
  bool get favouriteProduct => _favouriteProduct;

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
    String groceryId,
    String tagId,
    String categoryId,
    String sortBy,
    String sortOrder = 'asc',
  }) async {
    List<Product> itemModel = await _apiService.getProducts(
        categoryId: categoryId,
        strSerach: strSerach,
        groceryId: groceryId,
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

  fetchFavouriteGroceryProducts(String groceryId) async {
    _favouriteProductList = List<Product>();
    _apiService = APIService();
    List<Product> itemModel =
        await _apiService.fetchFavouriteGroceryProduct(groceryId);
    if (itemModel.length > 0) {
      _favouriteProductList.addAll(itemModel);
    }
    setLoadingState(LoadMoreStatus.STABLE);
    notifyListeners();
  }

  favouriteGroceryProductStatus(String groceryId, String productId) async {
    _apiService = APIService();
    _favouriteProduct =
        await _apiService.favouriteGroceryProductStatus(groceryId, productId);
    notifyListeners();
  }

  addFavouriteGroceryProduct(String groceryId, String productId) async {
    _apiService = APIService();
    _favouriteProduct =
        await _apiService.addFavouriteGroceryProduct(groceryId, productId);
    notifyListeners();
  }

  deleteFavouriteGroceryProduct(String groceryId, String productId) async {
    _apiService = APIService();
    _favouriteProduct =
        await _apiService.deleteFavouriteGroceryProduct(groceryId, productId);
    _favouriteProductList.map((product) {
      if (product.groceryID == groceryId && product.id == productId) {
        _favouriteProductList.remove(product);
      }
    });
    notifyListeners();
  }
}
