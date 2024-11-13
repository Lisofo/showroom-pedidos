import 'dart:convert';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/config/config.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/widgets/carteles.dart';


class LoginServices {
  int? statusCode;
  late String apiUrl = Config.APIURL;
  late String apiLink = '$apiUrl/api/auth/loginPin2';

  Future<void> login(String login, password, BuildContext context) async {
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode({
      "login": login, 
      "pin2": password,
      "modulo": 'pedidos_sr'
    });
    var dio = Dio();
    String link = apiLink;
    try {
      var response = await dio.request(
        link,
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      statusCode = 1;

      if (statusCode == 1) {
        print(response.data['token']);
        print(response.data['vendedorId']);
        Provider.of<ItemProvider>(context, listen: false).setToken(response.data['token']);
        Provider.of<ItemProvider>(context, listen: false).setVendedorId(response.data['vendedorId'] ?? 0);
      } else { 
        print(response.statusMessage);
      }
    } catch (e) {
      statusCode = 0;
      print('Error: $e');
    }
  }

  Future pin2(pin2, BuildContext context) async {
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode({"pin2": pin2});
    var dio = Dio();
    String link =  '$apiUrl/api/auth/pin';
    try {
      var response = await dio.request(
        link,
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      statusCode = 1;

      if (statusCode == 1) {
        print(response.data['token']);
        Provider.of<ItemProvider>(context, listen: false).setToken2(response.data['token']);
        //Provider.of<ItemProvider>(context, listen: false).setUsuarioId(response.data['uid']);
        //Provider.of<ItemProvider>(context, listen: false).setNombreUsuario(response.data['name']);
        //Provider.of<ItemProvider>(context, listen: false).setTecnicoId(response.data['tecnicoId']);
      } else {
        print(response.statusMessage);
      }
      return response.data['token'];
    } catch (e) {
      statusCode = 0;
      if (e is DioException) {
        if (e.response != null) {
          statusCode = e.response!.statusCode;
          final responseData = e.response!.data;
          if (responseData != null) {
            if(e.response!.statusCode == 403){
              Carteles.showErrorDialog(context, 'Error: ${e.response!.data['message']}');
            }else if(e.response!.statusCode! >= 500) {
              Carteles.showErrorDialog(context, 'Error: No se pudo completar la solicitud');
            // } else{
            //   final errors = responseData['errors'] as List<dynamic>;
            //   final errorMessages = errors.map((error) {
            //   return "Error: ${error['message']}";
            // }).toList();
            // Carteles.showErrorDialog(context, errorMessages.join('\n'));
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

  Future<int?> getStatusCode() async {
    return statusCode;
  }
}