// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/models/client.dart';
import 'package:showroom_maqueta/models/color.dart';
import 'package:showroom_maqueta/models/product.dart';
import 'package:showroom_maqueta/models/producto_variante.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/services/product_services.dart';


class ProductPage extends StatefulWidget {

  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late List<ProductoVariante>? _products = [];
  late String raiz = '';
  late String almacen = '';
  late String token = '';
  late Client cliente = Client.empty();
  var talles = <String>{};
  late List<ProductColor> colors;
  var priceMask = MaskTextInputFormatter(mask: '#######', filter: {"#": RegExp(r'[0-9.]')});
  var cantMask = MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')});
  late num cantidadTotal = 0;
  late double montoTotal = 0.0;
  Map<String, int> cantidadPorTalle = {};
  Map<String, String> cantidadAnteriorPorTalle = {};
  Product productoSeleccionado = Product.empty();
  Product productoNuevo = Product.empty();
  bool botonColorApretado = false;
  bool buscando = true;
  bool colorSeleccionado = false;
  bool hayConexion = false;
  List<ProductoVariante> productosFiltrados = [];

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  cargarDatos() async {
    // raiz = context.read<ItemProvider>().
    almacen = context.read<ItemProvider>().almacen;
    token = context.read<ItemProvider>().token;
    cliente = context.read<ItemProvider>().client;
    productoSeleccionado = context.read<ItemProvider>().product;
    productoNuevo = await ProductServices().getSingleProductByRaiz(productoSeleccionado.raiz, almacen, token);
    _products = productoNuevo.variantes;
    List<dynamic> listaTalles = _products!.where((productoVariante) => talles.add(productoVariante.talle)).toList();
    var models = <ProductColor>{};
    for (var i = 0; i < _products!.length; i++) {
      models.add(
        ProductColor(
          isSelected: false,
            nombreColor: _products![i].color,
            colorHexCode: _products![i].colorHexCode,
            r: _products![i].r,
            g: _products![i].g,
            b: _products![i].b,
            codColor: _products![i].codColor),
      );
    }
    colors = models.toSet().toList();
    buscando = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(productoSeleccionado.raiz),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              middleBody()
            ],
          ),
        ),
      )
    );
  }

  middleBody() {
    final colores = Theme.of(context).colorScheme;
    
    List<dynamic> listaTalles = _products!.where((talle) => talles.add(talle.talle)).toList();
    late String? talleSeleccionado; 
    return buscando ?  const Center(
        child: CircularProgressIndicator(),
      ) : _products!.isEmpty || _products == null ?
          const Center(child: Text('El Producto no existe', style: TextStyle(fontSize: 24))) 
          :  Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  ), //Colors.blueGrey[200]),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          productoSeleccionado.descripcion,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    showColorButtons(),
                    const SizedBox(height: 10,),
                    if (productosFiltrados.isNotEmpty) ...[
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          for (var producto in productosFiltrados) ...[
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(child: Text('Variante Seleccionada: ${producto.codItem}')),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: colores.primary,
                                    
                                  ),
                                );
                                
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(7)
                                ),
                                alignment: Alignment.center,
                                height: 80,
                                width: 70,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                  
                                    Text(
                                      producto.talle,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(height: 5,),
                                    const Divider(height: 2, thickness: 2,),
                                    const SizedBox(height: 5,),
                                    Text(
                                      producto.disponible.toString(),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      
                      ),
                      const SizedBox(height: 20,),
                    ],
                    Center(
                      child: Text(
                        productoSeleccionado.memo,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                    const SizedBox(height: 50,),
                  ]
                ),
            ),
          );         
  }

  Color getTextColor(Color backgroundColor) {
    var luminance = 0.2126 * backgroundColor.red +
        0.7152 * backgroundColor.green +
        0.0722 * backgroundColor.blue;
    // Decide si el texto debería ser oscuro o claro en función de la luminosidad
    return luminance > 128 ? Colors.black : Colors.white;
  }

  bool anyColorIsSelected(List<ProductColor> colors) {
    for (var color in colors){
      if (color.isSelected){
        return true;
      }
    }
    return false;
  }

  Wrap showColorButtons() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      children: [
        for (var color in colors)
          ElevatedButton.icon(
            icon: color.isSelected ? Icon(Icons.check, color: getTextColor(Color.fromARGB(255, color.r, color.g, color.b)),) : const SizedBox(),
            onPressed: () {
              setState(() {
                for (var c in colors) {
                  c.isSelected = false;
                }
                mostrarTalles2(color);
                color.isSelected = true;
              });
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, color.r, color.g, color.b)),
            ),
            label: Text(
              '${color.nombreColor} ${color.codColor}',
              style: TextStyle(
                fontSize: 25,
                color: getTextColor(Color.fromARGB(255, color.r, color.g, color.b)),
              ),
            ),
          ),
      ],
    );
  }

  mostrarTalles2(ProductColor color) {
    for (String talle in talles) {
      productosFiltrados = _products!.where((product) => product.color == color.nombreColor).toList();
    }
  }

}

