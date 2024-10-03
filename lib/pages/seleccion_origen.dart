// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/config/router/app_router.dart';
import 'package:showroom_maqueta/models/product.dart';
// import 'package:showroom_maqueta/offline/boxes.dart';
// import 'package:showroom_maqueta/offline/product_functions.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/providers/theme_provider.dart';
import 'package:showroom_maqueta/services/product_services.dart';

class SeleccionOrigen extends StatefulWidget {
  
  static const String name = 'selector_origen';
  const SeleccionOrigen({super.key});

  @override
  State<SeleccionOrigen> createState() => _SeleccionOrigenState();
}

class _SeleccionOrigenState extends State<SeleccionOrigen> {

  bool switchValue = false;
  String token = '';
  List<Product> productosOffline = [];
  String almacen = '';
  bool cargando = false;
  

@override
void initState() {
  super.initState();
}

  


  cargarDatos() async{
    setState(() {
      cargando = true;
    });
    
    bool isConnected = await _checkConnectivity();
    if(isConnected){
      token = context.read<ItemProvider>().token;
      productosOffline = await ProductServices().getAllProducts(almacen,token);
      
      // for (int i = 0; i<productosOffline.length; i++){
      //     _saveProductLocally(productosOffline[i]);
      // }
  
    }
    setState(() { 
      cargando = false;
    });
  }

  // Future<void> _saveProductLocally(Product producto) async{
  //   addProductToBox(producto);
  // }



  Future<bool> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }


  @override

  Widget build(BuildContext context) {
    
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: cargando ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
      
            children: [
              Text('Aguarde por favor...',style: TextStyle(fontSize: 24)),
              SizedBox(height: 30,),
              CircularProgressIndicator(strokeWidth: 10,),
            ],
          )
        ) : 
        Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                    height: 400,
                    width: 400,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                    child: InkWell(
                        onTap: () async {
                          
                          Provider.of<ThemeProvider>(context, listen: false).selectedColor = 1;
                          Provider.of<ItemProvider>(context, listen: false).setAlmacen('81');
      
                          almacen = '81';
                          // if(boxProduct.isEmpty){
                          //   await cargarDatos();
                          // }else{
                          //   Product producto = boxProduct.getAt(0);
                          //   if(producto.codAlmacen != almacen || switchValue) {
                          //     boxProduct.clear();
                          //     await cargarDatos();
                          //   }
                          // }
                          // print(boxProduct.length);
                          appRouter.push('/client_search');
                          
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color.fromARGB(255, 211, 0, 41), width: 3),
                            ),
                            child: Image.asset('images/ufo-logo.png')
                          )
                    )
                ),
              ),
      
              const SizedBox(
                width: 300,
              ),
              Flexible(
                flex: 1,
                child: Container(
                    height: 400,
                    width: 400,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: InkWell(
                      onTap: () async {
                        Provider.of<ItemProvider>(context, listen: false).setAlmacen('1');
                        Provider.of<ThemeProvider>(context, listen: false).selectedColor = 0;
                        
      
                        almacen = '1';
                        // if(boxProduct.isEmpty){
                        //   cargarDatos();
                        // }else{
                        //   Product producto = boxProduct.getAt(0);
                        //   if(producto.codAlmacen != almacen || switchValue) {
                        //     boxProduct.clear();
                        //     await cargarDatos();
                        //   }
                        // }
                        
      
                        
                        appRouter.push('/client_search');
                        
                      },
                      child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue.shade900, width: 3),
                        
                      ),
                      child: Image.asset(
                        'images/nyp-logo.png',
                      )),
                    ),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      logout();
                    }, 
                    child: const Text('Cerrar Sesion')
                  ),
                  Column(
                    children: [
                      const Text('Sincronizar?'),
                      Switch(
                        value: switchValue, 
                        onChanged:(value) {
                          setState(() {
                            switchValue = !switchValue;
                            
                          });
                        },
                        activeColor: Colors.teal,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20,),
              TextButton(
                onPressed: (){
                  appRouter.push('/dashboard');
                }, 
                child: const Text('Ir a Dashboard')
              ),
            ],
          )
        ),
      ),
    );
  }

  void logout() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Cerrar sesion'),
            content: const Text('Esta seguro de querer cerrar sesion?'),
            actions: [
              TextButton(
                  onPressed: () {
                    appRouter.pop();
                  },
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    Provider.of<ItemProvider>(context, listen: false).setToken('');
                    appRouter.pushReplacement('/login');
                  },
                  child: const Text(
                    'Cerrar Sesion',
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          );
        },
      );
    }
}

