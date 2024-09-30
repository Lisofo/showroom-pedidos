import 'package:flutter/material.dart';

class SeleccionOrigen extends StatelessWidget {
  const SeleccionOrigen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'buscadorCliente');
              },
              child: Container(
                height: 200,
                width: 380,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30)),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'buscadorCliente');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30)),
                    child: Image.asset('images/ufo-logo.png')
                  )
                )
              ),
            ),
            SizedBox(width: 200,),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'buscadorCliente');
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30)),
                child: Image.asset('images/nyp.jpeg',)
              ),
            ),
          ],
        )
      ),
    );
  }
}
