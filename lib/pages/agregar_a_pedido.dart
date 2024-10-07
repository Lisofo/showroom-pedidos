// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  late String codAlmacen = '';
  late String token = '';
  final TextEditingController query = TextEditingController();
  bool activo = false;

  @override
  void initState() { 
    super.initState();
    cargarDatos();
  }

  cargarDatos() async {
    codAlmacen = context.read<ItemProvider>().almacen;
    token = context.read<ItemProvider>().token;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Item'),
        elevation: 0,
        backgroundColor: const Color(0xFFFD725A),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  controller: query,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Buscar o escanear item...',
                    suffixIcon: Icon(Icons.search)
                  ),
                  onFieldSubmitted: (value) {
                    query.text = value;
                    ProductServices().getProductByName(query.text, '2', '1', '', '0', token);
                    setState(() {});
                  },
                ),
              ),
            ),
            const Divider(thickness: 2.0,),
            const SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listItems.length,
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
            ),
          ],
        )
      ),
    );
  }
}
