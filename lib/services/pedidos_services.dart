import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/config/config.dart';
import 'package:showroom_maqueta/models/linea.dart';
import 'package:showroom_maqueta/models/pedido.dart';
import 'package:showroom_maqueta/models/reporte.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/widgets/carteles.dart';

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
      statusCode = 0;
      if (e is DioException) {
        if (e.response != null) {
          final responseData = e.response!.data;
          if (responseData != null) {
            if(e.response!.statusCode == 403){
             Carteles.showErrorDialog(context, 'Error: ${e.response!.data['message']}');
            }else if(e.response!.statusCode! >= 500) {
              Carteles.showErrorDialog(context, 'Error: No se pudo completar la solicitud');
            } else{
              final errors = responseData['errors'] as List<dynamic>;
              final errorMessages = errors.map((error) {
                return "Error: ${error['message']}";
              }).toList();
              Carteles.showErrorDialog(context, errorMessages.join('\n'));
            }
          } else {
            Carteles.showErrorDialog(context, 'Error: ${e.response!.data}');
          }
        } else {
          Carteles.showErrorDialog(context, 'Error: No se pudo completar la solicitud');
        } 
      }
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
      statusCode = 0;
      if (e is DioException) {
        if (e.response != null) {
          final responseData = e.response!.data;
          if (responseData != null) {
            if(e.response!.statusCode == 403){
             Carteles.showErrorDialog(context, 'Error: ${e.response!.data['message']}');
            }else if(e.response!.statusCode! >= 500) {
              Carteles.showErrorDialog(context, 'Error: No se pudo completar la solicitud');
            } else{
              final errors = responseData['errors'] as List<dynamic>;
              final errorMessages = errors.map((error) {
                return "Error: ${error['message']}";
              }).toList();
              Carteles.showErrorDialog(context, errorMessages.join('\n'));
            }
          } else {
            Carteles.showErrorDialog(context, 'Error: ${e.response!.data}');
          }
        } else {
          Carteles.showErrorDialog(context, 'Error: No se pudo completar la solicitud');
        } 
      }
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
          final List<dynamic> lineasList = resp.data['lineas'];
          List<Linea> list = lineasList.map((obj) => Linea.fromJson(obj)).toList();
          // for(int i = 0; i < lineas.length; i++){
          //   if(lineas[i].lineaId == 0){
          //     lineas[i].lineaId = resp.data["lineas"][i]['lineaId'];
          //     print('id asignado: ${lineas[i].lineaId}');
          //   }
          //   if(lineas[i].metodo == "DELETE") {
          //     Provider.of<ItemProvider>(context, listen: false).removeLinea(lineas[i]);
          //   }
          // }
          Provider.of<ItemProvider>(context, listen: false).setLineasGenericas(list);
        }
      }
    } catch (e) {
      statusCode = 0;
      if (e is DioException) {
        if (e.response != null) {
          final responseData = e.response!.data;
          if (responseData != null) {
            if(e.response!.statusCode == 403){
             Carteles.showErrorDialog(context, 'Error: ${e.response!.data['message']}');
            }else if(e.response!.statusCode! >= 500) {
              Carteles.showErrorDialog(context, 'Error: No se pudo completar la solicitud');
            } else{
              final errors = responseData['errors'] as List<dynamic>;
              final errorMessages = errors.map((error) {
                return "Error: ${error['message']}";
              }).toList();
              Carteles.showErrorDialog(context, errorMessages.join('\n'));
            }
          } else {
            Carteles.showErrorDialog(context, 'Error: ${e.response!.data}');
          }
        } else {
          Carteles.showErrorDialog(context, 'Error: No se pudo completar la solicitud');
        } 
      }
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
        if (e.response != null) {
          final responseData = e.response!.data;
          if (responseData != null) {
            if(e.response!.statusCode == 403){
             Carteles.showErrorDialog(context, 'Error: ${e.response!.data['message']}');
            }else if(e.response!.statusCode! >= 500) {
              Carteles.showErrorDialog(context, 'Error: No se pudo completar la solicitud');
            } else{
              final errors = responseData['errors'] as List<dynamic>;
              final errorMessages = errors.map((error) {
                return "Error: ${error['message']}";
              }).toList();
              Carteles.showErrorDialog(context, errorMessages.join('\n'));
            }
          } else {
            Carteles.showErrorDialog(context, 'Error: ${e.response!.data}');
          }
        } else {
          Carteles.showErrorDialog(context, 'Error: No se pudo completar la solicitud');
        } 
      }
    }
  }

  Future postInforme (BuildContext context, String almacenId, Pedido pedido, bool conFoto, String token) async {
    String link = '$apirUrl/api/v1/rpts';
    int informeId = 0;
    if(conFoto){
      if(almacenId == '1'){
        informeId = Config.NYPCONFOTO;
      } else {
        informeId = Config.UFOCONFOTO;
      }
    } else {
      if(almacenId == '1'){
        informeId = Config.NYPSINFOTO;
      } else {
        informeId = Config.UFOSINFOTO;
      }
    }
    var data = ({
      "informeId": informeId,
      "almacenId": int.tryParse(almacenId),
      "tipoImpresion": "PDF",
      "destino": 0,
      "destFileName": null,
      "destImpresora": null,
      "parametros": [
        {"p1": pedido.ordenTrabajoId},
      ]
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
        Provider.of<ItemProvider>(context, listen: false).setRptId(resp.data["rptGenId"]);
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future getReporte(BuildContext context, int reporteId, String token) async {
    String link = '$apirUrl/api/v1/rpts/$reporteId';
    try {
      var headers = {'Authorization': token};
      var resp = await _dio.request(
        link,
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      statusCode = 1;
      final Reporte reporte = Reporte.fromJson(resp.data);
      print(reporte.rptGenId);
      return reporte;

    } catch (e) {
      statusCode = 0;
      if (e is DioException) {
        if (e.response != null) {
          final responseData = e.response!.data;
          if (responseData != null) {
            if(e.response!.statusCode == 403){
             Carteles.showErrorDialog(context, 'Error: ${e.response!.data['message']}');
            }else if(e.response!.statusCode! >= 500) {
              Carteles.showErrorDialog(context, 'Error: No se pudo completar la solicitud');
            } else{
              final errors = responseData['errors'] as List<dynamic>;
              final errorMessages = errors.map((error) {
                return "Error: ${error['message']}";
              }).toList();
              Carteles.showErrorDialog(context, errorMessages.join('\n'));
            }
          } else {
            Carteles.showErrorDialog(context, 'Error: ${e.response!.data}');
          }
        } else {
          Carteles.showErrorDialog(context, 'Error: No se pudo completar la solicitud');
        } 
      }
    }
  }

  Future patchInforme(BuildContext context, Reporte reporte, String generado, String token) async {
    String link = '$apirUrl/api/v1/rpts/${reporte.rptGenId}';

    try {
      var headers = {'Authorization': token};
      var resp = await _dio.request(
        link,
        options: Options(
          method: 'PATCH',
          headers: headers,
        ),
      );

      statusCode = 1;
      return resp;
    } catch (e) {
      statusCode = 0;
      if (e is DioException) {
        if (e.response != null) {
          final responseData = e.response!.data;
          if (responseData != null) {
            if(e.response!.statusCode == 403){
             Carteles.showErrorDialog(context, 'Error: ${e.response!.data['message']}');
            }else if(e.response!.statusCode! >= 500) {
              Carteles.showErrorDialog(context, 'Error: No se pudo completar la solicitud');
            } else{
              final errors = responseData['errors'] as List<dynamic>;
              final errorMessages = errors.map((error) {
                return "Error: ${error['message']}";
              }).toList();
              Carteles.showErrorDialog(context, errorMessages.join('\n'));
            }
          } else {
            Carteles.showErrorDialog(context, 'Error: ${e.response!.data}');
          }
        } else {
          Carteles.showErrorDialog(context, 'Error: No se pudo completar la solicitud');
        } 
      }
    }
  }

  String _formatFechas(DateTime? date) {
    return '${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}';
  }
}