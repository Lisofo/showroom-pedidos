// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/config/router/app_router.dart';
import 'package:showroom_maqueta/models/client.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/search/client_search_delegate.dart';

class BuscadorCliente extends StatefulWidget {
  const BuscadorCliente({super.key});

  @override
  State<BuscadorCliente> createState() => _BuscadorClienteState();
}

class _BuscadorClienteState extends State<BuscadorCliente> {
  late Client clienteSeleccionado = Client.empty();
  List<Client> historial = [];

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buscar Cliente',
          style: TextStyle(
            fontSize: 24,
            color: colores.onPrimary
          )
        ),
        elevation: 0,
        backgroundColor: colores.primary,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final cliente = await showSearch(
                context: context,
                delegate: ClientSearchDelegate('Buscar Cliente', historial)
              );
              if (cliente != null) {
                setState(() {
                  clienteSeleccionado = cliente;
                  final int clienteExiste = historial.indexWhere((element) => element.nombre == cliente.nombre);
                  if (clienteExiste == -1) {
                    historial.insert(0, cliente);
                  }
                  context.read<ItemProvider>().setClient(cliente);
                  appRouter.push('/client_page');
                });
              }
            },
          ),
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: historial.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      onTap: () {
                        appRouter.push('/client_page');
                      },
                      leading: const Icon(
                        Icons.person,
                        size: 42,
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        size: 50,
                      ),
                      title: Text(historial[i].nombre),
                    );
                  },
                ),
              ),
            ],
          ),
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
              child: const Text('Cancelar')
            ),
            TextButton(
              onPressed: () {
                Provider.of<ItemProvider>(context, listen: false).setToken('');
                appRouter.pushReplacement('/login');
              },
              child: const Text(
                'Cerrar Sesion',
                style: TextStyle(color: Colors.red),
              )
            ),
          ],
        );
      },
    );
  }
}
