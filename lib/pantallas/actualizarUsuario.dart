import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:misiontic/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class actualizarUsuario extends StatefulWidget {
  @override
  actualizarUsuarioState createState() => actualizarUsuarioState();
}

class actualizarUsuarioState extends State<actualizarUsuario> {
  final cedula = TextEditingController();
  final nombre = TextEditingController();
  final apellido = TextEditingController();
  final correo = TextEditingController();
  final celular = TextEditingController();

  CollectionReference usuario =
      FirebaseFirestore.instance.collection("usuario");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar y actualizar usuario"),
        actions: <Widget>[
          Builder(
            builder: (context){
              return IconButton(
                icon: Icon(Icons.arrow_back_rounded ),
                onPressed: (){
                  Navigator.pop(context);
                },
              );
            },
          )
        ],
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
                  Fluttertoast.showToast(msg: "Cedula vacia", backgroundColor: Colors.red, textColor: Colors.white,
                      toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
                } else if (validador == 1) {
                  Fluttertoast.showToast(msg: "Datos invalidos", backgroundColor: Colors.red, textColor: Colors.white,
                      toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
                } else {
                  QuerySnapshot existe = await usuario
                      .where(FieldPath.documentId, isEqualTo: cedula.text)
                      .get();
                  if (existe.docs.length == 0) {
                    Fluttertoast.showToast(msg: "La cedula no existe", backgroundColor: Colors.red, textColor: Colors.white,
                        toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
                  } else {
                    List personas = [];
                    for (var p in existe.docs) {
                      setState(() {
                        personas.add(p.data());
                      });
                    }
                    nombre.text = personas[0]['nombre'].toString();
                    apellido.text = personas[0]['apellidos'].toString();
                    celular.text = personas[0]['celular'].toString();
                    correo.text = personas[0]['correo'].toString();
                  }
                }
              },
              child: Text("Buscar"),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              controller: nombre,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  icon: Icon(Icons.add_reaction_outlined,
                      color: Colors.black, size: 40),
                  hintText: "Digita tu nombre",
                  hintStyle: TextStyle(
                      color: Colors.black12, fontStyle: FontStyle.italic)),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              controller: apellido,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  icon:
                      Icon(Icons.my_library_add, color: Colors.black, size: 40),
                  hintText: "Digita tu apellido",
                  hintStyle: TextStyle(
                      color: Colors.black12, fontStyle: FontStyle.italic)),
            ),
          ),
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
              controller: celular,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  icon: Icon(Icons.add_call, color: Colors.black, size: 40),
                  hintText: "Digita tu celular",
                  hintStyle: TextStyle(
                      color: Colors.black12, fontStyle: FontStyle.italic)),
            ),
          ),
          Container(
            padding: EdgeInsets.all(40.0),
            child: ElevatedButton(
              onPressed: () async {
                var cc, tel;
                var validador = 0;
                try {
                  cc = int.parse(cedula.text);
                  tel = int.parse(cedula.text);
                } catch (e) {
                  validador = 1;
                }
                if (cedula.text.isEmpty ||
                    nombre.text.isEmpty ||
                    apellido.text.isEmpty ||
                    correo.text.isEmpty ||
                    celular.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Campos Vacios", backgroundColor: Colors.red, textColor: Colors.white,
                      toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
                } else if (validador == 1) {
                  Fluttertoast.showToast(msg: "Datos invalidos", backgroundColor: Colors.red, textColor: Colors.white,
                      toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
                } else {
                  QuerySnapshot existe = await usuario
                      .where(FieldPath.documentId, isEqualTo: cedula.text)
                      .get();
                  if (existe.docs.length != 0) {
                    usuario.doc(cedula.text).set({
                      "nombre": nombre.text,
                      "apellidos": apellido.text,
                      "correo": correo.text,
                      "celular": celular.text
                    });
                    cedula.text = "";
                    nombre.text = "";
                    apellido.text = "";
                    correo.text = "";
                    celular.text = "";
                    Fluttertoast.showToast(msg: "Usuario actualizado", backgroundColor: Colors.green, textColor: Colors.white,
                        toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
                  }else{
                    Fluttertoast.showToast(msg: "Cedula no valida", backgroundColor: Colors.red, textColor: Colors.white,
                        toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
                  }
                }
              },
              child: Text("Actualizar"),
            ),
          )
        ],
      ),
    );
  }
}
