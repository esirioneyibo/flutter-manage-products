import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './price_tag.dart';
import './address_tag.dart';
import '../ui_elements/title_default.dart';
import '../../models/product.dart';
import '../../scoped_models/main.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Container _buildTitlePriceRow() {
    return Container(
        // margin: EdgeInsets.all(10.0),
        // margin: EdgeInsets.symmetric(vertical: 10.0),
        // margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleDefault(product.title),
            SizedBox(width: 8.0),
            PriceTag(product.price.toString())
          ],
        ));
  }

  ButtonBar _buildActionButtons(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.pushNamed<bool>(
              context, '/product/' + productIndex.toString()),
        ),
        ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return IconButton(
              icon: Icon(model.allProducts[productIndex].isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Colors.red,
              onPressed: () {
                model.selectProduct(productIndex);
                model.toggleProductFavoriteStatus();
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          // Image.asset(product.image),
          Image.network(product.image),
          // SizedBox(height: 10.0,),
          // Padding(
          //   padding: EdgeInsets.only(top: 10.0),
          //   child: Text(product['title']),
          // ),
          _buildTitlePriceRow(),
          AddressTag('Union Square, San Francisco'),
          Text(product.userEmail),
          // FlatButton is a button without background color
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
