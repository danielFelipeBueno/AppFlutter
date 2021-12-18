import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:misiontic/pantallas/mostrarNegocio.dart';
import 'package:misiontic/pantallas/listadoNegocios.dart';
import 'package:misiontic/main.dart';

class busqueda extends StatefulWidget {
  final String criterio;
  const busqueda(this.criterio, {Key? key}) : super(key: key);

  @override
  _busquedaState createState() => _busquedaState();
}

class _busquedaState extends State<busqueda> {

  List resultadoBusqueda=[];
  List resultadoBusqueda2=[];
  var  a = 1;


  void initState(){
    super.initState();
    getCriterio();
  }

  void getCriterio() async{
    CollectionReference negocio= FirebaseFirestore.instance.collection("Negocios");
    QuerySnapshot porNegocio= await negocio.where("nombre", isEqualTo: widget.criterio).get();

    CollectionReference productos= FirebaseFirestore.instance.collection("producto");
    QuerySnapshot porProductos = await productos.where("nombre", isEqualTo: widget.criterio).get();

    if(porNegocio.docs.length!=0){
      for(var negocio in porNegocio.docs){
        setState(() {
          resultadoBusqueda.add(negocio.data());
        });
      }
      a=0;
    }else if(porProductos.docs.length!=0){
      for(var producto in porProductos.docs){
        setState(() {
          resultadoBusqueda.add(producto.data());
        });
      }
    }
    else{
      Fluttertoast.showToast(msg: "No se encontraron datos", backgroundColor: Colors.red, textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Resultado de:  "+widget.criterio),
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
        body: Column(
          children: <Widget>[

          Expanded(
          child: ListView.builder(
              itemCount: resultadoBusqueda.length,
              itemBuilder: (BuildContext context,i){
                if(a==1){
                  return ListTile(
                    onTap: () {
                      //CUANDO SEA PRODUCTO ACÁ TIENEN QUE ADICIONARLO AL CARRITO
                    },
                    title: miTarjeta3(imagen: resultadoBusqueda[i]['imagen'],
                texto: "Producto: "+resultadoBusqueda[i]['nombre'].toString()+
                "\nNegocio: "+ resultadoBusqueda[i]['negocio'].toString(),

                  ));
                }else{
                  return ListTile(
                      onTap: () {
                        datosNegocios negocio = new datosNegocios(
                            resultadoBusqueda[i]['categoria'].toString(),
                            resultadoBusqueda[i]['celular'].toString(),
                            resultadoBusqueda[i]['direccion'].toString(),
                            resultadoBusqueda[i]['geolocalizacion'],
                            resultadoBusqueda[i]['id'].toString(),
                            resultadoBusqueda[i]['logo'].toString(),
                            resultadoBusqueda[i]['nombre'].toString(),
                            resultadoBusqueda[i]['pagina'].toString(),
                            resultadoBusqueda[i]['telefono'].toString());
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  mostrarNegocio(negocio: negocio)));
                      },
                      title: miTarjeta3(imagen: resultadoBusqueda[i]['logo'],
                        texto: "Negocio: "+resultadoBusqueda[i]['nombre'].toString()+
                            "\nTelefono: "+ resultadoBusqueda[i]['telefono'].toString()
                          +   "\nDireccion: "+ resultadoBusqueda[i]['direccion'].toString(),
                      ));
                }
              }
          )
          ),
          ],
        )
                ,



    );
  }
}

class miTarjeta3 extends StatelessWidget {
  final String imagen;
  final String texto;

  const miTarjeta3({required this.imagen, required this.texto});

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

