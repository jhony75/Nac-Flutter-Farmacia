import 'package:farmacia/model/product.dart';
import 'package:farmacia/services/product_service.dart';
import 'package:mobx/mobx.dart';
part 'vitrine_store.g.dart';

class VitrineStore = _VitrineStoreBase with _$VitrineStore;

abstract class _VitrineStoreBase with Store {
  String version = '';

  ProductService _productService = new ProductService();

  _VitrineStoreBase() {
    reload();
  }

  @observable
  ObservableFuture<List<Product>> products = ObservableFuture.value(null);

  @computed
  bool get loading => products.status == FutureStatus.pending;

  @computed
  bool get hasError => products.error != null;

  @action
  void reload() {
    products = _productService.findAll().asObservable();
  }
}
