import 'package:farmacia/stores/items_store.dart';
import 'package:farmacia/stores/compra_store.dart';
import 'package:farmacia/stores/vitrine_store.dart';
import 'package:farmacia/views/items_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class VitrineView extends StatefulWidget {
  @override
  _VitrineViewState createState() => _VitrineViewState();
}

class _VitrineViewState extends State<VitrineView> {
  VitrineStore _vitrineStore;
  CompraStore _compraStore;

  @override
  void initState() {
    _vitrineStore = new VitrineStore();
    _compraStore = new CompraStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Observer(
        builder: (_) {
          final items = _vitrineStore.products.value;
          if (_vitrineStore.hasError)
            return const Center(
              child: Text("Ocorreu um erro"),
            );
          else if (_vitrineStore.loading)
            return const Center(
              child: CircularProgressIndicator(),
            );
          else
            return RefreshIndicator(
              onRefresh: () async {
                _vitrineStore.reload();
              },
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, int index) {
                  final product = items[index];
                  return Observer(
                    builder: (_) {
                      return ListTile(
                        leading: _compraStore.contains(product)
                            ? const Icon(
                                Icons.remove_shopping_cart,
                                color: Colors.blueAccent,
                              )
                            : const Icon(
                                Icons.add_shopping_cart,
                                color: Colors.blueAccent,
                              ),
                        onTap: () {
                          if (_compraStore.contains(product)) {
                            _compraStore.remove(ItemsStore(product));
                          } else {
                            _compraStore.add(product);
                          }
                        },
                        title: Text("${product.name}"),
                        subtitle: Text(
                          "BRL ${product.price.toStringAsFixed(2)}",
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
        child: const Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => ItemsView(
                compraStore: _compraStore,
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Observer(
        builder: (_) {
          return Text("Total: BRL ${_compraStore.total.toStringAsFixed(2)}");
        },
      ),
      actions: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Container(
              height: 150.0,
              width: 30.0,
              child: new GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => ItemsView(
                        compraStore: _compraStore,
                      ),
                    ),
                  );
                },
                child: new Stack(
                  children: <Widget>[
                    new IconButton(
                      icon: new Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      onPressed: null,
                    ),
                    Positioned(
                      child: new Stack(
                        children: <Widget>[
                          new Icon(
                            Icons.brightness_1,
                            size: 20.0,
                            color: Colors.blue[100],
                          ),
                          new Positioned(
                            top: 3.0,
                            right: 6.0,
                            child: new Center(
                              child: Observer(
                                builder: (_) {
                                  return new Text(
                                    '${_compraStore.countItems}',
                                    style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
