class Client {
  late int clienteId;
  late String codCliente;
  late String ruc;
  late String nombre;
  late String direccion;
  late String departamento;
  late String telefono1;
  late String telefono2;
  late String fax;
  late String email;
  late String localidad;
  late int departamentoId;
  late int vendedorId;
  late int descuento1;
  late int descuento2;
  late int descuento3;
  late int pagoId;
  late bool suspendido;
  late bool reembolso;
  late int monedaId;
  late int creditoConcedido;
  late int creditoUtilizado;
  late int rubroContable;
  late bool imprime;
  late String observacion;
  late String signo;
  late int descuentoFac1;
  late int descuentoFac3;
  late int descuentoFac2;
  late int tipoListaId;
  late String codTipoLista;
  late String sobreQue;
  late int porcentaje;
  late int tListaSigno;
  late String codTipoCliente;
  late bool controlaDtos;
  late bool soloContado;
  late String agrupador;
  late bool vendFijo;
  late bool clienteContado;
  late int codPais;
  late String pais;
  late String codigo;
  late String modoLista;
  late bool ignorarDtoMax;
  late bool reqDatosAdicionalesOc;
  late bool reqDatosAdicionalesOcnc;
  late bool envio;
  late bool remitos;
  late int monedaIdDef;
  late int tipoClienteId;
  late String tipoLista;
  late int monedaIdLista;

  Client({
    required this.clienteId,
    required this.codCliente,
    required this.ruc,
    required this.nombre,
    required this.direccion,
    required this.departamento,
    required this.telefono1,
    required this.telefono2,
    required this.fax,
    required this.email,
    required this.localidad,
    required this.departamentoId,
    required this.vendedorId,
    required this.descuento1,
    required this.descuento2,
    required this.descuento3,
    required this.pagoId,
    required this.suspendido,
    required this.reembolso,
    required this.monedaId,
    required this.creditoConcedido,
    required this.creditoUtilizado,
    required this.rubroContable,
    required this.imprime,
    required this.observacion,
    required this.signo,
    required this.descuentoFac1,
    required this.descuentoFac2,
    required this.descuentoFac3,
    required this.tipoListaId,
    required this.codTipoLista,
    required this.sobreQue,
    required this.tListaSigno,
    required this.porcentaje,
    required this.codTipoCliente,
    required this.controlaDtos,
    required this.soloContado,
    required this.agrupador,
    required this.vendFijo,
    required this.clienteContado,
    required this.codPais,
    required this.pais,
    required this.codigo,
    required this.modoLista,
    required this.ignorarDtoMax,
    required this.reqDatosAdicionalesOc,
    required this.reqDatosAdicionalesOcnc,
    required this.envio,
    required this.remitos,
    required this.monedaIdDef,
    required this.tipoClienteId,
    required this.tipoLista,
    required this.monedaIdLista,
  });

  static Client fromJson(Map json) => Client(
        clienteId: json["clienteId"] as int? ?? 0,
        codCliente: json["codCliente"] as String? ?? '',
        ruc: json["ruc"] as String? ?? '',
        nombre: json["nombre"] as String? ?? '',
        direccion: json["direccion"] as String? ?? '',
        departamento: json["departamento"] as String? ?? '',
        telefono1: json["telefono1"] as String? ?? '',
        telefono2: json["telefono2"] as String? ?? '',
        fax: json["fax"] as String? ?? '',
        email: json["email"] as String? ?? '',
        localidad: json["localidad"] as String? ?? '',
        departamentoId: json["departamentoId"] as int? ?? 0,
        vendedorId: json["vendedorId"] as int? ?? 0,
        descuento1: json["descuento1"] as int? ?? 0,
        descuento2: json["descuento2"] as int? ?? 0,
        descuento3: json["descuento3"] as int? ?? 0,
        pagoId: json["pagoId"] as int? ?? 0,
        suspendido: json["suspendido"] as bool? ?? false,
        reembolso: json["reembolso"] as bool? ?? false,
        monedaId: json["monedaId"] as int? ?? 0,
        creditoConcedido: json["creditoConcedido"] as int? ?? 0,
        creditoUtilizado: json["creditoUtilizado"] as int? ?? 0,
        rubroContable: json["rubroContable"] as int? ?? 0,
        imprime: json["imprime"] as bool? ?? false,
        observacion: json["observacion"] as String? ?? '',
        signo: json["signo"] as String? ?? '',
        descuentoFac1: json["descuentoFac1"] as int? ?? 0,
        descuentoFac2: json["descuentoFac2"] as int? ?? 0,
        descuentoFac3: json["descuentoFac3"] as int? ?? 0,
        tipoListaId: json["tipoListaId"] as int? ?? 0,
        codTipoLista: json["codTipoLista"] as String? ?? '',
        sobreQue: json["sobreQue"] as String? ?? '',
        tListaSigno: json["tListaSigno"] as int? ?? 0,
        porcentaje: json["porcentaje"] as int? ?? 0,
        codTipoCliente: json["codTipoCliente"] as String? ?? '',
        controlaDtos: json["controlaDtos"] as bool? ?? false,
        soloContado: json["soloContado"] as bool? ?? false,
        agrupador: json["agrupador"] as String? ?? '',
        vendFijo: json["vendFijo"] as bool? ?? false,
        clienteContado: json["clienteContado"] as bool? ?? false,
        codPais: json["codPais"] as int? ?? 0,
        pais: json["pais"] as String? ?? '',
        codigo: json["codigo"] as String? ?? '',
        modoLista: json["modoLista"] as String? ?? '',
        ignorarDtoMax: json["ignorarDtoMax"] as bool? ?? false,
        reqDatosAdicionalesOc: json["reqDatosAdicionalesOC"] as bool? ?? false,
        reqDatosAdicionalesOcnc: json["reqDatosAdicionalesOCNC"] as bool? ?? false,
        envio: json["envio"] as bool? ?? false,
        remitos: json["remitos"] as bool? ?? false,
        monedaIdDef: json["monedaIdDef"] as int? ?? 0,
        tipoClienteId: json["tipoClienteId"] as int? ?? 0,
        tipoLista: json["tipoLista"] as String? ?? '',
        monedaIdLista: json["monedaIdLista"] as int? ?? 0,
      );

  Client.empty() {
    clienteId = 0;
    codCliente = '';
    ruc = '';
    nombre = '';
    direccion = '';
    departamento = '';
    telefono1 = '';
    telefono2 = '';
    fax = '';
    email = '';
    localidad = '';
    departamentoId = 0;
    vendedorId = 0;
    descuento1 = 0;
    descuento2 = 0;
    descuento3 = 0;
    pagoId = 0;
    suspendido = false;
    reembolso = false;
    monedaId = 0;
    creditoConcedido = 0;
    creditoUtilizado = 0;
    rubroContable = 0;
    imprime = false;
    observacion = '';
    signo = '';
    descuentoFac1 = 0;
    descuentoFac2 = 0;
    descuentoFac3 = 0;
    tipoListaId = 0;
    codTipoLista = '';
    sobreQue = '';
    tListaSigno = 0;
    porcentaje = 0;
    codTipoCliente = '';
    controlaDtos = false;
    soloContado = false;
    agrupador = '';
    vendFijo = false;
    clienteContado = false;
    codPais = 0;
    pais = '';
    codigo = '';
    modoLista = '';
    ignorarDtoMax = false;
    reqDatosAdicionalesOc = false;
    reqDatosAdicionalesOcnc = false;
    envio = false;
    remitos = false;
    monedaIdDef = 0;
    tipoClienteId = 0;
    tipoLista = '';
    monedaIdLista = 0;
  }

  @override
  String toString() {
    return 'Instance of Client: $nombre';
  }
}
