import 'package:flutter/material.dart';
import 'package:misiontic/pantallas/listadoNegocios.dart';
import 'package:misiontic/pantallas/mostrarProductos.dart';
import 'package:misiontic/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:misiontic/pantallas/mapas.dart';


class mostrarNegocio extends StatelessWidget {
  final datosNegocios negocio;

  const mostrarNegocio({required this.negocio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(negocio.nombre),
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
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, i) {
            return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            mostrarProductos2(nombreTienda: negocio.nombre)));
              },
              title: miTarjeta2(imagen: negocio.logo, texto: "Nombre: "+negocio.nombre+
                  "\nCategoria: "+negocio.categoria+"\nCelular" + negocio.celular
                  +"\nDireccion: " + negocio.direccion
                  +"\nTeléfono: " + negocio.telefono),

            );
          },
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: (){
                  launch(negocio.pagina);
                },
                heroTag: null,
                child: Icon(Icons.add_link, size: 30, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              mapas(negocio: negocio)));
                },
                heroTag: null,
                child: Icon(Icons.map_outlined , size: 30, color: Colors.white),
              )
            ],
          ),
        )
    );
  }
}

class miTarjeta2 extends StatelessWidget {
  final String imagen;
  final String texto;

  const miTarjeta2({required this.imagen, required this.texto});

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



