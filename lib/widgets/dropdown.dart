import 'package:flutter/material.dart';

class CrearDropdown extends StatefulWidget {
  const CrearDropdown({super.key});

  @override
  State<CrearDropdown> createState() => _CrearDropdownState();
}

class _CrearDropdownState extends State<CrearDropdown> {
  final List<String> _opcionesMoneda = ['U\$S', 'UYU'];
  String _opcionSeleccionada = 'UYU';

  List<DropdownMenuItem<String>> getOpcionesDropdown(){

    List<DropdownMenuItem<String>> lista = [];

    for (var moneda in _opcionesMoneda) {
      lista.add(DropdownMenuItem(
        value: moneda,
        child: Text(moneda),
      ));
    }
    return lista;
  }
  final List<String> _opcionesTipo = ['Contado','Credito', 'Remito'];
  String _opcionTipo = 'Contado';

  List<DropdownMenuItem<String>> getOpcionesDropdownTipo(){

    List<DropdownMenuItem<String>> lista = [];

    for (var tipo in _opcionesTipo) {
      lista.add(DropdownMenuItem(
        value: tipo,
        child: Text(tipo),
      ));
    }
    return lista;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text('Moneda:',
                    style: TextStyle(fontSize: 24)),
            const SizedBox(width: 30,),
            DropdownButton(
              value: _opcionSeleccionada,
              items: getOpcionesDropdown(), 
              onChanged: (opt){
                setState(() {
                  _opcionSeleccionada = opt!;
                });
              }
            ),
            const SizedBox(width: 50,),
            const Text('Tipo:',
                    style: TextStyle(fontSize: 24)),
            const SizedBox(width: 30,),
            DropdownButton(
              value: _opcionTipo,
              items: getOpcionesDropdownTipo(), 
              onChanged: (opt){
                setState(() {
                  _opcionTipo = opt!;
                });
              }
            ),
          ],
        )
      ],
    );
  }
}