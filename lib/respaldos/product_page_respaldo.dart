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

  ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBody(),
              MiddleBody(talles: talles),
              const SizedBox(
                height: 115,
              ),
              const BottomBody(),
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
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFD725A),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          'Atras',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              color: Colors.white.withValues(alpha: 0.9)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, 'pedidoInterno');
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFD725A),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          'Guardar',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              color: Colors.white.withValues(alpha: 0.9)),
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
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.blueGrey[200]),
      child: const Row(
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
      padding: const EdgeInsets.only(left: 10, right: 10, top: 25),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blueGrey[200]),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Image(
              height: 370,
              image: AssetImage(
                'images/AH-5838.jpeg',
              )),
          const SizedBox(
            width: 10,
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Descripcion: ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: const Text(
                              'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500,'),
                        )
                      ],
                    )),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const Text(
                      'Talles: ',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 90,
                    ),
                    for (int i = 0; i < widget.talles.length; i++)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF7F8FA),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(widget.talles[i]),
                      ),
                  ],
                ),
                Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Color:',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF031C3C),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('Disp:'),
                                    const SizedBox(width: 30  ,),
                                    for (int d = 0; d < widget.talles.length; d++)
                                      Container(
                                        margin:
                                            const EdgeInsets.symmetric(horizontal: 4),
                                        padding: const EdgeInsets.all(4),
                                        child: Text(d.toString()),
                                      )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Ped:'),
                                    const SizedBox(width: 35,),
                                    for (int d = 0; d < widget.talles.length; d++)
                                      Container(
                                        margin:
                                            const EdgeInsets.symmetric(horizontal: 4),
                                        padding: const EdgeInsets.all(4),
                                        child: Text(d.toString()),
                                      )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Precio:'),
                                    const SizedBox(width: 20,),
                                    for (int d = 0; d < widget.talles.length; d++)
                                      Container(
                                        margin:
                                            const EdgeInsets.symmetric(horizontal: 4),
                                        padding: const EdgeInsets.all(4),
                                        child: Text(d.toString()),
                                      )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Cant:'),
                                    const SizedBox(width: 30,),
                                    for (int d = 0; d < widget.talles.length; d++)
                                      Container(
                                        margin:
                                            const EdgeInsets.symmetric(horizontal: 4),
                                        padding: const EdgeInsets.all(4),
                                        child: Text(d.toString()),
                                      )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Color:',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 16, 255, 16),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('Disp:'),
                                    const SizedBox(width: 30  ,),
                                    for (int d = 0; d < widget.talles.length; d++)
                                      Container(
                                        margin:
                                            const EdgeInsets.symmetric(horizontal: 4),
                                        padding: const EdgeInsets.all(4),
                                        child: Text(d.toString()),
                                      )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Ped:'),
                                    const SizedBox(width: 35,),
                                    for (int d = 0; d < widget.talles.length; d++)
                                      Container(
                                        margin:
                                            const EdgeInsets.symmetric(horizontal: 4),
                                        padding: const EdgeInsets.all(4),
                                        child: Text(d.toString()),
                                      )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Precio:'),
                                    const SizedBox(width: 20,),
                                    for (int d = 0; d < widget.talles.length; d++)
                                      Container(
                                        margin:
                                            const EdgeInsets.symmetric(horizontal: 4),
                                        padding: const EdgeInsets.all(4),
                                        child: Text(d.toString()),
                                      )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Cant:'),
                                    const SizedBox(width: 30,),
                                    for (int d = 0; d < widget.talles.length; d++)
                                      Container(
                                        margin:
                                            const EdgeInsets.symmetric(horizontal: 4),
                                        padding: const EdgeInsets.all(4),
                                        child: Text(d.toString()),
                                      )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Row precioYMas() {
    return Row(
      children: [
        InkWell(
          onTap: _bajarContador,
          child: const Icon(
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
            decoration: const InputDecoration(
                constraints: BoxConstraints(
                    maxWidth: 40, maxHeight: 44, minWidth: 20, minHeight: 22)),
          ),
        ),
        InkWell(
          onTap: _incrementarContador,
          child: const Icon(
            Icons.add,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
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
        const Text(
          'Precio: UYU',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        const SizedBox(
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
            decoration: const InputDecoration(
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
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blueGrey[200]),
        child: const Column(
          children: [
            // SizedBox(
            //   height: 180,
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              padding: EdgeInsets.only(left: 10, right: 20, bottom: 10),
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
