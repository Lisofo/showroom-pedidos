// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/config/router/app_router.dart';
import 'package:showroom_maqueta/models/client.dart';
import 'package:showroom_maqueta/models/pedido.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/services/pedidos_services.dart';

class PaginaCliente extends StatefulWidget {

  const PaginaCliente({super.key});

  @override
  State<PaginaCliente> createState() => _PaginaClienteState();
}

class _PaginaClienteState extends State<PaginaCliente> {
  List<Pedido> listaPedidos = [];
  late Client clienteSeleccionado = Client.empty();
  late String token = '';
  late String alamcenId = '';

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  cargarDatos() async {
    token = context.read<ItemProvider>().token;
    alamcenId = context.read<ItemProvider>().almacen;
    clienteSeleccionado = context.read<ItemProvider>().client;
    listaPedidos = await PedidosServices().getPedidosCliente(context, clienteSeleccionado.clienteId, alamcenId, token);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        elevation: 0,
        backgroundColor: const Color(0xFFFD725A),
        title: const Text('Pedidos del Cliente'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clienteSeleccionado.nombre,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  Text(clienteSeleccionado.codCliente,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                      color: Colors.black54.withOpacity(0.6)
                    )
                  )
                ],
              ),
            ),
            const Divider(thickness: 2.0),
            Expanded(
              child: ListView.builder(
                itemCount: listaPedidos.length,
                itemBuilder: (context, i) {
                  var pedido = listaPedidos[i];
                  return ListTile(
                    onTap: () {
                      Provider.of<ItemProvider>(context, listen: false).setPedido(pedido);
                      appRouter.push('/pedidoInterno');
                    },
                    title: Text(pedido.numeroOrdenTrabajo),
                    subtitle: Text('Estado: ${pedido.estado}'),
                    trailing: IconButton(
                      onPressed: (){
                        Provider.of<ItemProvider>(context, listen: false).setPedido(pedido);
                        appRouter.push('/nuevoPedido');
                      },
                      icon: const Icon(Icons.edit,size: 25,),
                      
                    ),
                  );
                }
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Provider.of<ItemProvider>(context, listen: false).setPedido(Pedido.empty());
                      appRouter.push('/nuevoPedido');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFD725A),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text(
                        'Nuevo Pedido',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: Colors.white.withOpacity(0.9)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      )
    );
  }
}
