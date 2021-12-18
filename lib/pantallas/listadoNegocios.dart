import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:misiontic/pantallas/busquedaCategorias.dart';
import 'package:misiontic/pantallas/mostrarNegocio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:misiontic/main.dart';

class ListadoNegocios extends StatefulWidget {
  final String categoria;

  const ListadoNegocios({required this.categoria});

  @override
  State<ListadoNegocios> createState() => _MyAppState(categoria);
}

class _MyAppState extends State<ListadoNegocios> {
  final String cat;

  _MyAppState(this.cat);

  void initState() {
    super.initState();
    getNegocios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(cat),
          actions: <Widget>[
            Builder(
              builder: (context){
                return IconButton(
                  icon: Icon(Icons.arrow_back_rounded ),
                  onPressed: (){
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
                );
              },
            )
          ],
        ),
      drawer: menu(),
        body: ListView.builder(
            itemCount: negocioSeleccionado.length,
            itemBuilder: (BuildContext context, i) {
              return ListTile(
                onTap: () {
                  datosNegocios negocio = new datosNegocios(
                      negocioSeleccionado[i]['categoria'].toString(),
                      negocioSeleccionado[i]['celular'].toString(),
                      negocioSeleccionado[i]['direccion'].toString(),
                      negocioSeleccionado[i]['geolocalizacion'],
                      negocioSeleccionado[i]['id'].toString(),
                      negocioSeleccionado[i]['logo'].toString(),
                      negocioSeleccionado[i]['nombre'].toString(),
                      negocioSeleccionado[i]['pagina'].toString(),
                      negocioSeleccionado[i]['telefono'].toString());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              mostrarNegocio(negocio: negocio)));
                },
                title: miTarjeta(
                    imagen: negocioSeleccionado[i]['logo'],
                    texto: "Nombre: " +
                        negocioSeleccionado[i]['nombre'].toString() +
                        "\nDireccion: " +
                        negocioSeleccionado[i]['direccion'].toString()),
              );
            }
            ),

    );
  }

  List negocios = [];

  List negocioSeleccionado = [];

  var tam;

  void getNegocios() async {
    CollectionReference datos =
        FirebaseFirestore.instance.collection("Negocios");
    QuerySnapshot personas = await datos.get();
    if (personas.docs.length > 0) {
      for (var p in personas.docs) {
        setState(() {
          negocios.add(p.data());
        });
      }
      for (var i = 0; i < negocios.length; i++) {
        if (negocios[i]['categoria'].toString() == cat) {
          negocioSeleccionado.add(negocios[i]);
        }
      }
    }
  }
}

class miTarjeta extends StatelessWidget {
  final String imagen;
  final String texto;

  const miTarjeta({required this.imagen, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      margin: EdgeInsets.all(30),
      elevation: 15,
      color: Colors.black,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Column(
          children: [
            Image.network(imagen, scale: 0.5),
            Container(
                color: Colors.black,
                margin: EdgeInsets.all(0.0),
                child: Text(texto,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)))
          ],
        ),
      ),
    );
  }
}

class datosNegocios {
  String categoria = "";
  String celular = "";
  String direccion = "";
  late GeoPoint geolocalizacion;
  String id = "";
  String logo = "";
  String nombre = "";
  String pagina = "";
  String telefono = "";

  datosNegocios(
      this.categoria,
      this.celular,
      this.direccion,
      this.geolocalizacion,
      this.id,
      this.logo,
      this.nombre,
      this.pagina,
      this.telefono);
}
