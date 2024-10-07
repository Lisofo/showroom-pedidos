// ignore_for_file: prefer_null_aware_operators

import 'package:showroom_maqueta/models/producto_variante.dart';

class Product {
  late int almacenId;
  late String raiz;
  late String descripcion;
  late int monedaId;
  late String memo;
  late String signo;
  late double precioVentaActualMin;
  late double precioVentaActualMax;
  late double precioIvaIncluidoMin;
  late double precioIvaIncluidoMax;
  late int ivaId;
  late int valor;
  late int disponibleRaiz;
  late int existenciaRaiz;
  late List<ProductoVariante>? variantes;
  late String imagenes;

  Product({
    required this.almacenId,
    required this.raiz,
    required this.descripcion,
    required this.monedaId,
    required this.memo,
    required this.signo,
    required this.precioVentaActualMin,
    required this.precioVentaActualMax,
    required this.precioIvaIncluidoMin,
    required this.precioIvaIncluidoMax,
    required this.ivaId,
    required this.valor,
    required this.disponibleRaiz,
    required this.existenciaRaiz,
    required this.variantes,
    required this.imagenes,
  });

  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      almacenId: json['almacenId'] as int? ?? 0,
      raiz: json['raiz'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
      monedaId: json['monedaId'] as int? ?? 0,
      memo: json['memo'] as String? ?? '',
      signo: json['signo'] as String? ?? '',
      precioVentaActualMin: json['precioVentaActualMin'] == null ? null : json['precioVentaActualMin'].toDouble(),
      precioVentaActualMax: json['precioVentaActualMax'] == null ? null : json['precioVentaActualMax'].toDouble(),
      precioIvaIncluidoMin: json['precioIvaIncluidoMin'] == null ? null : json['precioIvaIncluidoMin'].toDouble(),
      precioIvaIncluidoMax: json['precioIvaIncluidoMax'] == null ? null : json['precioIvaIncluidoMax'].toDouble(),
      ivaId: json['ivaId'] as int? ?? 0,
      valor: json['valor'] as int? ?? 0,
      disponibleRaiz: json['disponibleRaiz'] as int? ?? 0,
      existenciaRaiz: json['existenciaRaiz'] as int? ?? 0,
      variantes: json["variantes"] != null ? List<ProductoVariante>.from(json["variantes"].map((x)=> ProductoVariante.fromJson(x))).toList() : null,
      imagenes: json['fotosUrl'] as String? ?? '',
    );
  }

  Product.empty() {
    almacenId = 0;
    raiz = '';
    descripcion = '';
    monedaId = 0;
    memo = '';
    signo = '';
    precioVentaActualMin = 0.0;
    precioVentaActualMax = 0.0;
    precioIvaIncluidoMin = 0.0;
    precioIvaIncluidoMax = 0.0;
    ivaId = 0;
    valor = 0;
    disponibleRaiz = 0;
    existenciaRaiz = 0;
    variantes = [];
    imagenes = '';
  }

  @override
  String toString() {
    return 'Instance of Product: $descripcion';
  }
}

