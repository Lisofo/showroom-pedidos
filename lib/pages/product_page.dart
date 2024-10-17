// ignore_for_file: must_be_immutable, unused_local_variable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/models/client.dart';
import 'package:showroom_maqueta/models/color.dart';
import 'package:showroom_maqueta/models/linea.dart';
import 'package:showroom_maqueta/models/pedido.dart';
import 'package:showroom_maqueta/models/product.dart';
import 'package:showroom_maqueta/models/producto_variante.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/services/pedidos_services.dart';
import 'package:showroom_maqueta/services/product_services.dart';
import 'package:showroom_maqueta/widgets/confirmacion.dart';
import 'package:showroom_maqueta/widgets/variante_items.dart';


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
  late List<Linea> lineasProvider = [];
  final _pedidosServices = PedidosServices();

  @override
  void initState() {
    super.initState();
    cargarDatos();
    _isEditing = List<bool>.generate(productosAgregados.length, (index) => false); // Lista dinámica
  }

  cargarDatos() async {
    almacen = context.read<ItemProvider>().almacen;
    token = context.read<ItemProvider>().token;
    cliente = context.read<ItemProvider>().client;
    pedido = context.read<ItemProvider>().pedido;
    lineasProvider = context.read<ItemProvider>().lineas;
    if(lineasProvider.isNotEmpty) {
      raiz = context.read<ItemProvider>().raiz;
    } else {
      productoSeleccionado = context.read<ItemProvider>().product;
    }
    productoNuevo = raiz == '' ? await ProductServices().getSingleProductByRaiz(productoSeleccionado.raiz, almacen, token) : await ProductServices().getSingleProductByRaiz(raiz, almacen, token);
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
    if(_products!.isNotEmpty){
      for(var linea in lineasProvider) {
        var agregar = _products!.firstWhere((prod) => prod.itemId == linea.itemId);
        agregar.cantidad = linea.cantidad;
        agregar.precioIvaIncluido = linea.costoUnitario;
        productosAgregados.add(agregar);
        _isEditing.add(false);
      }
    }

    buscando = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            raiz == '' ? productoSeleccionado.raiz : raiz,
            style: TextStyle(
              color: colores.onPrimary
            ),
          ),
          backgroundColor: colores.primary,
          iconTheme: const IconThemeData(
            color: Colors.white
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center(
                // child: SizedBox(
                  // width: 100,
                  // height: MediaQuery.of(context).size.height * 0.5,
                  // child: Image.network(
                    // raiz == '' ? productoSeleccionado.imagenes[0] : productoNuevo.imagenes[0]
                  // ),
                // ),
              // ),
              middleBody(),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView.separated(
                  controller: listController,
                  itemCount: productosAgregados.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    var item = productosAgregados[i];
                    return ListTile(
                      title: Text(item.codItem),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(1, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                );
                              },
                              child: _isEditing[i]
                                  ? Column(
                                      children: [
                                        // Campo para editar la cantidad
                                        TextFormField(
                                          key: ValueKey('textFormField_$i'), 
                                          initialValue: item.cantidad.toString(),
                                          keyboardType: TextInputType.number,
                                          onFieldSubmitted: (newValue) {
                                            setState(() {
                                              item.cantidad = int.parse(newValue);
                                              actualizarLineaConVariante(item); // Actualiza la línea al editar
                                              _isEditing[i] = false; 
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        // Campo para editar el precioIvaIncluido
                                        TextFormField(
                                          key: ValueKey('precioIvaIncluido_$i'),
                                          initialValue: item.precioIvaIncluido.toString(),
                                          keyboardType: TextInputType.number,
                                          onFieldSubmitted: (newValue) {
                                            setState(() {
                                              item.precioIvaIncluido = double.parse(newValue);
                                              actualizarLineaConVariante(item); // Actualiza la línea al editar
                                              _isEditing[i] = false;
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Text(
                                          'Cantidad: ${item.cantidad.toString()}',
                                          key: ValueKey('cantidad_$i'),
                                        ),
                                        Text(
                                          'Precio: \$${item.precioIvaIncluido.toStringAsFixed(2)}',
                                          key: ValueKey('precioIva_$i'),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _isEditing[i] = !_isEditing[i]; 
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                eliminarVariante(item); // Elimina el producto y actualiza líneas
                                _isEditing.removeAt(i); 
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
                int? statusCode;
                await _pedidosServices.putPedido(context, pedido, lineasProvider, token);
                statusCode = await _pedidosServices.getStatusCode();
                await _pedidosServices.resetStatusCode();
                if(statusCode == 1) {
                  Carteles.showDialogs(context, 'Productos actualizados', true, false);
                }

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

    return buscando
      ? const Center(child: CircularProgressIndicator())
      : _products!.isEmpty || _products == null
          ? const Center(
              child: Text('El Producto no existe', style: TextStyle(fontSize: 24)),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          raiz == "" ? productoSeleccionado.descripcion : productoNuevo.descripcion,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    showColorButtons(),
                    const SizedBox(height: 10),
                    if (productosFiltrados.isNotEmpty) ...[
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          for (var producto in productosFiltrados) ...[
                            VarianteItem(
                              producto: producto,
                              colores: colores,
                              onAgregar: () => _agregarOActualizarVariante(producto),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
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
        costoUnitario: producto.precioIvaIncluido, // Asigna el costo unitario si lo tienes disponible
        descuento1: 0, // Asigna los descuentos si los tienes
        descuento2: 0,
        descuento3: 0,
        precioVenta: 0,
        comentario: '', // Asigna comentarios si los hay
        ivaId: producto.ivaId,
        iva: '', // Puedes ajustar este valor
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
        metodo: 'POST', // Puedes ajustar el método según tu lógica
      );
    }).toList();
  }

  void actualizarLineas() {
    // Actualiza las líneas en base a las variantes agregadas
    for (var variante in productosAgregados) {
      // Verificar si la variante ya existe en la lista de lineas
      int indexLinea = lineasProvider.indexWhere((linea) => linea.itemId == variante.itemId);

      if (indexLinea == -1) {
        // Si no existe, agregar una nueva línea con método POST
        lineasProvider.add(Linea(
          lineaId: 0, // Asigna un valor apropiado si lo tienes
          ordenTrabajoId: 0, // Asigna un valor apropiado si lo tienes
          numeroOrdenTrabajo: '', // Asigna un valor apropiado si lo tienes
          monedaId: variante.monedaId,
          fechaOrdenTrabajo: DateTime.now(), // O cualquier fecha que corresponda
          estado: 'Pendiente', // Puedes ajustar este valor según el estado de tu aplicación
          itemId: variante.itemId,
          codItem: variante.codItem,
          raiz: '', // Si tienes un valor para "raiz", úsalo
          descripcion: '${variante.color} - ${variante.talle}',
          macroFamilia: '', // Puedes asignar un valor aquí
          familia: '', // Puedes asignar un valor aquí
          grupoInventario: '', // Puedes asignar un valor aquí
          ordinal: 0, // Puedes definir el ordinal si es necesario
          cantidad: variante.cantidad,
          costoUnitario: variante.precioIvaIncluido, // Asigna el costo unitario si lo tienes disponible
          descuento1: 0, // Asigna los descuentos si los tienes
          descuento2: 0,
          descuento3: 0,
          precioVenta: 0,
          comentario: '', // Asigna comentarios si los hay
          ivaId: variante.ivaId,
          iva: '', // Puedes ajustar este valor
          valor: variante.valor,
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
          fotoURL: variante.imagenes.isNotEmpty ? variante.imagenes[0] : '',
          codColor: variante.codColor,
          color: variante.color,
          colorHexCode: variante.colorHexCode.toString(),
          R: variante.r,
          G: variante.g,
          B: variante.b,
          talle: variante.talle,
          isExpanded: false, // Para el estado de expansión si es necesario
          metodo: 'POST', // Puedes ajustar el método según tu lógica
        ));
      } else {
        // Si existe, actualizar los valores y cambiar el método a PUT
        lineasProvider[indexLinea].cantidad = variante.cantidad;
        lineasProvider[indexLinea].costoUnitario = variante.precioIvaIncluido;
        lineasProvider[indexLinea].metodo = 'PUT';  // Registro existente, el método es PUT
      }
    }
  }

  void eliminarVariante(ProductoVariante varianteAEliminar) {
    // Eliminar variante de productosAgregados
    productosAgregados.removeWhere((variante) => variante.itemId == varianteAEliminar.itemId);
  
    // Buscar la línea correspondiente en lineasProvider
    int indexLinea = lineasProvider.indexWhere((linea) => linea.itemId == varianteAEliminar.itemId);
  
    if (indexLinea != -1) {
      // Si existe en lineasProvider, cambiar el método a DELETE
      lineasProvider[indexLinea].metodo = 'DELETE';
    }
  }

  void agregarVariante(ProductoVariante nuevaVariante) {
    // Agregar variante a productosAgregados
    productosAgregados.add(nuevaVariante);
  
    // Verificar si la variante ya existe en lineasProvider
    int indexLinea = lineasProvider.indexWhere((linea) => linea.itemId == nuevaVariante.itemId);
  
    if (indexLinea == -1) {
      // Si no existe, agregar nueva línea con método POST
      lineasProvider.add(Linea(
          lineaId: 0, // Asigna un valor apropiado si lo tienes
          ordenTrabajoId: 0, // Asigna un valor apropiado si lo tienes
          numeroOrdenTrabajo: '', // Asigna un valor apropiado si lo tienes
          monedaId: nuevaVariante.monedaId,
          fechaOrdenTrabajo: DateTime.now(), // O cualquier fecha que corresponda
          estado: 'Pendiente', // Puedes ajustar este valor según el estado de tu aplicación
          itemId: nuevaVariante.itemId,
          codItem: nuevaVariante.codItem,
          raiz: '', // Si tienes un valor para "raiz", úsalo
          descripcion: '${nuevaVariante.color} - ${nuevaVariante.talle}',
          macroFamilia: '', // Puedes asignar un valor aquí
          familia: '', // Puedes asignar un valor aquí
          grupoInventario: '', // Puedes asignar un valor aquí
          ordinal: 0, // Puedes definir el ordinal si es necesario
          cantidad: nuevaVariante.cantidad,
          costoUnitario: nuevaVariante.precioIvaIncluido, // Asigna el costo unitario si lo tienes disponible
          descuento1: 0, // Asigna los descuentos si los tienes
          descuento2: 0,
          descuento3: 0,
          precioVenta: 0,
          comentario: '', // Asigna comentarios si los hay
          ivaId: nuevaVariante.ivaId,
          iva: '', // Puedes ajustar este valor
          valor: nuevaVariante.valor,
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
          fotoURL: nuevaVariante.imagenes.isNotEmpty ? nuevaVariante.imagenes[0] : '',
          codColor: nuevaVariante.codColor,
          color: nuevaVariante.color,
          colorHexCode: nuevaVariante.colorHexCode.toString(),
          R: nuevaVariante.r,
          G: nuevaVariante.g,
          B: nuevaVariante.b,
          talle: nuevaVariante.talle,
          isExpanded: false, // Para el estado de expansión si es necesario
          metodo: 'POST', // Puedes ajustar el método según tu lógica
        ));
    }
  }
  
  void editarVariante(ProductoVariante varianteEditada) {
    // Buscar variante en productosAgregados
    int indexVariante = productosAgregados.indexWhere((variante) => variante.itemId == varianteEditada.itemId);
  
    if (indexVariante != -1) {
      // Actualizar variante en productosAgregados
      productosAgregados[indexVariante] = varianteEditada;
  
      // Verificar si la variante existe en lineasProvider
      int indexLinea = lineasProvider.indexWhere((linea) => linea.itemId == varianteEditada.itemId);
  
      if (indexLinea != -1) {
        // Actualizar la línea correspondiente y cambiar método a PUT
        lineasProvider[indexLinea].cantidad = varianteEditada.cantidad;
        lineasProvider[indexLinea].costoUnitario = varianteEditada.precioIvaIncluido;
        lineasProvider[indexLinea].metodo = 'PUT';
      }
    }
  }

  // Método para manejar la actualización de variantes
  void actualizarLineaConVariante(ProductoVariante variante) {
    var lineaExistente = lineasProvider.firstWhere(
      (linea) => linea.itemId == variante.itemId, 
      orElse: () => Linea.empty(),
    );

    if (lineaExistente.itemId == variante.itemId) {
      setState(() {
        lineaExistente.cantidad = variante.cantidad;
        lineaExistente.costoUnitario = variante.precioIvaIncluido;
        lineaExistente.metodo = 'PUT';
      });
    } else {
      setState(() {
        lineasProvider.add(Linea(
          lineaId: 0, // Asigna un valor apropiado si lo tienes
          ordenTrabajoId: 0, // Asigna un valor apropiado si lo tienes
          numeroOrdenTrabajo: '', // Asigna un valor apropiado si lo tienes
          monedaId: variante.monedaId,
          fechaOrdenTrabajo: DateTime.now(), // O cualquier fecha que corresponda
          estado: 'Pendiente', // Puedes ajustar este valor según el estado de tu aplicación
          itemId: variante.itemId,
          codItem: variante.codItem,
          raiz: '', // Si tienes un valor para "raiz", úsalo
          descripcion: '${variante.color} - ${variante.talle}',
          macroFamilia: '', // Puedes asignar un valor aquí
          familia: '', // Puedes asignar un valor aquí
          grupoInventario: '', // Puedes asignar un valor aquí
          ordinal: 0, // Puedes definir el ordinal si es necesario
          cantidad: variante.cantidad,
          costoUnitario: variante.precioIvaIncluido, // Asigna el costo unitario si lo tienes disponible
          descuento1: 0, // Asigna los descuentos si los tienes
          descuento2: 0,
          descuento3: 0,
          precioVenta: 0,
          comentario: '', // Asigna comentarios si los hay
          ivaId: variante.ivaId,
          iva: '', // Puedes ajustar este valor
          valor: variante.valor,
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
          fotoURL: variante.imagenes.isNotEmpty ? variante.imagenes[0] : '',
          codColor: variante.codColor,
          color: variante.color,
          colorHexCode: variante.colorHexCode.toString(),
          R: variante.r,
          G: variante.g,
          B: variante.b,
          talle: variante.talle,
          isExpanded: false, // Para el estado de expansión si es necesario
          metodo: 'POST', // Puedes ajustar el método según tu lógica
        ));
      });
    }
  }

  void _agregarOActualizarVariante(producto) {
    ProductoVariante? productoExistente = productosAgregados.firstWhere(
      (item) => item.codItem == producto.codItem,
      orElse: () => ProductoVariante.empty(),
    );
  
    int indexProducto;
    if (productoExistente.codItem == producto.codItem) {
      // Si el producto ya existe, aumentar la cantidad
      if (productoExistente.cantidad < producto.disponible) {
        setState(() {
          productoExistente.cantidad += 1;
        });
      } else {
        _mostrarSnackBar('No hay más disponibles de la variante ${producto.codItem}');
      }
      indexProducto = productosAgregados.indexOf(productoExistente);
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
          cantidad: 1,
        ),
      );
      _isEditing.add(false);
      indexProducto = productosAgregados.length - 1;
    }
  
    // Desplazar hacia el producto agregado o actualizado
    _scrollToProducto(indexProducto);
    setState(() {});
  }
  
  void _scrollToProducto(int indexProducto) {
    listController.animateTo(
      indexProducto * 70.0, // Ajusta según la altura del ítem
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(mensaje)),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

}