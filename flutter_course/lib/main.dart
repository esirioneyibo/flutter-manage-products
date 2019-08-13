import "package:flutter/material.dart";
import 'package:flutter_course/models/product.dart';
import "package:scoped_model/scoped_model.dart";
// import "package:flutter/rendering.dart";
import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './scoped_models/main.dart';
import './models/product.dart';

// A shoter funtion notation, using only if you have 1 statement
void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

// Change class MyApp from extending StatelessWidget to extending StatefulWidget
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();

  @override
  void initState() {
    super.initState();
    _model.autoAuthenticate();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        // debugShowMaterialGrid: true,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            // fontFamily: 'Oswald',
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            buttonColor: Colors.deepPurple),
        // home: AuthPage(),
        routes: {
          '/admin': (BuildContext context) => ProductsAdminPage(_model),
          // '/' is the same with home:, so if defined '/', we shouldn't use home: like above (home: AuthPage())
          '/': (BuildContext context) => _model.user == null ? AuthPage() : ProductsPage(_model),
          '/products': (BuildContext context) => ProductsPage(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements =
              settings.name.split('/'); // Ex: /product/1 => '','product','1'

          if (pathElements[0] != '') {
            return null;
          }

          if (pathElements[1] == 'product') {
            // final int index = int.parse(pathElements[2]);
            final String productId = pathElements[2];
            final Product product =
                _model.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            // because we want the product page will return boolean value so we have to use
            // MaterialPageRoute<bool>
            // In products.dart:
            // onPressed: () => Navigator.pushNamed<bool>(
            //                   context, '/product/' + index.toString())
            //               .then((bool value) {
            //             if (value) {
            //               deleteProduct(index);
            //             }
            //           }),
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  // ProductPage(index),
                  // ProductPage(productId),
                  ProductPage(product),
            );
          }

          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(_model));
        },
      ),
    );
  }
}
