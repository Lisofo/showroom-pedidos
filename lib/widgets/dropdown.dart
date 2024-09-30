import 'package:flutter/material.dart';

class CrearDropdown extends StatefulWidget {
  const CrearDropdown({super.key});

  @override
  State<CrearDropdown> createState() => _CrearDropdownState();
}

class _CrearDropdownState extends State<CrearDropdown> {
  List<String> _opcionesMoneda = ['U\$S', 'UYU'];
  String _opcionSeleccionada = 'UYU';

  List<DropdownMenuItem<String>> getOpcionesDropdown(){

    List<DropdownMenuItem<String>> lista = [];

    _opcionesMoneda.forEach((moneda){
      lista.add(DropdownMenuItem(
        child: Text(moneda),
        value: moneda,
      ));
    });
    return lista;
  }
  List<String> _opcionesTipo = ['Contado','Credito', 'Remito'];
  String _opcionTipo = 'Contado';

  List<DropdownMenuItem<String>> getOpcionesDropdownTipo(){

    List<DropdownMenuItem<String>> lista = [];

    _opcionesTipo.forEach((tipo){
      lista.add(DropdownMenuItem(
        child: Text(tipo),
        value: tipo,
      ));
    });
    return lista;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('Moneda:',
                    style: TextStyle(fontSize: 24)),
            SizedBox(width: 30,),
            DropdownButton(
              value: _opcionSeleccionada,
              items: getOpcionesDropdown(), 
              onChanged: (opt){
                setState(() {
                  _opcionSeleccionada = opt!;
                });
              }
            ),
            SizedBox(width: 50,),
            Text('Tipo:',
                    style: TextStyle(fontSize: 24)),
            SizedBox(width: 30,),
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