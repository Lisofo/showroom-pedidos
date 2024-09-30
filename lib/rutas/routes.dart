import 'package:flutter/material.dart';
import 'package:showroom_maqueta/pages/seleccion_origen.dart';
import '../pages/agregar_a_pedido.dart';
import '../pages/buscador_cliente.dart';
import '../pages/home_page.dart';
import '../pages/nuevo_pedido.dart';
import '../pages/pagina_checkout.dart';
import '../pages/pagina_cliente.dart';
import '../pages/pedido_interno.dart';
import '../pages/product_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => HomePage(),
    'agregarAPedido' : (BuildContext context) => AgregarPedido(),
    'buscadorCliente' : (BuildContext context) => BuscadorCliente(),
    'nuevoPedido' : (BuildContext context) => NuevoPedido(),
    'checkout' : (BuildContext context) => PaginaCheckout(),
    'paginaCliente': (BuildContext context) => PaginaCliente(),
    'pedidoInterno' : (BuildContext context) => PedidoInterno(),
    'paginaProducto' : (BuildContext context) => ProductPage(),
    'origen' : (BuildContext context) => SeleccionOrigen(),
  };
}
