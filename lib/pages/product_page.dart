// ignore_for_file: must_be_immutable, unused_local_variable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/models/client.dart';
import 'package:showroom_maqueta/models/color.dart';
import 'package:showroom_maqueta/models/linea.dart';
import 'package:showroom_maqueta/models/pedido.dart';
import 'package:showroom_maqueta/models/product.dart';
import 'package:showroom_maqueta/models/producto_variante.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/services/pedidos_services.dart';
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
  List<ProductoVariante> productosAgregados = [];
  final ScrollController listController = ScrollController();
  List<bool> _isEditing = []; // Lista para controlar el estado de edición de cada producto
  int buttonIndex = 0;
  late Pedido pedido = Pedido.empty();

  @override
  void initState() {
    super.initState();
    cargarDatos();
    _isEditing = List<bool>.generate(productosAgregados.length, (index) => false); // Lista dinámica
  }

  cargarDatos() async {
    // raiz = context.read<ItemProvider>().
    almacen = context.read<ItemProvider>().almacen;
    token = context.read<ItemProvider>().token;
    cliente = context.read<ItemProvider>().client;
    pedido = context.read<ItemProvider>().pedido;
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
          codColor: _products![i].codColor
        ),
      );
    }
    colors = models.toSet().toList();
    buscando = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(productoSeleccionado.raiz),
          backgroundColor: colores.primary,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              middleBody(),
              SizedBox(
                height: 300,
                child: ListView.separated(
                  controller: listController,
                  itemCount: productosAgregados.length,
                  itemBuilder: (context, i) {
                    var item = productosAgregados[i];
                    return ListTile(
                      title: Text(item.codItem),
                      subtitle: Align(
                        alignment: Alignment.centerLeft,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1, 0), // Desde la derecha
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                          child: _isEditing[i]
                            ? TextFormField(
                                key: ValueKey('textFormField_$i'), // Clave única para cada `TextFormField`
                                initialValue: item.cantidad.toString(),
                                keyboardType: TextInputType.number,
                                onFieldSubmitted: (newValue) {
                                  setState(() {
                                    item.cantidad = int.parse(newValue);
                                    _isEditing[i] = false; // Salir del modo de edición
                                  });
                                },
                              )
                            : Text(
                                'cantidad: ${item.cantidad.toString()}',
                                key: ValueKey('text_$i'), // Clave única para el texto
                              ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              if(item.disponible <= 0){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Center(child: Text('No hay disponibles de esa variante')),
                                    duration: Duration(seconds: 2),                                    
                                  ),
                                );
                              } else{
                                setState(() {
                                  _isEditing[i] = !_isEditing[i]; // Cambiar el modo de edición
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                productosAgregados.removeAt(i); // Eliminar el producto
                                _isEditing.removeAt(i); // También eliminar el estado de edición correspondiente
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: buttonIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.save),
              label: 'Guardar'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.do_not_disturb),
              label: 'NO TOCAR'
            ),
          ],
          onTap: (value) async {
            buttonIndex = value;
            switch (buttonIndex) {
              case 0:
                var listaDeLineas = convertirProductosALineas(productosAgregados);
                await PedidosServices().putPedido(context, pedido, listaDeLineas, token);
              break;
              case 1:
                null;
              break;
            }
          },
        ),
      ),
    );
  }



  middleBody() {
    List<dynamic> listaTalles = _products!.where((talle) => talles.add(talle.talle)).toList();
    late String? talleSeleccionado;
    final colores = Theme.of(context).colorScheme; 
    return buscando ?  const Center(child: CircularProgressIndicator(),) : _products!.isEmpty || _products == null ?
          const Center(child: Text('El Producto no existe', style: TextStyle(fontSize: 24))) 
          :  Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),), //Colors.blueGrey[200]),
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
                              if(producto.disponible <= 0){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Center(child: Text('No hay disponibles de esa variante')),
                                    duration: Duration(seconds: 2),                                    
                                  ),
                                );
                              } else {
                                ProductoVariante? productoExistente = productosAgregados.firstWhere(
                                  (item) => item.codItem == producto.codItem,
                                  orElse: () => ProductoVariante.empty(), // Devolver ProductoVariante vacío si no se encuentra
                                );
                                int indexProducto;
                                if (productoExistente.codItem == producto.codItem) {
                                  // Si el producto ya existe, aumentar la cantidad
                                  if(productoExistente.cantidad < producto.disponible){
                                    setState(() {
                                      productoExistente.cantidad += 1;
                                    });
                                    
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Center(child: Text('No hay más disponibles de la variante ${producto.codItem}')),
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: colores.primary,
                                      ),
                                    );
                                  }
                                  indexProducto = productosAgregados.indexOf(productoExistente); // Índice del producto existente
                                } else {
                                  // Agregar nuevo producto a productosAgregados
                                  productosAgregados.add(
                                    ProductoVariante(
                                      itemId: producto.itemId,
                                      codItem: producto.codItem,
                                      monedaId: producto.monedaId,
                                      signo: producto.signo,
                                      precioVentaActual: producto.precioVentaActual,
                                      precioIvaIncluido: producto.precioIvaIncluido,
                                      existenciaActual: producto.existenciaActual,
                                      existenciaTotal: producto.existenciaTotal,
                                      ivaId: producto.ivaId,
                                      valor: producto.valor,
                                      codColor: producto.codColor,
                                      color: producto.color,
                                      talle: producto.talle,
                                      disponible: producto.disponible,
                                      colorHexCode: producto.colorHexCode,
                                      r: producto.r,
                                      g: producto.g,
                                      b: producto.b,
                                      imagenes: producto.imagenes,
                                      cantidad: 1, // Cantidad inicial
                                    ),
                                  );
                                  // Asegúrate de agregar un valor en _isEditing también
                                  _isEditing.add(false); // Indica que el nuevo producto no está en modo edición
                                  indexProducto = productosAgregados.length - 1; // Índice del nuevo producto
                                }
                                // Desplazar hacia el producto existente o nuevo
                                listController.animateTo(
                                  indexProducto * 70.0, // Ajusta 80.0 dependiendo de la altura del ítem
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                                setState(() {});
                              }
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
                  ],
                ]
              ),
            ),
          );         
  }

  Color getTextColor(Color backgroundColor) {
    var luminance = 0.2126 * backgroundColor.red + 0.7152 * backgroundColor.green + 0.0722 * backgroundColor.blue;
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

  List<Linea> convertirProductosALineas(List<ProductoVariante> productosAgregados) {
    return productosAgregados.map((producto) {
      return Linea(
        lineaId: 0, // Asigna un valor apropiado si lo tienes
        ordenTrabajoId: 0, // Asigna un valor apropiado si lo tienes
        numeroOrdenTrabajo: '', // Asigna un valor apropiado si lo tienes
        monedaId: producto.monedaId,
        fechaOrdenTrabajo: DateTime.now(), // O cualquier fecha que corresponda
        estado: 'Pendiente', // Puedes ajustar este valor según el estado de tu aplicación
        itemId: producto.itemId,
        codItem: producto.codItem,
        raiz: '', // Si tienes un valor para "raiz", úsalo
        descripcion: '${producto.color} - ${producto.talle}',
        macroFamilia: '', // Puedes asignar un valor aquí
        familia: '', // Puedes asignar un valor aquí
        grupoInventario: '', // Puedes asignar un valor aquí
        ordinal: 0, // Puedes definir el ordinal si es necesario
        cantidad: producto.cantidad,
        costoUnitario: 0.0, // Asigna el costo unitario si lo tienes disponible
        descuento1: 0, // Asigna los descuentos si los tienes
        descuento2: 0,
        descuento3: 0,
        precioVenta: producto.precioVentaActual.toInt(),
        comentario: '', // Asigna comentarios si los hay
        ivaId: producto.ivaId,
        iva: '21%', // Puedes ajustar este valor
        valor: producto.valor,
        gruInvId: 0, // Puedes asignar el id del grupo de inventario
        codGruInv: '', // Código del grupo de inventario si aplica
        cantFacturada: 0, // Puedes modificar este valor si tienes datos
        cantDevuelta: 0,
        totNetoFacturada: 0.0, // Asigna valores si los tienes
        totBrutoFacturada: 0.0,
        cantFac: 0,
        cantRem: 0,
        netoFac: 0.0,
        netoRem: 0.0,
        brutoFac: 0.0,
        brutoRem: 0.0,
        cantEPend: 0,
        fotoURL: producto.imagenes.isNotEmpty ? producto.imagenes[0] : '',
        codColor: producto.codColor,
        color: producto.color,
        colorHexCode: producto.colorHexCode.toString(),
        R: producto.r,
        G: producto.g,
        B: producto.b,
        talle: producto.talle,
        isExpanded: false, // Para el estado de expansión si es necesario
        metodo: '', // Puedes ajustar el método según tu lógica
      );
    }).toList();
  }


}