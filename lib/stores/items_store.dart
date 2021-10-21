import 'package:farmacia/model/product.dart';
import 'package:mobx/mobx.dart';
part 'items_store.g.dart';

class ItemsStore = _ItemsStoreBase with _$ItemsStore;

abstract class _ItemsStoreBase with Store {
  _ItemsStoreBase(this.product);

  final Product product;

  @observable
  int quantity = 1;

  @computed
  double get total => quantity * product.price;

  @action
  void increment() {
    quantity++;
  }

  @action
  void decrement() {
    if (quantity > 1) {
      quantity--;
    }
  }

  @override
  int get hashCode => product.hashCode;

  @override
  bool operator ==(other) => other is ItemsStore && other.product == product;
}
