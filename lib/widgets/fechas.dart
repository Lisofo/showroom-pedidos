import 'package:flutter/material.dart';

class Fechas extends StatefulWidget {
  const Fechas({super.key});

  @override
  State<Fechas> createState() => _FechasState();
}

class _FechasState extends State<Fechas> {
  String _fecha = '';
  final TextEditingController _inputFieldDateController = TextEditingController();
  String _fechaVencimiento = '';
  final TextEditingController _inputFieldDateControllerVencimiento =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
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
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Text(
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
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_today),
        hintText: 'Fecha de Compra',
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _selecDate(context);
      },
    );
  }

  _selecDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2090),
        locale: const Locale('es', 'UY'));
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
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_today),
        hintText: 'Fecha de Vencimiento',
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _selecDateVencimiento(context);
      },
    );
  }

  _selecDateVencimiento(BuildContext context) async {
    DateTime? pickedVencimiento = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2090),
        locale: const Locale('es', 'UY'));
    if (pickedVencimiento != null) {
      setState(() {
        _fechaVencimiento = pickedVencimiento.toString();
        _inputFieldDateControllerVencimiento.text = _fechaVencimiento;
      });
    }
  }
}
