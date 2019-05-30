import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './product_edit.dart';
import '../scoped_models/main.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;

  ProductListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductListPageState();
  }
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  initState() {
    super.initState();
    widget.model.fetchProducts();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(index);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductEditPage();
            },
          ),
        ).then((_) {
          model.selectProduct(null);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(model.allProducts[index].title),
              background: Container(
                color: Colors.red,
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (DismissDirection direction) {
                model.selectProduct(index);
                model.deleteProduct();
              },
              child: Column(
                children: <Widget>[
                  ListTile(
                    contentPadding:
                        EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                    leading: CircleAvatar(
                      // backgroundImage: AssetImage(model.allProducts[index].image),
                      backgroundImage:
                          NetworkImage(model.allProducts[index].image),
                    ),
                    title: Text(model.allProducts[index].title),
                    subtitle:
                        Text('\$${model.allProducts[index].price.toString()}'),
                    trailing: _buildEditButton(context, index, model),
                  ),
                  Divider(),
                ],
              ),
            );
          },
          itemCount: model.allProducts.length,
        );
      },
    );
  }
}
