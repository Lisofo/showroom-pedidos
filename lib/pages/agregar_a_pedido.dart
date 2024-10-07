// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';


class AgregarPedido extends StatelessWidget {
  List listItems = [
    'AH-5838',
    'AH-2311',
    'AH-4444',
    'AD-1234',
  ];

  AgregarPedido({super.key});

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
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Buscar o escanear item...'
                  ),
                )
              ),
            ),
            const Divider(thickness: 2.0,),
            const SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(
                      Icons.image,
                      size: 50,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, 'paginaProducto');
                    },
                    title: Text(listItems[index]),
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
