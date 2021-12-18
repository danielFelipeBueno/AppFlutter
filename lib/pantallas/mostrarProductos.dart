import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:misiontic/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:misiontic/pantallas/carritoCompra.dart';

class mostrarProductos2 extends StatefulWidget {

  final String nombreTienda;
  //final String cedulaCliente;

  const mostrarProductos2({required this.nombreTienda});

  @override
  State<mostrarProductos2> createState() => _MyAppState(nombreTienda);
}

class _MyAppState extends State<mostrarProductos2> {
  List codigos=[];
  static List <datosPedido> pedido=[];
  miTarjetita2 tar = new miTarjetita2(imagen: "imagen", texto: "texto", precio: "precio", nombreNegocio: "nombreNegocio", nombre: "nombre");
  //

  final String tienda;

  _MyAppState(this.tienda);

  void initState() {
    super.initState();
    getProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(tienda),

          actions: [

            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>carritoCompra(cliente: login.usu.cedula, idnegocio: widget.nombreTienda, pedido: pedido)));
            }, icon: Icon(Icons.add_shopping_cart_sharp)),

            IconButton(onPressed: (){
             Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_rounded )),

          ],
        ),
        drawer: menu(),
        body: ListView.builder(
            itemCount: productosSeleccionados.length,
            itemBuilder: (BuildContext context, i) {
              return ListTile(
                onTap: () {},
                title: miTarjetita2(
                  imagen: productosSeleccionados[i]['imagen'],
                  texto: "" + productosSeleccionados[i]['nombre'].toString() + "\nPrecio: " + productosSeleccionados[i]['precio'].toString(),
                  precio: productosSeleccionados[i]['precio'].toString(),
                  nombreNegocio: productosSeleccionados[i]['negocio'],
                  nombre: productosSeleccionados[i]['nombre'],
                ),
              );
            })
    );
  }
  List productos = [];

  List productosSeleccionados = [];

  var tam;

  void getProductos() async {
    CollectionReference datos = FirebaseFirestore.instance.collection("producto");
    QuerySnapshot producto = await datos.get();
    if (producto.docs.length > 0) {
      for (var p in producto.docs) {
        setState(() {
          productos.add(p.data());
        });
      }
      for (var i = 0; i < productos.length; i++) {
        if (productos[i]['negocio'].toString() == tienda) {
          productosSeleccionados.add(productos[i]);
        }
      }
      print(productosSeleccionados.length);
    }
  }
}
//Mi Tarjetita 2
class miTarjetita2 extends StatefulWidget {
  final String imagen;
  final String texto;
  final String precio;
  final String nombreNegocio;
  final String nombre;

  const miTarjetita2({required this.imagen, required this.texto, required this.precio,required this.nombreNegocio, required this.nombre});

  @override
  _miTarjetita2State createState() => _miTarjetita2State(imagen,texto);

}

class _miTarjetita2State extends State<miTarjetita2> {

  final String imagen;
  final String texto;
  int _conteo = 0;
  int _total = 0;

  _miTarjetita2State(this.imagen, this.texto);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      margin: EdgeInsets.all(10),
      elevation: 10,
      color: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Row(
          children: [
            Column(
              children: [
                SizedBox(width: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 15),
                    Image.network(imagen, width: 150.0,height: 150.0),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(0.0),
                      child: Text(texto,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),

              ],
            ),
            Column(
              children: [
                Center(
                  child: Center(
                    child :Column(
                      children: [
                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.center,
                          child: Text("Cantidadd",style: TextStyle(fontSize: 18),),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            TextButton(
                              onPressed: (){
                                _restar();
                              },
                              child: Text("-",style: TextStyle(fontSize: 27),),
                              style: TextButton.styleFrom(
                                primary: Colors.indigoAccent,

                              ),
                            ),
                            SizedBox(width: 10,),
                            Text('$_conteo', style: TextStyle(fontSize: 15),),
                            SizedBox(width: 10,),
                            TextButton(
                              onPressed: (){
                                _sumar();
                              },
                              child: Text("+",style: TextStyle(fontSize: 27),),
                              style: TextButton.styleFrom(
                                primary: Colors.indigoAccent,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text("Total: \$$_total", style: TextStyle(fontSize: 15),),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            if(_conteo != 0){
                              datosPedido ped = datosPedido(widget.nombreNegocio, widget.nombre, _conteo, int.parse(widget.precio), _total);
                              _MyAppState.pedido.add(ped);
                              Fluttertoast.showToast(
                                  msg: "Producto añadido",
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER);
                              _conteo = 0;
                              _total = 0;
                              setState(() {});
                            }else{
                              Fluttertoast.showToast(
                                  msg: "Añade algun producto",
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER);
                            }


                          },
                          child: Text("Agregar"),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.indigoAccent
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _sumar(){
    setState(() =>_conteo++);
    _total = _conteo * int.parse(widget.precio);
    setState(()=>_total);
  }
  void _restar(){
    if(_conteo > 0){
      setState(()=>_conteo--);
      if(_total > 0){
        _total -= int.parse(widget.precio);
        setState(()=>_total);
      }
    }
  }
}

class datosPedido{
  String negocio="";
  String nombreProducto="";
  int cant = 0;
  int precio = 0;
  int total = 0;

  datosPedido(this.negocio, this.nombreProducto, this.cant, this.precio, this.total);
}
