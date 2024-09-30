// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  List talles = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    '2XL',
    '3XL',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBody(),
              MiddleBody(talles: talles),
              SizedBox(
                height: 5,
              ),
              BottomBody(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                        decoration: BoxDecoration(
                            color: Color(0xFFFD725A),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          'Atras',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              color: Colors.white.withOpacity(0.9)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil('pedidoInterno', ModalRoute.withName('paginaCliente'));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                        decoration: BoxDecoration(
                            color: Color(0xFFFD725A),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          'Guardar',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              color: Colors.white.withOpacity(0.9)),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TopBody extends StatelessWidget {
  const TopBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.blueGrey[200]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'AH-5838',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class MiddleBody extends StatefulWidget {
  const MiddleBody({
    super.key,
    required this.talles,
  });

  final List talles;

  @override
  State<MiddleBody> createState() => _MiddleBodyState();
}

class _MiddleBodyState extends State<MiddleBody> {
  int _contador = 4;
  void _incrementarContador() {
    setState(() {
      _contador++;
    });
  }

  void _bajarContador() {
    setState(() {
      _contador--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 25),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blueGrey[200]),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image(
              height: 370,
              image: AssetImage(
                'images/AH-5838.jpeg',
              )),
          SizedBox(
            width: 10,
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                              'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500,', style: TextStyle(fontSize: 24),),
                        )
                      ],
                    )),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: tabla(),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

DataTable tabla() {
    return DataTable(
        border: TableBorder.all(),
        dataRowMaxHeight: 122,
        columns: [
          DataColumn(label: SizedBox(width: 38,),),
          DataColumn(label: Text('Talles'),),
          DataColumn(label: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Center(child: Text('XS',style: TextStyle(color: Colors.black),)),
          )),
          DataColumn(label: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Center(
              child: Text(
                "S",style: TextStyle(color: Colors.black),)),
          )),
          DataColumn(label: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Center(
              child: Text(
                "M",style: TextStyle(color: Colors.black),)),
          )),
          DataColumn(label: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Center(
              child: Text(
                "L",style: TextStyle(color: Colors.black),)),
          )),
          DataColumn(label: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Center(
              child: Text(
                "XL",style: TextStyle(color: Colors.black),)),
          )),
          DataColumn(label: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Center(
              child: Text(
                "2XL",style: TextStyle(color: Colors.black),)),
          )),
          DataColumn(label: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Center(
              child: Text(
                "3XL",style: TextStyle(color: Colors.black),)),
          )),
        ], 
        rows: [
          ultimaFila(Colors.red),
          ultimaFila(Colors.blue),
          ultimaFila(Colors.green),
          ultimaFila(Colors.purple),
          ultimaFila(Colors.lime),
        ],
      );
  }
  ultimaFila(miColor){
    return DataRow(cells: [
              DataCell(CircleAvatar(backgroundColor: miColor)),
              DataCell(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Disp:',style: TextStyle(fontSize: 16),),
                  SizedBox(height: 18,),
                  Text('Cant:',style: TextStyle(fontSize: 16),),
                  SizedBox(height: 18,),
                  Text('Precio:',style: TextStyle(fontSize: 16),),
                ],
              )),
              DataCell(Column(
                children: [
                  Text('100'),
                  cantidad2(),
                  precio(),
                ],
              )),
              DataCell(Column(
                children: [
                  Text('100'),
                  cantidad2(),
                  precio(),
                ],
              )),
              DataCell(Column(
                children: [
                  Text('100'),
                  cantidad(),
                  precio(),
                ],
              )),
              DataCell(Column(
                children: [
                  Text('100'),
                  cantidad(),
                  precio(),
                ],
              )),
              DataCell(Column(
                children: [
                  Text('100'),
                  cantidad(),
                  precio(),
                ],
              )),
              DataCell(Column(
                children: [
                  Text('100'),
                  cantidad(),
                  precio(),
                ],
              )),
              DataCell(Column(
                children: [
                  Text('100'),
                  cantidad2(),
                  precio(),
                ],
              )),
            ]);
  }

  TextFormField precio() => TextFormField(initialValue: '890.0',textAlign: TextAlign.right,);

  cantidad() {
    return SizedBox(
      height: 30,
      width: 60,
      child: TextField(
        enabled: false,
        maxLength: 3,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: "",
          counterText: "",
          fillColor: Colors.grey[300],
          filled: true,
          border: InputBorder.none,
        ),),
    );
  }
cantidad2() {
    return SizedBox(
      height: 30,
      width: 60,
      child: TextField(
        
        maxLength: 3,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: "",
          counterText: "",
          fillColor: Colors.grey[300],
          filled: true,
          border: InputBorder.none,
        ),),
    );
  }


  Row precioYMas() {
    return Row(
      children: [
        InkWell(
          onTap: _bajarContador,
          child: Icon(
            Icons.remove,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              // border: Border.all(),
              color: Colors.white,
              borderRadius: BorderRadius.circular(4)),
          child: TextFormField(
            textAlign: TextAlign.center,
            initialValue: '$_contador',
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                constraints: BoxConstraints(
                    maxWidth: 40, maxHeight: 44, minWidth: 20, minHeight: 22)),
          ),
        ),
        InkWell(
          onTap: _incrementarContador,
          child: Icon(
            Icons.add,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Disponibles:',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              Text(
                '20',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pedidos:',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              Text(
                '10',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              )
            ],
          ),
        ),
        Text(
          'Precio: UYU',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
              // border: Border.all(),
              color: Colors.white,
              borderRadius: BorderRadius.circular(4)),
          child: TextFormField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            initialValue: '237.5',
            decoration: InputDecoration(
                constraints: BoxConstraints(
                    maxWidth: 50, maxHeight: 39, minWidth: 30, minHeight: 22)),
          ),
        ),
      ],
    );
  }
}

class BottomBody extends StatelessWidget {
  const BottomBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blueGrey[200]),
        child: Column(
          children: [
            // SizedBox(
            //   height: 180,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Cantidad de Items:',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '4',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Precio Total:',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '\$900.54',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
