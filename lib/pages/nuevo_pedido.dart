// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../widgets/dropdown.dart';
import '../widgets/fechas.dart';

class NuevoPedido extends StatefulWidget {
  @override
  State<NuevoPedido> createState() => _NuevoPedidoState();
}

class _NuevoPedidoState extends State<NuevoPedido> {
// descuento

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Pedido'),
        elevation: 0,
        backgroundColor: Color(0xFFFD725A),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
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
            SizedBox(
              height: 20,
            ),
            Fechas(),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
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
                      decoration: InputDecoration(
                          // border: InputBorder.none,
                          hintText: 'Ingrese Descripcion'),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            CrearDropdown(),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text('Descuento: ', style: TextStyle(fontSize: 24)),
                Container(
                  width: MediaQuery.of(context).size.width / 5,
                  decoration: BoxDecoration(
                      // border: Border.all(),
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    decoration: InputDecoration(),
                  ),
                )
              ],
            ),
            Expanded(child: Text('')),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.popAndPushNamed(context, 'pedidoInterno');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    decoration: BoxDecoration(
                        color: Color(0xFFFD725A),
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
