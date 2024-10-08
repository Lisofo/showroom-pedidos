import 'package:dio/dio.dart';
import 'package:showroom_maqueta/config/config.dart';
import 'package:showroom_maqueta/models/producto_variante.dart';
// import 'package:showroom_maqueta/offline/boxes.dart';
// almancenId 1 = nyp
// almancenId 18 = ufo
import '../models/product.dart';

class ProductServices {
  final _dio = Dio();
  late String apirUrl = Config.APIURL;
  Future<List<Product>> getProductByName(String raiz, String codTipoLista, String almacenId, String descripcion, String offset, String token) async {
    String link = apirUrl += '/api/v1/itemsRaiz/?limit=20&offset=$offset&sort=raiz desc';
    bool yaTieneFiltro = true;
    if (raiz != '') {
      link += '&raiz=$raiz';
      yaTieneFiltro = true;
    }
    if (codTipoLista != '') {
      yaTieneFiltro ? link += '&' : link += '?';
      link += 'codTipoLista=$codTipoLista';
      yaTieneFiltro = true;
    }
    if (almacenId != '') {
      yaTieneFiltro ? link += '&' : link += '?';
      link += 'almacenId=$almacenId';
      yaTieneFiltro = true;
    }
    if (descripcion != '') {
      yaTieneFiltro ? link += '&' : link += '?';
      link += 'descripcion=$descripcion';
      yaTieneFiltro = true;
    }
    try {
      var headers = {'Authorization': token};
      var resp = await _dio.request(link,
        options: Options(
          method: 'GET',
          headers: headers,
        )
      );
      
      final List<dynamic> productList = resp.data;
      return productList.map((obj) => Product.fromJson(obj)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Product>> getProductByVariant(String raiz, String codAlmacen, String token, String codTipoLista) async {
    String link = apirUrl += '/api/v1/servicios/variantesItem/$raiz?codAlmacen=$codAlmacen&mismoColor=n&codTipoLista=$codTipoLista';

    try {
      var headers = {'Authorization': token};
      var resp = await _dio.request(link,
        options: Options(
          method: 'GET',
          headers: headers,
        )
      );
      final List<dynamic> productList = resp.data;
      return productList.map((obj) => Product.fromJson(obj)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }


  Future<Product> getSingleProductByRaiz(String raiz, String codAlmacen, String token) async {
    String link = apirUrl +='/api/v1/servicios/itemsRaiz/$raiz?codAlmacen=$codAlmacen';

    try {
      var headers = {'Authorization': token};
      var resp = await _dio.request(link,
          options: Options(
            method: 'GET',
            headers: headers,
          ));
      final Product product = Product.fromJson(resp.data);
      return product;
    } catch (e) {
      print(e);
      return Product.empty();
    }
  }

  //  Future<List> getProductByVariantOffline(String raiz, String codAlmacen) async{
  //   List<dynamic> listProductoRaiz = [];
  //   Product productoSeleccionado = Product.empty();
  //   Product productoTest = Product(codAlmacen: codAlmacen, raiz: raiz, descripcion: 'descripcion', monedaId: 30, memo: 'test', signo: '%', precioVentaActual: 33, precioIvaIncluido: 35, ivaId: 2, valor: 22, disponibleRaiz: 4, existenciaRaiz: 6, variantes: [ProductoVariante(itemId: 333, codItem: 'codigoItem', monedaId: 2, signo: '##', precioVentaActual: 12, precioIvaIncluido: 15, existenciaActual: 2, existenciaTotal: 5, ivaId: 3, valor: 44, codColor: 'codColor', color: 'color', talle: 'talles', disponible: 3, colorHexCode: 255, r: 200, g: 100, b: 150),]);
  //   try{
  //     listProductoRaiz = boxProduct.values.where((producto) => 
  //     (producto.raiz.toUpperCase() == raiz)).toList();

  //     productoSeleccionado = listProductoRaiz[0];
  //     //return productoSeleccionado.variantes;
  //     return productoTest.variantes;
  //   }
  //   catch (e) {
  //     return [];
  //   }
  //  }

  Future<List<Product>> getAllProducts(String codAlmacen, String token) async {
    String link = apirUrl += '/api/v1/servicios/itemsRaiz/Todos/?codAlmacen=$codAlmacen';
    try {
      var headers = {'Authorization': token};
      var resp = await _dio.request(link,
          options: Options(
            method: 'GET',
            headers: headers,
          ));
      final List<dynamic> productList = resp.data;
      return productList.map((obj) => Product.fromJson(obj)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }


//   Future<List> getProductByNameOffline(String query) async{
//       List<dynamic> listaRet = [];
//       listaRet = boxProduct.values.where((producto) 
//       => (producto.descripcion.toUpperCase() + ' ' + producto.raiz.toUpperCase()).contains(query.toUpperCase())).toList();
//       return listaRet;

//   }

  

//   Future<List> getProductsByVariantOffline (String scanned) async {
//     List<dynamic> listaRet = [];
//     try{
//       listaRet = boxProduct.values.where((producto) => (producto.variantes.codItem.toUpperCase()).contains(scanned.toUpperCase())).toList();
//       return listaRet;
//     }
//     catch(e){ 
//       return [];
//     }
//   }


// Future<List<dynamic>> getProductsOfflineFinal (String dato)async{
//   List<dynamic>listaProductos = boxProduct.values.toList();
//   List<String> datos = dato.split(' ');
//   for(int i = 0; i< datos.length; i++){
//     listaProductos = busquedaProductosRecursiva(listaProductos, datos[i]);
    
//   }
//   return listaProductos;
// }



List<dynamic> busquedaProductosRecursiva (List<dynamic> lista, String dato){
  dato = dato.toUpperCase();
  lista = lista.where((producto) => producto.raiz.toUpperCase().contains(dato) || producto.descripcion.toUpperCase().contains(dato) || 
  producto.variantes.any((ProductoVariante variante) => variante.codItem.toUpperCase().contains(dato))).toList();
  return lista;
}


// Future<List<dynamic>> getProductsByEverythingOffline(String dato) async {
//   try {
//     final List<dynamic> productos = boxProduct.values.toList();
//     final List<dynamic> matchingProducts = [];

//     // Search for matching products based on description and raiz
//     matchingProducts.addAll(productos.where((producto) =>
//         (producto.descripcion.toUpperCase() + ' ' + producto.raiz.toUpperCase()).contains(dato.toUpperCase())));

//     // If no matches found, search based on talle
//     if (matchingProducts.isEmpty) {
//       matchingProducts.addAll(productos.where((producto) =>
//           producto.variantes.any((ProductoVariante variante) =>
//               variante.codItem.toUpperCase().contains(dato.toUpperCase()))));
//     }

//     return matchingProducts;
//   } catch (e) {
//     print(e);
//     return [];
//   }
// }








}
