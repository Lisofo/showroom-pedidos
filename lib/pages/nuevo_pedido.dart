// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../widgets/dropdown.dart';
import '../widgets/fechas.dart';

class NuevoPedido extends StatefulWidget {
  const NuevoPedido({super.key});

  @override
  State<NuevoPedido> createState() => _NuevoPedidoState();
}

class _NuevoPedidoState extends State<NuevoPedido> {
// descuento

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Pedido'),
        elevation: 0,
        backgroundColor: const Color(0xFFFD725A),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Pedido: ',
                  style: TextStyle(fontSize: 24),
                ),
                Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    width: MediaQuery.of(context).size.width / 10,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      initialValue: '2023V.86.1',
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Fechas(),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Descripcion: ',
                  style: TextStyle(fontSize: 24),
                ),
                Container(
                    decoration: BoxDecoration(
                        // border: Border.all(),
                        borderRadius: BorderRadius.circular(5)),
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 10,
                      decoration: const InputDecoration(
                          // border: InputBorder.none,
                          hintText: 'Ingrese Descripcion'),
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const CrearDropdown(),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text('Descuento: ', style: TextStyle(fontSize: 24)),
                Container(
                  width: MediaQuery.of(context).size.width / 5,
                  decoration: BoxDecoration(
                      // border: Border.all(),
                      borderRadius: BorderRadius.circular(5)),
                  child: const TextField(
                    decoration: InputDecoration(),
                  ),
                )
              ],
            ),
            const Expanded(child: Text('')),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.popAndPushNamed(context, 'pedidoInterno');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFD725A),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      'Agregar',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: Colors.white.withOpacity(0.9)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
