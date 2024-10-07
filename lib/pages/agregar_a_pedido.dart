// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/models/client.dart';
import 'package:showroom_maqueta/models/product.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/services/product_services.dart';


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
  bool activo = false;
  late String descripcion = '';

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

  cargarDatos() async {
    almacen = context.read<ItemProvider>().almacen;
    token = context.read<ItemProvider>().token;
    cliente = context.read<ItemProvider>().client;

    setState(() {});
  }

  Future<void> cargarMasDatos() async {
    setState(() {
      cargandoMas = true; // Indicar que estamos cargando más datos
    });

    // Llamar al servicio para obtener más productos
    List<Product> nuevosItems = await ProductServices().getProductByName(
      query.text, 
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar'),
        elevation: 0,
        backgroundColor: const Color(0xFFFD725A),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.55,
              child: SearchBar(
                hintText: 'Buscar o escanear item...',
                controller: query,
                onSubmitted: (value) async {
                  if (value.contains('-')) {
                    query.text = value;
                    descripcion = '';
                  } else {
                    query.text = '';
                    descripcion = value;
                  }

                  // Reiniciar el offset y la lista al buscar un nuevo término
                  offset = 0;
                  listItems = await ProductServices().getProductByName(
                    query.text, 
                    cliente.codTipoLista, 
                    almacen, 
                    descripcion, 
                    offset.toString(), 
                    token
                  );
                  setState(() {
                    offset += 20; // Incrementar el offset para la próxima carga
                  });
                },
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController, // Controlador del scroll
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: listItems.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  var item = listItems[i];
                  return ListTile(
                    leading: const Icon(
                      Icons.image,
                      size: 50,
                    ),
                    onTap: () {},
                    title: Text(item.descripcion),
                    subtitle: const Text('Descripcion corta del producto'),
                    trailing: const Icon(
                      Icons.chevron_right,
                      size: 35,
                    ),
                  );
                }
              ),
              if (cargandoMas)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(), // Indicador de carga al final
                ),
            ],
          ),
        )
      ),
    );
  }
}
