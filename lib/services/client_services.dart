import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:showroom_maqueta/config/config.dart';
import 'package:showroom_maqueta/models/client.dart';

class ClientServices {
  final _dio = Dio();
  late String apirUrl = Config.APIURL;
  late int? statusCode;

  Future getClientes (BuildContext context, String nombre, String ruc, String codCliente, String almacen, int vendedorId, String token) async {
    String link =  '$apirUrl/api/v1/clientes?vendedorId=$vendedorId';
    bool yaTieneFiltro = true;
    if (nombre != '') {
      link += '&nombre=$nombre';
      yaTieneFiltro = true;
    }
    if (codCliente != '') {
      yaTieneFiltro ? link += '&' : link += '?';
      link += 'codCliente=$codCliente';
      yaTieneFiltro = true;
    }
   

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
      final List<dynamic> clientList = resp.data;
      return clientList.map((obj) => Client.fromJson(obj)).toList();
    } catch (e) {
      return e;
    }
  }
}