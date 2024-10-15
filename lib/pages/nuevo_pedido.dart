// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/config/router/app_router.dart';
import 'package:showroom_maqueta/models/client.dart';
import 'package:showroom_maqueta/models/pedido.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/services/pedidos_services.dart';

class NuevoPedido extends StatefulWidget {
  const NuevoPedido({super.key});

  @override
  State<NuevoPedido> createState() => _NuevoPedidoState();
}

class _NuevoPedidoState extends State<NuevoPedido> {

  final TextEditingController numeroOrdenTrabajo = TextEditingController();
  String _fecha = '';
  final TextEditingController fechaOrdenController = TextEditingController();
  String _fechaVencimiento = '';
  final TextEditingController fechaVencimientoController = TextEditingController();
  String _fechaEntrega = '';
  final TextEditingController fechaEntregaController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final List<String> _opcionesMoneda = ['U\$S', 'UYU'];
  String _opcionSeleccionada = 'UYU';
  late Pedido pedido = Pedido.empty();
  late DateTime fechaOrden = DateTime.now();
  late DateTime fechaVencimiento = DateTime.now();
  late DateTime fechaEntrega = DateTime.now();
  late Client cliente = Client.empty();
  late String token = '';

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  cargarDatos() async {
    pedido = context.read<ItemProvider>().pedido;
    cliente = context.read<ItemProvider>().client;
    token = context.read<ItemProvider>().token;
    if (pedido.ordenTrabajoId != 0) {
      numeroOrdenTrabajo.text = pedido.numeroOrdenTrabajo;
      fechaOrdenController.text = pedido.fechaOrdenTrabajo == null ? '' : _formatDateAndTime(pedido.fechaOrdenTrabajo);
      fechaVencimientoController.text = pedido.fechaVencimiento == null ? "" : _formatDateAndTime(pedido.fechaVencimiento);
      fechaEntregaController.text = pedido.fechaEntrega == null ? '' : _formatDateAndTime(pedido.fechaEntrega);
      if (pedido.fechaOrdenTrabajo != null) {
        fechaOrden = pedido.fechaOrdenTrabajo!;
      }
      if (pedido.fechaVencimiento != null) {
        fechaVencimiento = pedido.fechaVencimiento!;
      }
      if (pedido.fechaEntrega != null) {
        fechaEntrega = pedido.fechaEntrega!;
      }
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(pedido.ordenTrabajoId == 0 ? 'Nuevo Pedido' : 'Editar Pedido'),
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
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    width: MediaQuery.of(context).size.width / 10,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: numeroOrdenTrabajo,
                    )
                  )
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Text(
                    'Fecha: ',
                    style: TextStyle(fontSize: 24),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      // border: Border.all(),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    width: MediaQuery.of(context).size.width / 5,
                    child: _crearFecha(context)
                  )
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Text(
                    'Fecha de Vencimiento: ',
                    style: TextStyle(fontSize: 24),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      // border: Border.all(),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    width: MediaQuery.of(context).size.width / 5,
                    child: _crearFechaVencimiento(context)
                  )
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Text(
                    'Fecha de Entrega: ',
                    style: TextStyle(fontSize: 24),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      // border: Border.all(),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    width: MediaQuery.of(context).size.width / 5,
                    child: _crearFechaEntrega(context)
                  )
                ],
              ),
              const SizedBox(height: 20,),
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
                      borderRadius: BorderRadius.circular(5)
                    ),
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        // border: InputBorder.none,
                        hintText: 'Ingrese Descripcion'
                      ),
                      controller: descripcionController,
                    )
                  )
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Text('Moneda:',
                    style: TextStyle(fontSize: 24)
                  ),
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
                    style: TextStyle(fontSize: 24)
                  ),
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
              ),
              // const SizedBox(height: 20,),
              // Row(
              //   children: [
              //     const Text('Descuento: ', style: TextStyle(fontSize: 24)),
              //     Container(
              //       width: MediaQuery.of(context).size.width / 5,
              //       decoration: BoxDecoration(
              //         // border: Border.all(),
              //         borderRadius: BorderRadius.circular(5)
              //       ),
              //       child: const TextField(
              //         decoration: InputDecoration(),
              //       ),
              //     )
              //   ],
              // ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      if(pedido.ordenTrabajoId == 0){
                        Pedido nuevoPedido = Pedido(
                          ordenTrabajoId: 0,
                          numeroOrdenTrabajo: numeroOrdenTrabajo.text,
                          fechaOrdenTrabajo: fechaOrden,
                          descripcion: descripcionController.text,
                          transaccionId: 17,
                          clienteId: cliente.clienteId,
                          codCliente: cliente.codCliente,
                          ruc: cliente.ruc,
                          nombre: cliente.nombre,
                          monedaId: 1,
                          codMoneda: '1',
                          descMoneda: '',
                          signo: '',
                          totalOrdenTrabajo: 0,
                          comentarioCliente: 'comentarioCliente',
                          comentarioTrabajo: 'comentarioTrabajo',
                          estado: '',
                          presupuestoIdPlantilla: 0,
                          numeroPresupuesto: '',
                          descripcionPresupuesto: '',
                          totalPresupuesto: 0,
                          fechaVencimiento: fechaVencimiento,
                          fechaEntrega: fechaEntrega,
                          plantilla: false,
                          unidadId: 0,
                          km: 0,
                          servicio: '',
                          central: '',
                          credito: false
                        );
                        await PedidosServices().postPedido(context, nuevoPedido, token);
                        Provider.of<ItemProvider>(context, listen: false).setPedido(nuevoPedido);
                        appRouter.go('/pedidoInterno');
                      } else {
                        pedido.fechaOrdenTrabajo = fechaOrden;
                        pedido.fechaVencimiento = fechaVencimiento;
                        pedido.fechaEntrega = fechaEntrega;
                        pedido.descripcion = descripcionController.text;
                        pedido.transaccionId = 17;
                        pedido.monedaId = 1;
                        pedido.comentarioCliente = 'comentarioCliente';
                        pedido.comentarioTrabajo = 'comentarioTrabajo';
                        await PedidosServices().putPedido(context, pedido, [], token);
                        appRouter.go('/client_page');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFD725A),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text(
                        'Confirmar',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: Colors.white.withOpacity(0.9)
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ),
    );
  }

  Widget _crearFecha(BuildContext context) {
    return TextFormField(
      controller: fechaOrdenController,
      enableInteractiveSelection: false,
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_today),
        hintText: 'Fecha de Compra',
      ),
      textAlign: TextAlign.center,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _selecDate(context);
      },
    );
  }

  _selecDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaOrden,
      firstDate: DateTime(2020),
      lastDate: DateTime(2090),
      locale: const Locale('es', 'UY')
    );
    if (picked != null) {
      setState(() {
        fechaOrden = picked;
        _fecha = _formatDateAndTime(picked);
        fechaOrdenController.text = _fecha;
      });
    }
  }

  Widget _crearFechaVencimiento(BuildContext context) {
    return TextFormField(
      controller: fechaVencimientoController,
      enableInteractiveSelection: false,
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_today),
        hintText: 'Fecha de Vencimiento',
      ),
      textAlign: TextAlign.center,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _selecDateVencimiento(context);
      },
    );
  }

  _selecDateVencimiento(BuildContext context) async {
    DateTime? pickedVencimiento = await showDatePicker(
      context: context,
      initialDate: fechaVencimiento,
      firstDate: DateTime(2020),
      lastDate: DateTime(2090),
      locale: const Locale('es', 'UY')
    );
    if (pickedVencimiento != null) {
      setState(() {
        fechaVencimiento = pickedVencimiento;
        _fechaVencimiento = _formatDateAndTime(pickedVencimiento);
        fechaVencimientoController.text = _fechaVencimiento;
      });
    }
  }
  Widget _crearFechaEntrega(BuildContext context) {
    return TextFormField(
      controller: fechaEntregaController,
      enableInteractiveSelection: false,
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_today),
        hintText: 'Fecha de Entrega',
      ),
      textAlign: TextAlign.center,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _selecDateEntrega(context);
      },
    );
  }

  _selecDateEntrega(BuildContext context) async {
    DateTime? pickedEntrega = await showDatePicker(
      context: context,
      initialDate: fechaEntrega,
      firstDate: DateTime(2020),
      lastDate: DateTime(2090),
      locale: const Locale('es', 'UY')
    );
    if (pickedEntrega != null) {
      setState(() {
        fechaEntrega = pickedEntrega;
        _fechaEntrega = _formatDateAndTime(pickedEntrega);
        fechaEntregaController.text = _fechaEntrega;
      });
    }
  }

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

  String _formatDateAndTime(DateTime? date) {
    return '${date?.day.toString().padLeft(2, '0')}/${date?.month.toString().padLeft(2, '0')}/${date?.year.toString().padLeft(4, '0')}';
  }
}
