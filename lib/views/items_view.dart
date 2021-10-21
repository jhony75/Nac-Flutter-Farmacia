import 'package:farmacia/model/product.dart';
import 'package:farmacia/services/product_service.dart';
import 'package:farmacia/stores/compra_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ItemsView extends StatefulWidget {
  final CompraStore compraStore;

  const ItemsView({Key key, this.compraStore}) : super(key: key);

  @override
  _ItemsViewState createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  List<Product> items;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(builder: (_) {
          return Text("${widget.compraStore.total.toStringAsFixed(2)}");
        }),
      ),
      body: Observer(
        builder: (_) {
          final items = widget.compraStore.selectedItems;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              separatorBuilder: (_, index) => const SizedBox(height: 10),
              itemCount: items.length,
              itemBuilder: (_, int index) {
                final item = items[index];
                return Observer(
                  builder: (_) {
                    return Dismissible(
                      onDismissed: (direction) {
                        widget.compraStore.remove(item);
                      },
                      key: UniqueKey(),
                      child: Container(
                        height: 120,
                        padding: const EdgeInsets.only(bottom: 20, top: 20),
                        color: Colors.blue[200],
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              height: 100,
                              width: 100,
                              color: Colors.blueAccent,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Nome: ${item.product.name}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                    'Preço: BRL ${item.product.price.toStringAsFixed(2)}'),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        item.decrement();
                                      },
                                    ),
                                    Text("${item.quantity}"),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        item.increment();
                                      },
                                    )
                                  ],
                                ),
                                Text(
                                    "Total: BRL ${item.total.toStringAsFixed(2)}")
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
