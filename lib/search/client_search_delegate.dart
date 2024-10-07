
// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/models/client.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/services/client_services.dart';

class ClientSearchDelegate extends SearchDelegate{

  @override
  final String searchFieldLabel;
  final List<Client> historial;
  ClientSearchDelegate(this.searchFieldLabel, this.historial);



  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(
        onPressed: ()=>query='', 
        icon: const Icon(Icons.clear)
      ),
    ];
    
  }

  @override
  Widget? buildLeading(BuildContext context) {
   return IconButton(
    onPressed: ()=>close(context, null), 
    icon: const Icon(Icons.arrow_back_ios_new),
  );
  }

  @override
  Widget buildResults(BuildContext context) {
    
    if(query.trim().isEmpty){
      return const Text('No hay valor en el query');
    }

    final clientServices = ClientServices();
    final almacen = context.watch<ItemProvider>().almacen;
    final token = context.watch<ItemProvider>().token;
    final vendedorId = context.watch<ItemProvider>().vendedorId;
    final List<String> searchParams = query.split(" ");

    String codigo = '';
    String nombre = '';
    String ruc = '';

    if (searchParams.length >= 2) {
      codigo = searchParams[0];
      nombre = searchParams.sublist(1).join(' ');
    } else {
      if (int.tryParse(searchParams[0]) != null) {
        codigo = searchParams[0];
        nombre = '';
      } else {
        codigo = '';
        nombre = searchParams[0];
      }
    }

    return FutureBuilder(
      future: clientServices.getClientes(context, nombre, ruc, codigo, almacen, vendedorId, token),
      builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const ListTile(
            title: Text('No hay ningún cliente con ese nombre'),
          );
        }

        if (snapshot.hasData) {
          // print(snapshot.data);
          return _showClient(snapshot.data!);
        } else {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 4),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    return _showClient(historial);
  }

  Widget _showClient(List<Client> clients){

    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, i){

        final cliente = clients[i];
        return ListTile(
          title: Text(cliente.nombre),
          subtitle: Text(cliente.codCliente),
          onTap: (){
            // Provider.of<ItemProvider>(context, listen: false).setClient(cliente);
            close(context, cliente);
          },
        );
      }
    );


  }

 
}