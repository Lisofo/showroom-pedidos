import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:showroom_maqueta/config/config.dart';
import 'package:showroom_maqueta/models/pedido.dart';

class PedidosServices {
  final _dio = Dio();
  late String apirUrl = Config.APIURL;
  late int? statusCode;

  Future getPedidosCliente (BuildContext context, int clienteId, String almacen, String token) async {
    String link = '$apirUrl/api/v1/pedidos?clienteId=$clienteId&almacenId=$almacen';
    try {
      var headers = {'Authorization': token};
      var resp = await _dio.request(
        link,
        options: Options(
          method: 'GET',
          headers: headers,
        )
      );
      statusCode = 1;
      final List<dynamic> pedidosList = resp.data;
      return pedidosList.map((obj) => Pedido.fromJson(obj)).toList();
    } catch (e) {
      return e;
    }
  }
}