import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:misiontic/pantallas/listadoNegocios.dart';
import 'package:misiontic/main.dart';

class busquedaCategorias extends StatefulWidget {

  @override
  State<busquedaCategorias> createState() => _MyAppState();
}

class _MyAppState extends State<busquedaCategorias> {

  void initState() {
    super.initState();
    getNegocioss();
    print(login.usu.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
         child: GridView.builder(
            itemCount: categoriasDefinitiva.length,
            itemBuilder: (BuildContext context,i){
              return ListTile(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ListadoNegocios(categoria: categoriasDefinitiva[i].toString() )));
                },
                title: miTarjeta1(texto: categoriasDefinitiva[i].toString())
              );

            }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: 2,
           crossAxisSpacing: 18,
           mainAxisSpacing: 18,
         )
        )
    );

  }

  List negocios = [];

 Set categorias = Set();

  List categoriasDefinitiva = [];

  var tam;

  void getNegocioss() async {
    CollectionReference datos = FirebaseFirestore.instance.collection(
        "Negocios");
    QuerySnapshot personas = await datos.get();
    if (personas.docs.length > 0) {
      for (var p in personas.docs) {
        setState(() {
          negocios.add(p.data());
        });
      }
      for (var i = 0; i < negocios.length; i++) {
        categorias.add(negocios[i]['categoria'].toString());
      }

      categorias.forEach((element) {categoriasDefinitiva.add(element); });
    }
  }

}
class miTarjeta1 extends StatelessWidget {

  final String texto;

  const miTarjeta1({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      margin: EdgeInsets.all(5),
      elevation: 45,
      color: Colors.blueGrey,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Container(
            height: 100,
                color: Colors.white12,
                alignment: Alignment.center,
                margin: EdgeInsets.all(0.0),
                child: Text(texto,textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))
        ),
      ),
    );
  }
}

