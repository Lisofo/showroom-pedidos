import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/config/router/app_router.dart';
import 'package:showroom_maqueta/models/linea.dart';
import 'package:showroom_maqueta/models/pedido.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/services/lineas_services.dart';
import 'package:showroom_maqueta/services/pedidos_services.dart';

class PedidoInterno extends StatefulWidget {
  const PedidoInterno({super.key});

  @override
  State<PedidoInterno> createState() => _PedidoInternoState();
}

class _PedidoInternoState extends State<PedidoInterno> {
  late List<Linea> lineas = [];
  late String token = '';
  late Pedido pedidoSeleccionado = Pedido.empty();
  Map<String, List<Linea>> listaDeLista = {};
  late List<String> raices = [];
  late int precio = 0;
  int buttonIndex = 0;
  bool isMobile = false;
  bool recargando = false;
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  
  @override
  void initState() {
    super.initState();
    cargarDatos();
  }
  
  cargarDatos() async {
    token = context.read<ItemProvider>().token;
    pedidoSeleccionado = context.read<ItemProvider>().pedido;
    lineas = await LineasServices().getLineasOrden(context, pedidoSeleccionado.ordenTrabajoId, token);
    cargarListas();
    listaDeLista;
    raices = cargarRaices();
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    isMobile = shortestSide < 600;
    setState(() {});
  }

  void cargarListas() {
    for (var linea in lineas) {
      String raiz = linea.raiz;
      if (!listaDeLista.containsKey(raiz)) {
        listaDeLista[raiz] = [];
      }
      listaDeLista[raiz]!.add(linea);
      obtenerListaRaiz(raiz);
    }
  }

  List<String> cargarRaices() {
    List<String> resultado = [];
    for (var linea in lineas) {
      if (!resultado.contains(linea.raiz)){
        resultado.add(linea.raiz);
      }
    }
    return resultado;
  }

  List<Linea> obtenerListaRaiz(String raiz) {
    return listaDeLista[raiz] ?? [];
  }

  Future<void> _refreshData() async {
    lineas = [];
    listaDeLista = {};
    raices = [];
    setState(() {});
    await cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          centerTitle: true,
          title: Text(pedidoSeleccionado.numeroOrdenTrabajo,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              fontSize: 30,
              color: Colors.black
            )
          ),
          iconTheme: const IconThemeData(
            color: Colors.white
          ),
          elevation: 0,
          backgroundColor: const Color(0xFFFD725A),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: RefreshIndicator(
                  key: _refreshKey,
                  onRefresh: _refreshData,
                  child: ListView.builder(
                    itemCount: raices.length,
                    itemBuilder: (context, i) {
                      String raiz = raices[i];
                      double precioTotalVariante = 0;
                      int cantidadTotalVariante = 0;
                      String url = '';
                      List<Linea> listaVariantes = obtenerListaRaiz(raiz);
                      for(var variante in listaVariantes){
                        cantidadTotalVariante += variante.cantidad;
                        precioTotalVariante += (variante.costoUnitario * variante.cantidad);
                      }
                      for (var variante in listaVariantes){
                        url = Uri.encodeFull(variante.fotoURL);
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: isMobile ? MediaQuery.of(context).size.width * 0.2 : MediaQuery.of(context).size.width * 0.09, //ToDo mediaquery isMobile agregar
                                  width: isMobile ? MediaQuery.of(context).size.width * 0.2 : MediaQuery.of(context).size.width * 0.1,
                                  child: Image.network( 
                                    url,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Placeholder(
                                        child: Text('No Image'),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: isMobile ? MediaQuery.of(context).size.width * 0.6 : MediaQuery.of(context).size.width * 0.83,
                                  child: ExpansionTile(
                                    title: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: variante.raiz,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20
                                            )
                                          ),
                                          const TextSpan(
                                            text: '  '
                                          ),
                                          TextSpan(
                                            text: variante.descripcion,
                                            style: const TextStyle(fontSize: 16)
                                          ),
                                          const TextSpan(
                                            text: '     '
                                          ),
                                          TextSpan(
                                            text: 'Precio: ${pedidoSeleccionado.signo} ${variante.costoUnitario.toString()}',
                                            style: const TextStyle(
                                              fontSize: 16
                                            )
                                          ),
                                        ]
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                      children: [
                                        if (isMobile) ... [
                                          const SizedBox(height: 10,)
                                        ],
                                        Text('Cantidad: ${cantidadTotalVariante.toString()}', 
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Text('Total: ${pedidoSeleccionado.signo} ${precioTotalVariante.toString()}', 
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    children: listaVariantes.map((line){
                                      return ListTile(
                                        title: Text(line.codItem),
                                        subtitle: Text('Color: ${line.color} Talle: ${line.talle} Cantidad: ${line.cantidad.toString()}'),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: (){
                                        Provider.of<ItemProvider>(context, listen: false).setLineas(listaVariantes);
                                        Provider.of<ItemProvider>(context, listen: false).setRaiz(raiz);
                                        appRouter.push('/product_page');
                                      }, 
                                      icon: const Icon(Icons.edit)
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        for(var i = 0; i < listaVariantes.length; i++){
                                          listaVariantes[i].metodo = 'DELETE';
                                        }
                                        await PedidosServices().putPedido(context, pedidoSeleccionado, listaVariantes, token);
                                        lineas = [];
                                        cargarDatos();
                                      },
                                      icon: const Icon(Icons.delete)
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: buttonIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              label: 'Agregar item'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Carrito'
            ),
          ],
          onTap: (index) async {
            buttonIndex = index;
            switch (buttonIndex) {
              case 0:
                Provider.of<ItemProvider>(context, listen: false).setLineas([]);
                appRouter.push('/product_add');
              break;
              case 1:
              break;
            }
          },
        ),
      ),
    );
  }
  
}
