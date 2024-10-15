// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/config/router/app_router.dart';
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
  bool cargando = false;
  bool activo = false;
  late String descripcion = '';
  late String raiz = '';
  bool busco = false;

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

    List<Product> nuevosItems = await ProductServices().getProductByName(
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFD725A),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: SearchBar(
                textInputAction: TextInputAction.search,
                hintText: 'Buscar o escanear item...',
                controller: query,
                onSubmitted: (value) async {
                  cargando = true;
                  if (value.contains('-')) {
                    query.text = value;
                    raiz = query.text.trim();
                    descripcion = '';
                  } else {
                    descripcion = value;
                  }
                  offset = 0;
                  listItems = await ProductServices().getProductByName(
                    raiz, 
                    cliente.codTipoLista, 
                    almacen, 
                    descripcion, 
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
          IconButton(onPressed: (){}, icon: const Icon(Icons.camera_alt))
        ],
      ),
      body: !cargando ? SafeArea(
        child: SingleChildScrollView(
          controller: scrollController, // Controlador del scroll
          child: Column(
            children: [
              if(!busco || listItems.isNotEmpty)...[
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: listItems.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    var item = listItems[i];
                    var foto = item.imagenes[0];
                    var precio = '';
                    if(item.precioIvaIncluidoMin != item.precioIvaIncluidoMax){
                      precio = '${item.precioIvaIncluidoMin} - ${item.precioIvaIncluidoMax}';
                    } else {
                      precio = item.precioIvaIncluidoMax.toString();
                    }
                    return Row(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Image.network(
                            foto,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ListTile(
                            onTap: () {
                              Provider.of<ItemProvider>(context, listen: false).setProduct(item);
                              appRouter.push('/product_page');
                            },
                            title: Text(item.raiz),
                            subtitle: Text('${item.descripcion} \nPrecio: ${item.signo}$precio    Disponibilidad: ${item.disponibleRaiz}'),
                            trailing: const Icon(
                              Icons.chevron_right,
                              size: 35,
                            ),
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
    );
  }
}
