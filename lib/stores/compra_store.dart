import 'package:farmacia/model/product.dart';
import 'package:farmacia/stores/items_store.dart';
import 'package:mobx/mobx.dart';
part 'compra_store.g.dart';

class CompraStore = _CompraStoreBase with _$CompraStore;

abstract class _CompraStoreBase with Store {
  @observable
  ObservableList<ItemsStore> selectedItems = <ItemsStore>[].asObservable();

  @computed
  int get countItems => selectedItems.length;

  @computed
  double get total => selectedItems.fold(
      0, (previousValue, element) => previousValue + element.total);

  @action
  void add(Product product) {
    selectedItems.add(ItemsStore(product));
  }

  @action
  void remove(ItemsStore item) {
    selectedItems.remove(item);
  }

  bool contains(Product product) {
    if (selectedItems.contains(ItemsStore(product))) {
      return true;
    }
    return false;
  }
}
