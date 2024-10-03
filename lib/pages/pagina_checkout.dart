import 'package:flutter/material.dart';

class PaginaCheckout extends StatelessWidget {
  const PaginaCheckout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        elevation: 0,
        backgroundColor: const Color(0xFFFD725A),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Condiciones:',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 3.5,
                          child: const TextField(
                            minLines: 1,
                            maxLines: 10,
                            // decoration:
                            //     InputDecoration(border: OutlineInputBorder()),
                          ))
                    ],
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Metodo de Envio:',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 3.5,
                          child: const TextField(
                            minLines: 1,
                            maxLines: 10,
                            // decoration:
                            //     InputDecoration(border: OutlineInputBorder()),
                          ))
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total de Articulos:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 140,
                  ),
                  Text(
                    '4',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total del Pedido:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'UYU \$950.54',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
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
                        'Guardar Pedido',
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
        )),
      ),
    );
  }
}
