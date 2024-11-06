import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/config/router/app_router.dart';
import 'package:showroom_maqueta/models/client.dart';
import 'package:showroom_maqueta/models/product.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/services/product_services.dart';

class PaginaTestScanner extends StatefulWidget {
  
  const PaginaTestScanner({super.key});

  @override
  State<PaginaTestScanner> createState() => _PaginaTestScannerState();
}

class _PaginaTestScannerState extends State<PaginaTestScanner> {
  String? _barcode;
  late bool visible;
  List<Product> productosScanner = [];
  late String almacen = '';
  late String token = '';
  late Client cliente = Client.empty();
  String barcodeFinal = '';
  String scannerResult = '';
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  void cargarDatos() async {
    almacen = context.read<ItemProvider>().almacen;
    token = context.read<ItemProvider>().token;
    cliente = context.read<ItemProvider>().client;
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Escanee el codigo...'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text('Por favor escanee el codigo de barras usando el boton del costado del dispositivo', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('Ultimo producto escaneado: $barcodeFinal', textAlign: TextAlign.center,)),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                autofocus: true,
                canRequestFocus: true,
                keyboardType: TextInputType.none, // Deshabilita el teclado virtual
                
                onChanged: (value) async {
                  // Captura el valor escaneado
                  barcodeFinal = value;
                  // Realiza las acciones necesarias con el valor escaneado
                  productosScanner = await ProductServices().getProductByName(
                    context,
                    '',
                    cliente.codTipoLista,
                    almacen,
                    barcodeFinal,
                    0.toString(),
                    token,
                  );
                  if (productosScanner.isNotEmpty) {
                    Provider.of<ItemProvider>(context, listen: false).setProduct(productosScanner[0]);
                    Provider.of<ItemProvider>(context, listen: false).setRaiz(productosScanner[0].raiz);
                    appRouter.push('/product_page');
                  }
                  // Navega a la siguiente página
                  
                  // Guarda el resultado del escaneo
                  scannerResult = barcodeFinal;
                  // Resetea el campo de texto
                  setState(() {
                    textController.clear(); // Asume que tienes un TextEditingController llamado _controller
                  });
                },
                controller: textController, // Asume que tienes un TextEditingController llamado _controller
              ),
            ],
          ),
        ),
      )
    );
  }
}