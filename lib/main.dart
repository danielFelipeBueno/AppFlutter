import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:misiontic/pantallas/actualizarUsuario.dart';
import 'package:misiontic/pantallas/busqueda.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:misiontic/pantallas/categorias.dart';
import 'package:misiontic/pantallas/eliminarUsuario.dart';
import 'package:misiontic/pantallas/formularioUsuario.dart';
import 'package:misiontic/pantallas/carritoCompra.dart';

//void main()=> runApp(const MyApp());
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(const paginaPrincipalll());
  });
}

class paginaPrincipalll extends StatelessWidget {
  const paginaPrincipalll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grupo 4 equipo 1',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const paginaPrincipal(title: 'Login'),
    );
  }
}

class paginaPrincipal extends StatefulWidget {
  const paginaPrincipal({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<paginaPrincipal> createState() => login();
}

class login extends State<paginaPrincipal> {
  static Usuario usu = new Usuario();
  final cedula = TextEditingController();
  final correo = TextEditingController();

  CollectionReference usuario =
      FirebaseFirestore.instance.collection("usuario");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: correo,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  icon:
                      Icon(Icons.email_rounded, color: Colors.black, size: 40),
                  hintText: "Ingresa tu correo",
                  hintStyle: TextStyle(
                      color: Colors.black12, fontStyle: FontStyle.italic)),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: cedula,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  icon: Icon(Icons.fingerprint_outlined,
                      color: Colors.black, size: 40),
                  hintText: "Digita numero de cedula",
                  hintStyle: TextStyle(
                      color: Colors.black12, fontStyle: FontStyle.italic)),
              obscureText: true,
            ),
          ),
          Container(
            padding: EdgeInsets.all(40.0),
            child: ElevatedButton(
              onPressed: () async {
                var cc;
                var validador = 0;
                try {
                  cc = int.parse(cedula.text);
                } catch (e) {
                  validador = 1;
                }
                if (cedula.text.isEmpty || correo.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Campos vacios",
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER);
                } else if (validador == 1) {
                  Fluttertoast.showToast(
                      msg: "Datos invalidos",
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER);
                } else {
                  QuerySnapshot existeCedula = await usuario
                      .where(FieldPath.documentId, isEqualTo: cedula.text)
                      .get();
                  QuerySnapshot existeCorreo = await usuario
                      .where(FieldPath.documentId, isEqualTo: correo.text)
                      .get();
                  if (existeCedula.docs.length == 0 &&
                      existeCorreo.docs.length == 0) {
                    Fluttertoast.showToast(
                        msg: "Usuario o contraseña incorrecto",
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER);
                  } else {
                    List usuar = [];
                    for (var p in existeCedula.docs) {
                      setState(() {
                        usuar.add(p.data());
                      });
                    }
                    login.usu.correo = usuar[0]["correo"].toString();
                    login.usu.celular = usuar[0]["celular"].toString();
                    login.usu.apellido = usuar[0]["apellidos"].toString();
                    login.usu.nombre = usuar[0]["nombre"].toString();
                    login.usu.cedula = usuar[0]["cedula"].toString();
                    Fluttertoast.showToast(
                        msg: "Bienvenido",
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => categorias()));
                  }
                }
              },
              child: Text("INGRESAR"),
            ),
          ),
          Container(
            padding: EdgeInsets.all(40.0),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => formularioUsuario()));
              },
              child: Text("Registrate"),
            ),
          )
        ],
      ),
    );
  }
}

class Usuario {
  String cedula = "";
  String nombre = "";
  String correo = "";
  String celular = "";
  String apellido = "";

  Usuario();

  @override
  String toString() {
    return 'Usuario{cedula: $cedula, nombre: $nombre, correo: $correo, celular: $celular, apellido: $apellido}';
  }
}

class menu extends StatelessWidget {
  TextEditingController dato = TextEditingController();

//
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(

            title: Text(
              "\nBienvenido a Barrio",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
          ),
          ListTile(
            trailing: Icon(Icons.verified, size: 30, color: Colors.blue),
            title: Text(
              login.usu.nombre + " " + login.usu.apellido,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
          ),
          ListTile(
            leading: Icon(Icons.search, size: 30, color: Colors.blue),
            title: TextField(
                controller: dato,
                decoration: InputDecoration(
                  hintText: "Buscar ",
                )),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => busqueda(dato.text)));
            },
          ),
          ListTile(
            trailing: Icon(Icons.upgrade, size: 30, color: Colors.blue),
            title: Text(
              "Buscar y actualizar Datos",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => actualizarUsuario()));
            },
          ),
          ListTile(
            trailing: Icon(Icons.delete, size: 30, color: Colors.blue),
            title: Text(
              "Eliminar usuario",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => eliminarUsuario()));
            },
          ),
          ListTile(
            trailing: Icon(Icons.priority_high, size: 30, color: Colors.blue),
            title: Text(
              "Categorias",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => categorias()));
            },
          ),
          ListTile(
            trailing: Icon(Icons.logout_outlined, size: 30, color: Colors.blue),
            title: Text(
              "Cerrar sesión",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            onTap: () {
              login.usu.apellido = "";
              login.usu.nombre = "";
              login.usu.celular = "";
              login.usu.correo = "";
              login.usu.cedula = "";
              Fluttertoast.showToast(
                  msg: "Hasta luego",
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER);

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => paginaPrincipalll()));
            },
          ),
       /*   ListTile(
            trailing: Icon(Icons.shopping_cart_outlined,
                size: 30, color: Colors.blue),
            title: Text(
              "mensajes",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => mensajes()));
            },
          ),*/
        ],
      ),
    );
  }
}
