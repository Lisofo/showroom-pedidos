import 'package:flutter/material.dart';

class Fechas extends StatefulWidget {
  const Fechas({super.key});

  @override
  State<Fechas> createState() => _FechasState();
}

class _FechasState extends State<Fechas> {
  String _fecha = '';
  TextEditingController _inputFieldDateController = new TextEditingController();
  String _fechaVencimiento = '';
  TextEditingController _inputFieldDateControllerVencimiento =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Fecha: ',
              style: TextStyle(fontSize: 24),
            ),
            Container(
                decoration: BoxDecoration(
                    // border: Border.all(),
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width / 5,
                child: _crearFecha(context))
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text(
              'Fecha de Vencimiento: ',
              style: TextStyle(fontSize: 24),
            ),
            Container(
                decoration: BoxDecoration(
                    // border: Border.all(),
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width / 5,
                child: _crearFechaVencimiento(context))
          ],
        ),
      ],
    );
  }

  Widget _crearFecha(BuildContext context) {
    return TextField(
      controller: _inputFieldDateController,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        icon: Icon(Icons.calendar_today),
        hintText: 'Fecha de Compra',
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selecDate(context);
      },
    );
  }

  _selecDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2090),
        locale: Locale('es', 'UY'));
    if (picked != null) {
      setState(() {
        _fecha = picked.toString();
        _inputFieldDateController.text = _fecha;
      });
    }
  }

  Widget _crearFechaVencimiento(BuildContext context) {
    return TextField(
      controller: _inputFieldDateControllerVencimiento,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        icon: Icon(Icons.calendar_today),
        hintText: 'Fecha de Vencimiento',
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selecDateVencimiento(context);
      },
    );
  }

  _selecDateVencimiento(BuildContext context) async {
    DateTime? pickedVencimiento = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2090),
        locale: Locale('es', 'UY'));
    if (pickedVencimiento != null) {
      setState(() {
        _fechaVencimiento = pickedVencimiento.toString();
        _inputFieldDateControllerVencimiento.text = _fechaVencimiento;
      });
    }
  }
}
