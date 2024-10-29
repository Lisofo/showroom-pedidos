// ignore_for_file: must_be_immutable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/config/router/app_router.dart';
import 'package:showroom_maqueta/models/client.dart';
import 'package:showroom_maqueta/models/linea.dart';
import 'package:showroom_maqueta/models/pedido.dart';
import 'package:showroom_maqueta/models/reporte.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/services/pedidos_services.dart';
import 'package:showroom_maqueta/widgets/confirmacion.dart';
import 'package:showroom_maqueta/widgets/custom_form_field.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final TextEditingController comClienteController = TextEditingController();
  final TextEditingController envioController = TextEditingController();
  final List<String> _opcionesMoneda = ['U\$S', 'UYU'];
  String _opcionSeleccionada = 'UYU';
  late Pedido pedido = Pedido.empty();
  late DateTime fechaOrden = DateTime.now();
  late DateTime fechaVencimiento = DateTime.now();
  late DateTime? fechaEntrega = null;
  late Client cliente = Client.empty();
  late String token = '';
  int buttonIndex = 0;
  final List<String> _opcionesTipo = ['Contado','Credito', 'Remito'];
  String _opcionTipo = 'Contado';
  final _pedidosServices = PedidosServices();
  late List<Linea> lineasGenericas = [];
  late int cantidad = 0;
  late double costoTotal = 0.0;
  late String almacenId = '';
  late Reporte reporte = Reporte.empty();
  late int rptGenId = 0;
  late bool generandoInforme = false;
  late bool informeGeneradoEsS = false;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  cargarDatos() async {
    pedido = context.read<ItemProvider>().pedido;
    cliente = context.read<ItemProvider>().client;
    token = context.read<ItemProvider>().token;
    almacenId = context.read<ItemProvider>().almacen;
    if (pedido.ordenTrabajoId != 0) {
      numeroOrdenTrabajo.text = pedido.numeroOrdenTrabajo;
      comClienteController.text = pedido.comentarioCliente;
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
      lineasGenericas = context.read<ItemProvider>().lineasGenericas;
      for(var linea in lineasGenericas) {
        cantidad += linea.cantidad;
        costoTotal += linea.costoUnitario * linea.cantidad;
      }
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pedido.ordenTrabajoId == 0 ? 'Nuevo Pedido' : 'Datos del pedido',
          style: TextStyle(
            color: colores.onPrimary
          ),
        ),
        elevation: 0,
        backgroundColor: colores.primary,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(!generandoInforme)...[
                  Row(
                    children: [
                      const Text(
                        'Pedido: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: CustomTextFormField(
                          textAlign: TextAlign.center,
                          controller: numeroOrdenTrabajo,
                          maxLines: 1,
                        )
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const Text(
                        'Fecha: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          // border: Border.all(),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: _crearFecha(context)
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const Text(
                        'Vencimiento: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          // border: Border.all(),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: _crearFechaVencimiento(context)
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const Text(
                        'Entrega: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          // border: Border.all(),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: _crearFechaEntrega(context)
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  CustomTextFormField(
                    maxLines: 1,
                    hint: 'Descripción',
                    controller: descripcionController,
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const Text(
                        'Moneda:',
                        style: TextStyle(fontSize: 18)
                      ),
                      const SizedBox(width: 20,),
                      DropdownButton(
                        value: _opcionSeleccionada,
                        items: getOpcionesDropdown(), 
                        onChanged: (opt){
                          setState(() {
                            _opcionSeleccionada = opt!;
                          });
                        }
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const Text(
                        'Tipo:',
                        style: TextStyle(fontSize: 18)
                      ),
                      const SizedBox(width: 20,),
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
                  const SizedBox(height: 20,),
                  CustomTextFormField(
                    controller: comClienteController,
                    hint: 'Detalle',
                    minLines: 1,
                    maxLines: 10,
                  ),
                  const SizedBox(height: 20,),
                  CustomTextFormField(
                    hint: 'Método de envío',
                    controller: envioController,
                    minLines: 1,
                    maxLines: 10,
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
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Cantidad total: $cantidad',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          ),
                          Text(
                            'Costo total: ${pedido.signo} $costoTotal', 
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20,)
                ] else ... [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          color: colores.primary,
                          strokeWidth: 5,
                        ),
                      ),
                      const Text('Generando PDF, espere por favor.'),
                      TextButton(
                        onPressed: () async {
                          await PedidosServices().patchInforme(context, reporte, 'D', token);
                          generandoInforme = false;
                          setState(() {});
                        }, 
                        child: const Text('Cancelar'))
                    ],
                  )
                ]
              ],
            ),
          ),
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const[
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'Confirmar'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.print),
            label: 'Imprimir'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete_forever),
            label: 'Descartar'
          ),
        ],
        currentIndex: buttonIndex,
        onTap: (value) async {
          buttonIndex = value;
          switch (buttonIndex) {
            case 0:
              await postPutPedido(context);
            break;
            case 1:
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Imprimir'),
                    content: Text('Desea imprimir la OT: ${pedido.numeroOrdenTrabajo} con foto o sin foto?'),
                    actions: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              appRouter.pop();
                            },
                            child: const Text('Cancelar')
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await postInforme(context, true);
                              await generarInformeCompleto();
                            },
                            child: const Text('SI')
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await postInforme(context, false);
                              await generarInformeCompleto();
                            },
                            child: const Text('NO')
                          ),
                        ],
                      )
                    ],
                  );
                }
              );
            break;
            case 2:
            await showDialog(
              context: context, 
              builder: (context) {
                return AlertDialog(
                  title: const Text('Descartar'),
                  content: Text('Esta por descartar el pedido ${pedido.numeroOrdenTrabajo}. Esta seguro de querer descartarlo?'),
                  actions: [
                    TextButton(
                      onPressed: () {}, child: const Text('Cancelar')
                    ),
                    TextButton(
                      onPressed: () async {
                        int? statusCode;
                        if(pedido.ordenTrabajoId != 0){
                          await _pedidosServices.patchPedido(context, pedido.ordenTrabajoId, 3, token);
                          statusCode = await _pedidosServices.getStatusCode();
                          await _pedidosServices.resetStatusCode();
                          if(statusCode == 1) {
                            Carteles.showDialogs(context, 'Pedido descartado correctamente', true, true, true);
                          }
                        }
                      }, child: const Text('Confirmar')
                    ),
                  ],
                );
              }
            );
            break;
          }
        },
      ),
    );
  }

  Future<void> generarInformeCompleto() async {
    int contador = 0;
    generandoInforme = true;
    informeGeneradoEsS = false;
    
    setState(() {});
    while (contador < 15 && informeGeneradoEsS == false && generandoInforme){
      print(contador);
      
      reporte = await PedidosServices().getReporte(context, rptGenId, token);

      if(reporte.generado == 'S'){
        informeGeneradoEsS = true;
        await abrirUrl(reporte.archivoUrl, token);
        generandoInforme = false;
        setState(() {});
      }else{
        await Future.delayed(const Duration(seconds: 1));
      }
      contador++;
    }
    if(informeGeneradoEsS != true && generandoInforme){
      await popUpInformeDemoro();
      
      print('informe demoro en generarse');
    }
    
  }

  Future<void> postInforme(BuildContext context, bool conFoto) async {
    await PedidosServices().postInforme(context, almacenId, pedido, conFoto, token);
    rptGenId = context.read<ItemProvider>().rptGenId;
  }

  Future<void> postPutPedido(BuildContext context) async {
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
        comentarioCliente: comClienteController.text,
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
      await _pedidosServices.postPedido(context, nuevoPedido, token);
      Provider.of<ItemProvider>(context, listen: false).setPedido(nuevoPedido);
      appRouter.go('/pedidoInterno');
    } else {
      pedido.fechaOrdenTrabajo = fechaOrden;
      pedido.fechaVencimiento = fechaVencimiento;
      pedido.fechaEntrega = fechaEntrega;
      pedido.descripcion = descripcionController.text;
      pedido.transaccionId = 17;
      pedido.monedaId = 1;
      pedido.comentarioCliente = comClienteController.text;
      pedido.comentarioTrabajo = 'comentarioTrabajo';
      await _pedidosServices.putPedido(context, pedido, [], token);
      int? statusCode;
      statusCode = await _pedidosServices.getStatusCode();
      await _pedidosServices.resetStatusCode();
      if(statusCode == 1) {
        Carteles.showDialogs(context, "Pedido editado", false, false, false);
      }
      // appRouter.go('/client_page');
    }
  }

  Widget _crearFecha(BuildContext context) {
    return TextFormField(
      controller: fechaOrdenController,
      enableInteractiveSelection: false,
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_today),
        hintText: 'Fecha de pedido',
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

  abrirUrl(String url, String token) async {
    Dio dio = Dio();
    String link = url += '?authorization=$token';
    print(link);
    try {
      // Realizar la solicitud HTTP con el encabezado de autorización
      Response response = await dio.get(
        link,
        options: Options(
          headers: {
            'Authorization': 'headers $token',
          },
        ),
      );
      // Verificar si la solicitud fue exitosa (código de estado 200)
      if (response.statusCode == 200) {
        // Si la respuesta fue exitosa, abrir la URL en el navegador
        Uri uri = Uri.parse(url);
        await launchUrl(uri);
      } else {
        // Si la solicitud no fue exitosa, mostrar un mensaje de error
        print('Error al cargar la URL: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar errores de solicitud
      print('Error al realizar la solicitud: $e');
    }
  }

  Future<void> popUpInformeDemoro() async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Su PDF esta tardando demasiado en generarse, quiere seguir esperando?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                generandoInforme = false;
                await PedidosServices().patchInforme(context, reporte, 'D', token);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('No'),
            ),
            TextButton(
              child: const Text('Si'),
              onPressed: () async {
                Navigator.of(context).pop();
                print('dije SI');
                await generarInformeInfinite();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> generarInformeInfinite() async {
    
    generandoInforme = true;
    
    while (informeGeneradoEsS == false){
      reporte = await PedidosServices().getReporte(context, rptGenId, token);
      if(reporte.generado == 'S'){
        informeGeneradoEsS = true;
        await abrirUrl(reporte.archivoUrl, token);
        generandoInforme = false;
        setState(() {});
      }else{
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    setState(() {});

  }
}
