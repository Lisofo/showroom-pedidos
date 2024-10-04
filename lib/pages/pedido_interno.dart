import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/models/linea.dart';
import 'package:showroom_maqueta/models/pedido.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/services/lineas_services.dart';

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
          elevation: 0,
          backgroundColor: const Color(0xFFFD725A),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: ListView.builder(
                  itemCount: raices.length,
                  itemBuilder: (context, i) {
                    String raiz = raices[i];
                    int precioTotalVariante = 0;
                    int cantidadTotalVariante = 0;
                    String url = '';
                    var listaVariantes = obtenerListaRaiz(raiz);
                    for(var variante in listaVariantes){
                      precioTotalVariante += variante.costoUnitario;
                      cantidadTotalVariante += variante.cantidad;
                    }
                    for (var variante in listaVariantes){
                      url = Uri.encodeFull(variante.fotoURL);
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.09, //ToDo mediaquery isMobile agregar
                                width: MediaQuery.of(context).size.width * 0.1,
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
                                width: MediaQuery.of(context).size.width * 0.83,
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
                                      ]
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
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
                                      subtitle: Text('Cantidad: ${line.cantidad.toString()} Color: ${line.color} Talle: ${line.talle}'),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
        )
      ),
    );
  }
  
}
