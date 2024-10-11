import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:showroom_maqueta/config/config.dart';
import 'package:showroom_maqueta/models/linea.dart';

class LineasServices {
  final _dio = Dio();
  late String apirUrl = Config.APIURL;
  late int? statusCode;

  Future getLineasOrden (BuildContext context, int pedidoId, String token) async {
    String link =  '$apirUrl/api/v1/pedidos/$pedidoId/lineas';

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
      final List<dynamic> lineasList = resp.data;
      return lineasList.map((obj) => Linea.fromJson(obj)).toList();
    } catch (e) {
      return e;
    } 
  }
}