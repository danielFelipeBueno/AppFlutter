import 'package:flutter/material.dart';
import 'package:misiontic/pantallas/busquedaCategorias.dart';
import 'package:misiontic/main.dart';

class categorias extends StatelessWidget {
  const categorias({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grupo 4 equipo 1',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Categorias'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (Colors.blueGrey),
      appBar: AppBar(
        title: Text("Barrio"),
        actions: <Widget>[
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          )
        ],
      ),
      drawer: menu(),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ],
            ),
          ),
          busquedaCategorias(),
        ],
      ),
    );
  }
}
