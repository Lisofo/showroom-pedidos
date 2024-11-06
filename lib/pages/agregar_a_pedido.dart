// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/config/router/app_router.dart';
import 'package:showroom_maqueta/models/client.dart';
import 'package:showroom_maqueta/models/linea.dart';
import 'package:showroom_maqueta/models/product.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/services/product_services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:showroom_maqueta/widgets/carteles.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';


class AgregarPedido extends StatefulWidget {

  const AgregarPedido({super.key});

  @override
  State<AgregarPedido> createState() => _AgregarPedidoState();
}

class _AgregarPedidoState extends State<AgregarPedido> {
  List<Product> listItems = [];
  late String almacen = '';
  late String token = '';
  late Client cliente = Client.empty();
  late int offset = 0;
  final TextEditingController query = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool cargandoMas = false; // Bandera para evitar múltiples llamadas simultáneas
  bool cargando = false;
  bool activo = false;
  late String descripcion = '';
  late String raiz = '';
  bool busco = false;
  late List<Linea> lineas = [];
  bool existe = false;
  bool isMobile = false;
  late bool visible;
  String? _barcode;

  String barcodeFinal = '';
  String scannerResult = '';
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarDatos();

    // Añadir un listener al ScrollController para detectar el final de la lista
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !cargandoMas) {
        cargarMasDatos();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cargarDatos();
  }

  void cargarDatos() async {
    almacen = context.read<ItemProvider>().almacen;
    token = context.read<ItemProvider>().token;
    cliente = context.read<ItemProvider>().client;
    
    setState(() {});
  }

  Future<void> cargarMasDatos() async {
    setState(() {
      cargandoMas = true; // Indicar que estamos cargando más datos
    });

    List<Product> nuevosItems = await ProductServices().getProductByName(
      context,
      raiz, 
      cliente.codTipoLista, 
      almacen, 
      descripcion, // Descripción vacía al cargar más
      offset.toString(), 
      token
    );

    setState(() {
      listItems.addAll(nuevosItems); // Añadir los nuevos productos a la lista existente
      offset += 20; // Incrementar el offset para la próxima carga
      cargandoMas = false; // Indicar que ya no estamos cargando datos
    });
  }

  @override
  Widget build(BuildContext context) {
    lineas = context.watch<ItemProvider>().lineasGenericas;
    final colores = Theme.of(context).colorScheme;
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    isMobile = shortestSide < 600;
    print('REconstruido');
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colores.primary,
          iconTheme: const IconThemeData(
            color: Colors.white
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child:  SearchBar(
                  textInputAction: TextInputAction.search,
                  hintText: 'Buscar o escanear item...',
                  controller: query,
                  autoFocus: false,
                  trailing: [
                    IconButton(
                      onPressed: () {
                        query.clear();
                      }, 
                      icon: Icon(Icons.clear, color: colores.onSurface,)
                    )
                  ],
                  onSubmitted: (value) async {
                    cargando = true;
                    setState((){});
                    query.text = value;
                    raiz = query.text.trim();
                    offset = 0;
                    listItems = await ProductServices().getProductByName(
                      context,
                      raiz, 
                      cliente.codTipoLista, 
                      almacen, 
                      '', 
                      offset.toString(), 
                      token
                    );
                    setState(() {
                      busco = true;
                      cargando = false;
                      offset += 20;
                    });
                  },
                ),
              ),
            ),
            if(isMobile)...[
              IconButton(
                onPressed: readQRCode,
                icon: const Icon(Icons.qr_code_scanner_rounded),
                color: Colors.white,
              ),
            ] else ...[
              IconButton(
                onPressed: readQRCode,
                icon: const Icon(Icons.qr_code_scanner_rounded),
                color: Colors.white,
              ), ///ESTO ES TEMPORALLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
              VisibilityDetector(
                onVisibilityChanged: (VisibilityInfo info){
                  visible = info.visibleFraction > 0;
                },
                key: const Key('visible-detector-key'),
                child: BarcodeKeyboardListener(
                  bufferDuration: const Duration(milliseconds: 200),
                  onBarcodeScanned: (barcode) async{
                    if(!visible) return;
                    print(barcode);
                    setState(() {
                      _barcode = barcode;
                    });
                    if (_barcode != null){     
                      Product productoRetorno;
                      List<Product> listaProductosTemporal;
                      String code = await FlutterBarcodeScanner.scanBarcode('#FFFFFF', 'Cancelar', false, ScanMode.QR);
                      print('el codigo escaneado es $code');
                      if (code == '') {
                        return null;
                      } else {
                        listaProductosTemporal = await ProductServices().getProductByName(context, '', cliente.codTipoLista ,almacen, code, "0", token,);
                        barcodeFinal = code;
                        if(listaProductosTemporal.isNotEmpty){
                          productoRetorno = listaProductosTemporal[0];
                          Provider.of<ItemProvider>(context, listen: false).setProduct(productoRetorno);
                          appRouter.push('/product_page');
                        } else {
                          Carteles.showDialogs(context, 'No se pudo conseguir ningun producto con el código $code', false, false, false);
                        }
                        setState(() {});
                      }
                    }
                  }, 
                  child: const Text(
                    '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ) 
                )
              )
            ]
          ],
        ), 
        body: !cargando ? SafeArea(
          child: SingleChildScrollView(
            controller: scrollController, // Controlador del scroll
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text('Ultimo escaneado: $barcodeFinal', textAlign: TextAlign.center,)),
                ),
                
                Visibility(
                  visible: false,
                  maintainState: true,
                  child: TextFormField(
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Cambia el color a rojo
                        borderRadius: BorderRadius.all(Radius.zero)
                      ),
                      contentPadding: EdgeInsets.all(0)
                    ),
                    autofocus: true,
                    canRequestFocus: true,
                    keyboardType: TextInputType.none, // Deshabilita el teclado virtual
                    onChanged: (value) async {
                      Product productoRetorno;
                      List<Product> listaProductosTemporal;
                      barcodeFinal = value;
                  
                      listaProductosTemporal = await ProductServices().getProductByName(context, '', cliente.codTipoLista ,almacen, barcodeFinal, "0", token,);
                      if(listaProductosTemporal.isNotEmpty){
                        productoRetorno = listaProductosTemporal[0];
                        Provider.of<ItemProvider>(context, listen: false).setProduct(productoRetorno);
                        appRouter.push('/product_page');
                      } else {
                        Carteles.showDialogs(context, 'No se pudo conseguir ningun producto con el código $barcodeFinal', false, false, false);
                      }             
                      // Guarda el resultado del escaneo
                      
                      // Resetea el campo de texto
                      setState(() {
                        textController.clear(); // Asume que tienes un TextEditingController llamado _controller
                      });
                    },
                    controller: textController, // Asume que tienes un TextEditingController llamado _controller
                  ),
                ),
                if(!busco || listItems.isNotEmpty)...[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: listItems.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      var item = listItems[i];
                      var foto = item.imagenes[0];
                      var precio = '';
                      existe = false; // Reiniciar la variable 'existe' para cada item
      
                      // Verificar si el itemId existe en la lista de 'lineas'
                      for (var linea in lineas) {
                        if (linea.raiz == item.raiz) {
                          existe = true; // Si se encuentra el itemId en lineas, marcar 'existe' como true
                          break; // No es necesario seguir buscando, ya encontramos el itemId
                        }
                      }
      
                      if(item.precioIvaIncluidoMin != item.precioIvaIncluidoMax){
                        precio = '${item.precioIvaIncluidoMin} - ${item.precioIvaIncluidoMax}';
                      } else {
                        precio = item.precioIvaIncluidoMax.toString();
                      }
      
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Provider.of<ItemProvider>(context, listen: false).setRaiz(item.raiz);
                              appRouter.push('/productoSimple');
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Image.network(
                                foto,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Placeholder(
                                    child: Text('No Image'),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ListTile(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                Provider.of<ItemProvider>(context, listen: false).setProduct(item);
                                Provider.of<ItemProvider>(context, listen: false).setRaiz(item.raiz);
                                appRouter.push('/product_page');
                              },
                              title: Text(item.raiz),
                              subtitle: Text('${item.descripcion} \nPrecio: ${item.signo}$precio    Disponibilidad: ${item.disponibleRaiz}'),
                              trailing: const Icon(
                                Icons.chevron_right,
                                size: 35,
                              ),
                              // Si 'existe' es true, pintar el ListTile de azul claro
                              tileColor: existe ? Colors.lightBlue[100] : null,
                            ),
                          ),
                        ],
                      );
                    }
                  )
                ] else...[
                  const Text(
                    'No se encontró su busqueda. Intentelo nuevamente',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300
                    )
                  )
                ],
                if (cargandoMas)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ]
            ),
          )
        ) : const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10,),
                Text('Buscando...')
              ],
            )
          ),
        ),
      ),
    );
  }

  readQRCode() async {
    Product productoRetorno;
    List<Product> listaProductosTemporal;
    String code = await FlutterBarcodeScanner.scanBarcode('#FFFFFF', 'Cancelar', false, ScanMode.QR);
    print('el codigo escaneado es $code');
    if (code == '-1') {
      return null;
    } else {
      barcodeFinal = code;
      listaProductosTemporal = await ProductServices().getProductByName(context, '', cliente.codTipoLista ,almacen, code, "0", token,);
      if(listaProductosTemporal.isNotEmpty){
        productoRetorno = listaProductosTemporal[0];
        Provider.of<ItemProvider>(context, listen: false).setProduct(productoRetorno);
        appRouter.push('/product_page');
      } else {
        Carteles.showDialogs(context, 'No se pudo conseguir ningun producto con el código $code', false, false, false);
      }
      setState(() {});
    }
  }
}