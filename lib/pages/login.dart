// ignore_for_file: use_build_context_synchronously, avoid_print, unrelated_type_equality_checks

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showroom_maqueta/config/router/app_router.dart';
import 'package:showroom_maqueta/services/login_services.dart';
// import 'package:showroom_maqueta/config/router/app_router.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
// import 'package:showroom_maqueta/services/login_services.dart';


class LoginNew extends StatefulWidget {
  static const String name = 'login';
  const LoginNew({super.key});

  @override
  State<LoginNew> createState() => _LoginNewState();
}

class _LoginNewState extends State<LoginNew> {
  bool isObscured = true;
  final _formKey = GlobalKey<FormState>();
  final passwordFocusNode = FocusNode();
  final userFocusNode = FocusNode();
  String user = '';
  String pass = '';
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _loginServices = LoginServices();
  String tokenActual = '';
  bool hayConexion = false;
  String currentDate = '';
  bool esValidoLogin = false;


  @override
  void initState() {
    super.initState();
    
    
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void guardarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', tokenActual);
  }

  Future obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('token');
    return jsonString;
  }

  void guardarFecha(String fecha) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fecha', fecha);
  }

  Future obtenerFecha() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('fecha');
    return jsonString;
  }

  bool mas24Horas(DateTime fecha1, DateTime fecha2) {
  // Calculate the difference in hours between the two DateTime values
    int differenceInHours = fecha1.difference(fecha2).inSeconds;

    // Check if the absolute difference in hours is greater than or equal to 24
    return differenceInHours.abs() >= 30;
  }






  Future<bool> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.2,
              child: Image.asset('images/nyp-logo.png')
            ),
            const SizedBox(height: 15,),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Bienvenido',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Inicie Sesion',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 35),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width /1.5,
                          child: TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: const Icon(Icons.person),
                              prefixIconColor: Colors.black,
                              hintText: 'Ingrese su usuario'
                            ),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Ingrese un usuario valido';
                              }
                              return null;
                            },
                            onSaved: (newValue) => user = newValue!
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width /1.5,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: isObscured,
                            focusNode: passwordFocusNode,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(),
                                  borderRadius:
                                      BorderRadius.circular(20)),
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: const Icon(Icons.lock),
                              prefixIconColor: Colors.black,
                              suffixIcon: IconButton(padding: const EdgeInsetsDirectional.only(end: 12.0),
                                icon: isObscured
                                    ? const Icon(
                                        Icons.visibility_off,
                                        color: Colors.black,
                                      )
                                    : const Icon(Icons.visibility,
                                        color: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    isObscured = !isObscured;
                                  });
                                },
                              ),
                              hintText: 'Ingrese su contraseña'
                            ),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Ingrese su contraseña';
                              }
                              if (value.length < 6) {
                                return 'La contraseña debe tener mas de 5 caracteres';
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) async {
                              await intentoLogin(context);                                  
                            },
                            onSaved: (newValue) => pass = newValue!
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 211, 0, 41)),
                            elevation: WidgetStatePropertyAll(10),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(50),
                                  right: Radius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            await intentoLogin(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.5),
                            child: Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                color:  Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ), 
                        const SizedBox(height: 50,),
                        Container(
                          alignment: Alignment.center,
                          child: FutureBuilder(
                            future: PackageInfo.fromPlatform(),
                            builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  'Versión ${snapshot.data!.version} (Build ${snapshot.data!.buildNumber})',
                                  style: const TextStyle(color: Colors.black),
                                );
                              } else {
                                return const Text('Cargando la app...');
                              }
                            }
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> intentoLogin(BuildContext context) async {
    hayConexion = await _checkConnectivity();
      print(hayConexion);
      if(!hayConexion){
      
        DateTime fechaComparar = DateTime.parse(await obtenerFecha());
      
        print(fechaComparar);
      
        if(mas24Horas(DateTime.now(),fechaComparar)){
          
          showDialog(context: context, builder: (context){
            return  AlertDialog(
              title: const Center(child: Text('El token expiro')),
              content: const Text('Intente logear nuevamente cuando tenga conexion'),
              actions: [
                TextButton(
                  onPressed: (){
                    appRouter.pop();
                  },
                  child: const Text('Ok.')
                ),            
              ],
            );
          });
        }else{
          Provider.of<ItemProvider>(context, listen: false).setToken(await obtenerToken());
          showDialog(context: context, builder: (context){
            return  AlertDialog(
              title: const Center(child: Text('Esta entrando sin conexion')),
              content: const Text('Seguro que quiere entrar sin conexion?, sera conectado con el ultimo almacen utilizado'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: (){
                    appRouter.pop();
                  },
                  child: const Text('Cancelar', textAlign: TextAlign.start,)
                ),
                TextButton(onPressed: (){
                  // appRouter.pop();
                  // appRouter.push('/product_add');
                },
                child: const Text('Continuar sin Conexion'))            
              ],
            );
          });
        }
      }
      else { 
        esValidoLogin = await login(context);
        if (esValidoLogin){
          tokenActual = context.read<ItemProvider>().token;
          guardarToken(tokenActual);
          print('Token:');
          print(tokenActual);
          
          currentDate = DateTime.now().toIso8601String();
          guardarFecha(currentDate);
          print('Fecha:');
          print(currentDate);
          
          appRouter.push('/select_origin');
        }
       
      }
  }
    

  Future<bool> login(BuildContext context) async {
    bool esValido = false;

    await _loginServices.login(
      usernameController.text,
      passwordController.text,
      context,
    );
    

    if (_formKey.currentState?.validate() == true) {
      
      late int? statusCode = 0;
      statusCode = await _loginServices.getStatusCode();

      if (statusCode == 200) {
        appRouter.pushReplacement('/select_origin');
        esValido = true;

      } else if (statusCode == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciales inválidas. Intente nuevamente.'),
            backgroundColor: Colors.red,
          ),
        );
        print('Credenciales inválidas. Intente nuevamente.');
      }
    }
    return esValido;
  }
}