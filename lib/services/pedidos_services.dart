import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/config/config.dart';
import 'package:showroom_maqueta/models/linea.dart';
import 'package:showroom_maqueta/models/pedido.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';

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

  Future<int?> getStatusCode () async {
    return statusCode;
  }

  Future<void> resetStatusCode () async {
    statusCode = null;
  }

  Future postPedido (BuildContext context, Pedido pedido, String token) async {
    String link = '$apirUrl/api/v1/pedidos';
    var data = ({
      "numeroOrdenTrabajo": pedido.numeroOrdenTrabajo,
    	"fechaOrdenTrabajo": _formatFechas(pedido.fechaOrdenTrabajo),
    	"fechaVencimiento": pedido.fechaVencimiento == null ? null : _formatFechas(pedido.fechaVencimiento),
    	"fechaEntrega": pedido.fechaEntrega == null ? null :  _formatFechas(pedido.fechaEntrega),
    	"descripcion": pedido.descripcion,
    	"esPlantilla": false,
    	"clienteId": pedido.clienteId,
    	"unidadId": 0,
    	"monedaId": pedido.monedaId,
    	"transaccionId": pedido.transaccionId,
    	"comentarioCliente": pedido.comentarioCliente,
    	"comentarioTrabajo": pedido.comentarioTrabajo,
      "lineas": []
    });
    try {
      var headers = {'Authorization': token};
      var resp = await _dio.request(
        link,
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data
      );
      statusCode = 1;
      if(resp.statusCode == 200){
        pedido.ordenTrabajoId = resp.data['ordenTrabajoId'];
      }
    } catch (e) {
      return e;
    }
  }

  Future putPedido (BuildContext context, Pedido pedido, List<Linea> lineas, String token) async {
    String link = '$apirUrl/api/v1/pedidos/${pedido.ordenTrabajoId}';
    var accionesLineas = [];
    for(var linea in lineas){
      if (linea.metodo == 'POST' && linea.lineaId == 0) {
        accionesLineas.add({
          "metodo": "POST",
          "itemId": linea.itemId,
          "ordinal": linea.ordinal,
          "cantidad": linea.cantidad,
          "costoUnitario": linea.costoUnitario,
          "descuento1": linea.descuento1,
          "descuento2": linea.descuento2,
          "descuento3": linea.descuento3,
          "comentario": linea.comentario,
        });
      } else if (linea.metodo == 'PUT' && linea.lineaId != 0) {
        accionesLineas.add({
          "metodo": "PUT",
          "lineaId": linea.lineaId,
          "ordinal": linea.ordinal,
          "cantidad": linea.cantidad,
          "costoUnitario": linea.costoUnitario,
          "descuento1": linea.descuento1,
          "descuento2": linea.descuento2,
          "descuento3": linea.descuento3,
          "comentario": linea.comentario,
        });
      } else if (linea.metodo == 'DELETE') {
        accionesLineas.add({
          "metodo": "DELETE",
          "lineaId": linea.lineaId,
        });
      }
    }
    var data = ({
    	"fechaOrdenTrabajo": _formatFechas(pedido.fechaOrdenTrabajo),
    	"fechaVencimiento": pedido.fechaVencimiento == null ? null : _formatFechas(pedido.fechaVencimiento),
    	"fechaEntrega": pedido.fechaEntrega == null ? null :  _formatFechas(pedido.fechaEntrega),
    	"descripcion": pedido.descripcion,
    	"esPlantilla": false,
    	"monedaId": pedido.monedaId,
    	"transaccionId": pedido.transaccionId,
    	"comentarioCliente": pedido.comentarioCliente,
    	"comentarioTrabajo": pedido.comentarioTrabajo,
      "lineas": accionesLineas
    });
    print(jsonEncode(data));
    try {
      var headers = {'Authorization': token};
      var resp = await _dio.request(
        link,
        options: Options(
          method: 'PUT',
          headers: headers,
        ),
        data: data
      );
      statusCode = 1;
      if(resp.statusCode == 200){
        if (resp.data != null) {
          for(int i = 0; i < lineas.length; i++){
            if(lineas[i].lineaId == 0){
              lineas[i].lineaId = resp.data["lineas"][i]['lineaId'];
              print('id asignado: ${lineas[i].lineaId}');
              // Provider.of<ItemProvider>(context, listen: false).setLineasGenericas(resp.data['lineas'] as List<Linea>);
            }
            if(lineas[i].metodo == "DELETE") {
              Provider.of<ItemProvider>(context, listen: false).removeLinea(lineas[i]);
            }
          }
        }
      }
    } catch (e) {
      statusCode = 0;
      return e;
    }
  }

  Future patchPedido(BuildContext context, int ordenId, int accionId, String token) async {
    String link = '$apirUrl/api/v1/ordenes/$ordenId';

    try {
      var headers = {'Authorization': token};
      var data = ({"accionId": accionId});
      var resp = await _dio.request(
        link,
        options: Options(
          method: 'PATCH',
          headers: headers,
        ),
        data: data
      );

      statusCode = 1;
      return resp;
    } catch (e) {
      statusCode = 0;
      if (e is DioException) {
        // if (e.response != null) {
        //   final responseData = e.response!.data;
        //   if (responseData != null) {
        //     if(e.response!.statusCode == 403){
        //       showErrorDialog(context, 'Error: ${e.response!.data['message']}');
        //     }else if(e.response!.statusCode! >= 500) {
        //       showErrorDialog(context, 'Error: No se pudo completar la solicitud');
        //     } else{
        //       final errors = responseData['errors'] as List<dynamic>;
        //       final errorMessages = errors.map((error) {
        //         return "Error: ${error['message']}";
        //       }).toList();
        //       showErrorDialog(context, errorMessages.join('\n'));
        //     }
        //   } else {
        //     showErrorDialog(context, 'Error: ${e.response!.data}');
        //   }
        // } else {
        //   showErrorDialog(context, 'Error: No se pudo completar la solicitud');
        // } 
      } 
    }
  }


  String _formatFechas(DateTime? date) {
    return '${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}';
  }
}