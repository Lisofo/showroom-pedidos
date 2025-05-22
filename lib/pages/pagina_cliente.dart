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
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

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

  Future<void> _refreshData() async {
    listaPedidos = [];
    setState(() {});
    await cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        elevation: 0,
        backgroundColor: colores.primary,
        title: Text('Pedidos del Cliente', style: TextStyle(color: colores.onPrimary),),
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
                      color: Colors.black54.withValues(alpha: 0.6)
                    )
                  )
                ],
              ),
            ),
            const Divider(thickness: 2.0),
            Expanded(
              child: RefreshIndicator(
                key: _refreshKey,
                onRefresh: _refreshData,
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
                      subtitle: Text('Estado: ${pedido.estado}\nFecha: ${_formatDateAndTime(pedido.fechaOrdenTrabajo)}\n${pedido.comentarioCliente}'),
                      trailing: const Icon(Icons.chevron_right,size: 25,),
                    );
                  }
                ),
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
                        color: colores.primary,
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text(
                        'Nuevo Pedido',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: Colors.white.withValues(alpha: 0.9)
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
  
  String _formatDateAndTime(DateTime? date) {
    return '${date?.day.toString().padLeft(2, '0')}/${date?.month.toString().padLeft(2, '0')}/${date?.year.toString().padLeft(4, '0')}';
  }
}
