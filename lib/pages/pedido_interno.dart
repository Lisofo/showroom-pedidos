import 'package:flutter/material.dart';
import '../widgets/productos_samples.dart';

class PedidoInterno extends StatelessWidget {
  const PedidoInterno({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Pedido 114',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                fontSize: 30,
                color: Colors.black)),
        elevation: 0,
        backgroundColor: Color(0xFFFD725A),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 30,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, 'nuevoPedido');
                      },
                      child: Icon(Icons.more_horiz, size: 30),
                    ),
                  ]),
            ),
            Container(
              padding: EdgeInsets.only(top: 15, bottom: 5),
              child: Column(
                children: [
                  ProductosSamples(),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Seleccionar Todos',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 65,
                      ),
                      Checkbox(
                          activeColor: Color(0xFFFD725A),
                          value: true,
                          onChanged: (value) {}),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Cantidad de Items:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 41,
                        ),
                        Text(
                          '4',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Total A Pagar:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          '\$950.00',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, 'checkout');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 50),
                          decoration: BoxDecoration(
                              color: Color(0xFFFD725A),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            'Confirmar Pedido',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                color: Colors.white.withOpacity(0.9)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, 'agregarAPedido');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 50),
                          decoration: BoxDecoration(
                              color: Color(0xFFFD725A),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            'Agregar Item',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                color: Colors.white.withOpacity(0.9)),
                          ),
                        ),
                      ),
                      SizedBox(width: 40,),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 50),
                          decoration: BoxDecoration(
                              color: Color(0xFFFD725A),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            'Imprimir',
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
            )
          ],
        )),
      ),
    );
  }
}
