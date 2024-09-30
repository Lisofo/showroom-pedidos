import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Inicie Sesion',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3.5,
                  decoration: BoxDecoration(
                      // border: Border.all(style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      hintText: 'Ingrese PIN',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, 'origen');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                    decoration: BoxDecoration(
                        color: Color(0xFFFD725A),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      'Iniciar Sesion',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 1),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
