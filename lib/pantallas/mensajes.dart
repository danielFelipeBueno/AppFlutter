import 'package:flutter/material.dart';
import 'generarToken.dart';



class mensajes extends StatefulWidget {

  @override
  _mensajesState createState() => _mensajesState();
}

class _mensajesState extends State<mensajes> {


  void initState(){
    super.initState();
    final mensaje = new generarToken();
    mensaje.notificaciones();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificaciones"),
      ),
    );
  }
}