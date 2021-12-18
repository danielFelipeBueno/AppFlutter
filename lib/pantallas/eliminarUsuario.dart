import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:misiontic/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class eliminarUsuario extends StatefulWidget {
  @override
  eliminarUsuarioState createState() => eliminarUsuarioState();
}

class eliminarUsuarioState extends State<eliminarUsuario> {
  final cedula = TextEditingController();
  CollectionReference usuario =
      FirebaseFirestore.instance.collection("usuario");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eliminar usuario"),
      ),
      drawer: menu(),
      body: ListView(
        children: [
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
                if (cedula.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Cedula vacio", backgroundColor: Colors.red, textColor: Colors.white,
                      toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
                } else if (validador == 1) {
                  Fluttertoast.showToast(msg: "Cedula no valida", backgroundColor: Colors.red, textColor: Colors.white,
                      toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
                } else {
                  QuerySnapshot existe = await usuario
                      .where(FieldPath.documentId, isEqualTo: cedula.text)
                      .get();
                    if (existe.docs.length == 0) {
                      Fluttertoast.showToast(msg: "Usuario no encontrado", backgroundColor: Colors.red, textColor: Colors.white,
                          toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
                    } else {
                      usuario.doc(cedula.text).delete();
                      cedula.text = "";
                      Fluttertoast.showToast(msg: "Usuario eliminado", backgroundColor: Colors.green, textColor: Colors.white,
                          toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
                    }

                }
              },
              child: Text("Eliminar"),
            ),
          ),
        ],
      ),
    );
  }
}
