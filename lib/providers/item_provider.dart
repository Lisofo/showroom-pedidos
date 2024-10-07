import 'package:flutter/material.dart';
import 'package:showroom_maqueta/models/client.dart';
import 'package:showroom_maqueta/models/pedido.dart';

import '../models/product.dart';

class ItemProvider with ChangeNotifier {
  String _item = '';
  String get item => _item;

  String _query = '';
  String get query => _query;
  
  int _vendedorId = 0;
  int get vendedorId => _vendedorId;

  void setVendedorId (int seller) {
    _vendedorId = seller;
    notifyListeners();
  }

  void setQuery (String query){
    _query = query;
    notifyListeners();
  }
  
  void setItem(String codigo) {
    _item = codigo;
    notifyListeners();
  }

  int _imageIndex = 0;
  int get imageIndex => _imageIndex;

  void setImageIndex (int index){
    _imageIndex = index;
    notifyListeners();
  }
  
  Product _product = Product.empty();
  Product get product => _product;

  void setProduct(Product prod) {
    _product = prod;
    notifyListeners();
  }

  Client _client = Client.empty();
  Client get client => _client;

  void setClient(Client cliente) {
    _client = cliente;
    notifyListeners();
  }

  String _almacen = '';
  String get almacen => _almacen;
  
  void setAlmacen(String codAlmacen){
    _almacen = codAlmacen;
    notifyListeners();
  }

  String _mismoColor = '';
  String get mismoColor => _mismoColor;

  void setColor(String color){
    _mismoColor = color;
    notifyListeners();
  }
  String _token = '';
  String get token => _token;

  void setToken(String tok) {
    _token = tok;
    notifyListeners();
  }
  Pedido _pedido = Pedido.empty();
  Pedido get pedido => _pedido;

  void setPedido(Pedido pedid) {
    _pedido = pedid;
    notifyListeners();
  }
}
