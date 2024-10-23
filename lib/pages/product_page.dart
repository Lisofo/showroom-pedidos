// ignore_for_file: must_be_immutable, unused_local_variable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/config/router/app_router.dart';
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
  late List<Linea> lineasGenericas = [];
  final _pedidosServices = PedidosServices();
  late ScaffoldMessengerState scaffoldMessenger;
  late String colorYTalleSeleccionado = '';


  @override
  void initState() {
    super.initState();
    cargarDatos();
    _isEditing = List<bool>.generate(productosAgregados.length, (index) => false); // Lista dinámica
  }

  @override
  void dispose() {
    // Limpiar los SnackBars pendientes usando la referencia guardada
    scaffoldMessenger.clearSnackBars();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Guardamos una referencia al ScaffoldMessenger
    scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  cargarDatos() async {
    almacen = context.read<ItemProvider>().almacen;
    token = context.read<ItemProvider>().token;
    cliente = context.read<ItemProvider>().client;
    pedido = context.read<ItemProvider>().pedido;
    lineasGenericas = context.read<ItemProvider>().lineasGenericas;
    raiz = context.read<ItemProvider>().raiz;
    productoSeleccionado = context.read<ItemProvider>().product;
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
    if(_products!.isNotEmpty && lineasGenericas.isNotEmpty){
      for (var linea in lineasGenericas) {
        var agregar = _products!.where((prod) => prod.itemId == linea.itemId).toList();

        if (agregar.isNotEmpty) {
          agregar.first.cantidad = linea.cantidad;
          agregar.first.precioIvaIncluido = linea.costoUnitario;
          productosAgregados.add(agregar.first);
          _isEditing.add(false);
        }
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
                                          if(item.disponible > 0){
                                            setState(() {
                                              item.cantidad = int.parse(newValue);
                                              actualizarLineaConVariante(item); // Actualiza la línea al editar
                                              _isEditing[i] = false; 
                                            });
                                          } else {

                                          }
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cantidad: ${item.cantidad.toString()}',
                                      key: ValueKey('cantidad_$i'),
                                    ),
                                    Text(
                                      'Precio: \$${item.precioIvaIncluido.toStringAsFixed(2)}',
                                      key: ValueKey('precioIva_$i'),
                                    ),
                                    Text(
                                      'Color: ${item.color}',
                                    ),
                                    Text(
                                      'Talle: ${item.talle}'
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
              icon: Icon(Icons.format_align_left),
              label: 'Totales'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.price_change),
              label: 'Cambio de precio'
            ),
          ],
          onTap: (value) async {
            buttonIndex = value;
            switch (buttonIndex) {
              case 0:
                int? statusCode;
                List<Linea> lineasAEnviar = [];
                lineasAEnviar = lineasGenericas.where((linea) => linea.raiz == productoNuevo.raiz).toList();
                await _pedidosServices.putPedido(context, pedido, lineasAEnviar, token);
                statusCode = await _pedidosServices.getStatusCode();
                await _pedidosServices.resetStatusCode();
                if(statusCode == 1) {
                  Carteles.showDialogs(context, 'Productos actualizados', true, false, false);
                }
              break;
              case 1:
                var cantidad = 0;
                var costoTotal = 0.0;
                var lineasDeLaRaiz = lineasGenericas.where((linea) => linea.raiz == productoNuevo.raiz && linea.metodo != "DELETE").toList();
                for(var linea in lineasDeLaRaiz) {
                  cantidad += linea.cantidad;
                  costoTotal += linea.costoUnitario * linea.cantidad;
                }
                await showDialog(
                  context: context, 
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Totales'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Cantidad total: $cantidad'),
                          const SizedBox(height: 10,),
                          Text('Costo total: ${pedido.signo} $costoTotal')
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            appRouter.pop();
                          },
                          child: const Text('Cerrar')
                        )
                      ],
                    );
                  }
                );
              break;
              case 2:
                await cambioDePrecios(context);
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              raiz == "" ? '${productoSeleccionado.signo} ${productoSeleccionado.precioIvaIncluido}' : '${productoNuevo.signo} ${productoNuevo.precioIvaIncluido}',
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            double nuevoPrecio2 = 0.0;
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Cambiar precio de la raiz'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Introduce el nuevo precio para la raiz $raiz:'),
                                      const SizedBox(height: 10),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'Nuevo precio',
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                          // Convertir el valor del campo a double
                                          nuevoPrecio2 = double.tryParse(value) ?? 0.0;
                                        },
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Cerrar el pop-up sin hacer nada
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Llamar al método para cambiar los precios
                                        productoSeleccionado.precioIvaIncluido = nuevoPrecio2;
                                        productoNuevo.precioIvaIncluido = nuevoPrecio2;
                                        for(var variante in _products!){
                                          variante.precioIvaIncluido = nuevoPrecio2;
                                        }
                                        setState(() {});
                                        Navigator.of(context).pop(); // Cerrar el pop-up
                                      },
                                      child: const Text('Confirmar'),
                                    ),
                                  ],
                                );
                              }
                            );
                          },
                          child: const Text('Cambiar precio')
                        )
                      ],
                    ),
                    showColorButtons(),
                    const SizedBox(height: 10),
                    Text(
                      colorYTalleSeleccionado,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
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
                      SizedBox(
                        width: double.infinity,  // Para que el botón ocupe todo el ancho
                        child: ElevatedButton(
                          onPressed: agregarTodasLasVariantes,
                          child: const Text("Agregar todos"),
                        ),
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
        GestureDetector(
          onTap: () {
            setState(() {
              for (var c in colors) {
                if(c != color) {
                  c.isSelected = false;
                }
              }
              color.isSelected = !color.isSelected;
              mostrarTalles2(color);
              colorYTalleSeleccionado = '${color.nombreColor} ${color.codColor}';
            });
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all()
            ),
            child: CircleAvatar(
              backgroundColor: Color.fromARGB(255, color.r, color.g, color.b),
              child: color.isSelected ? Icon(Icons.check, color: getTextColor(Color.fromARGB(255, color.r, color.g, color.b)),) : const SizedBox(),
            ),
          ),
        )
      ],
    );
  }

  mostrarTalles2(ProductColor color) {
    if(color.isSelected){
      for (String talle in talles) {
        productosFiltrados = _products!.where((product) => product.color == color.nombreColor).toList();
      }
    } else {
      productosFiltrados = [];
    }
    
  }

  void eliminarVariante(ProductoVariante varianteAEliminar) {
    // Eliminar variante de productosAgregados
    productosAgregados.removeWhere((variante) => variante.itemId == varianteAEliminar.itemId);
    // Buscar la línea correspondiente en lineasProvider
    int indexLinea = lineasGenericas.indexWhere((linea) => linea.itemId == varianteAEliminar.itemId && linea.lineaId != 0);
  
    if (indexLinea != -1) {
      // Si existe en lineasProvider, cambiar el método a DELETE
      lineasGenericas[indexLinea].metodo = 'DELETE';
    }
  }

  // Método para manejar la actualización de variantes
  void actualizarLineaConVariante(ProductoVariante variante) {
  Linea lineaExistente = Linea.empty();
    lineaExistente = lineasGenericas.firstWhere(
      (linea) => linea.itemId == variante.itemId, 
      orElse: () => Linea.empty(),
    );    
    var cantidad = variante.cantidad;

    if (variante.cantidad != lineaExistente.cantidad) {
      cantidad = variante.cantidad;
    }

    if (lineaExistente.itemId == variante.itemId && lineaExistente.lineaId != 0) {
      setState(() {
        lineaExistente.cantidad += variante.cantidad;  // Incrementa la cantidad actual
        lineaExistente.costoUnitario = variante.precioIvaIncluido;
        lineaExistente.metodo = 'PUT';
      });
    } else if (lineaExistente.lineaId == 0 && lineaExistente.cantidad == 0) {
      setState(() {
        Provider.of<ItemProvider>(context, listen: false).addLinea(
          Linea(
            lineaId: 0, 
            ordenTrabajoId: 0, 
            numeroOrdenTrabajo: '', 
            monedaId: variante.monedaId,
            fechaOrdenTrabajo: DateTime.now(),
            estado: 'Pendiente',
            itemId: variante.itemId,
            codItem: variante.codItem,
            raiz: raiz == '' ? productoSeleccionado.raiz : raiz,
            descripcion: '${variante.color} - ${variante.talle}',
            macroFamilia: '',
            familia: '',
            grupoInventario: '',
            ordinal: 0,
            cantidad: cantidad,
            costoUnitario: variante.precioIvaIncluido,
            descuento1: 0,
            descuento2: 0,
            descuento3: 0,
            precioVenta: 0,
            comentario: '',
            ivaId: variante.ivaId,
            iva: '',
            valor: variante.valor,
            gruInvId: 0,
            codGruInv: '',
            cantFacturada: 0,
            cantDevuelta: 0,
            totNetoFacturada: 0.0,
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
            isExpanded: false,
            metodo: 'POST',
          ));
      });
    } else {
      setState(() {
        lineaExistente.cantidad += cantidad;  // Incrementa la cantidad actual si no es línea nueva
        lineaExistente.costoUnitario = variante.precioIvaIncluido;
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
      setState(() {
        productoExistente.cantidad += 1;  // Incrementa la cantidad
      });
      actualizarLineaConVariante(productoExistente);
      indexProducto = productosAgregados.indexOf(productoExistente);
    } else {
      // Agregar nuevo producto a productosAgregados
      ProductoVariante productoAAgregar = ProductoVariante(
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
      );
      productosAgregados.add(productoAAgregar);
      _isEditing.add(false);
      indexProducto = productosAgregados.length - 1;
      actualizarLineaConVariante(productoAAgregar);
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
    if(mounted){
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Center(child: Text(mensaje)),
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  void agregarTodasLasVariantes() {
    for (var producto in productosFiltrados) {
      _agregarOActualizarVariante(producto);
    }
  }

  void cambiarPreciosVariantesYLineas(double nuevoPrecio) {
    for (var variante in productosAgregados) {
      // Cambiar el precio de cada variante
      variante.precioIvaIncluido = nuevoPrecio;

      // Actualizar las líneas correspondientes
      var lineaCorrespondiente = lineasGenericas.firstWhere(
        (linea) => linea.itemId == variante.itemId,
        orElse: () => Linea.empty(),
      );

      if (lineaCorrespondiente.lineaId != 0) {
        lineaCorrespondiente.costoUnitario = nuevoPrecio;
        lineaCorrespondiente.metodo = 'PUT';  // Cambiar el método a PUT
      } else {
        lineaCorrespondiente.costoUnitario = nuevoPrecio;
        lineaCorrespondiente.metodo = 'POST'; 
      }
    }

    // Actualizar la UI si es necesario
    setState(() {});
  }

  Future<void> cambioDePrecios(BuildContext context) async {
    double nuevoPrecio = 0.0;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cambiar precios'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Introduce el nuevo precio para la raiz $raiz:'),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nuevo precio',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // Convertir el valor del campo a double
                  nuevoPrecio = double.tryParse(value) ?? 0.0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Cerrar el pop-up sin hacer nada
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Llamar al método para cambiar los precios
                cambiarPreciosVariantesYLineas(nuevoPrecio);
                Navigator.of(context).pop(); // Cerrar el pop-up
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }


}