import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart ';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:misiontic/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:misiontic/pantallas/mostrarProductos.dart';

class carritoCompra extends StatefulWidget {
  final String cliente;
  final String idnegocio;
  final List<datosPedido> pedido;

  const carritoCompra({required this.cliente, required this.idnegocio, required this.pedido});

  @override
  _carritoCompraState createState() => _carritoCompraState();
}

class _carritoCompraState extends State<carritoCompra> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrito de compras"),
      ),
      drawer: menu(),
      body: Center(
        child: ListView.builder(
            itemCount: widget.pedido.length,
            itemBuilder: (BuildContext context, i) {
              return ListTile(
                title: Text(widget.pedido[i].negocio + " - " + widget.pedido[i].nombreProducto +
                    " - " + widget.pedido[i].precio.toString() + " - " + widget.pedido[i].cant.toString() +
                    " - " + widget.pedido[i].total.toString()),
                trailing: IconButton(
                  onPressed: () {
                    widget.pedido.removeAt(i);
                    setState(() {});
                  },
                  icon: Icon(Icons.delete, size: 30, color: Colors.red),
                ),
              );
            }),
      ),
      bottomNavigationBar: confirmarPedido(listaPedido: widget.pedido, negocio: widget.idnegocio, usuario: widget.cliente),
    );
  }
}


class confirmarPedido extends StatefulWidget {
  final List<datosPedido> listaPedido;
  final String usuario;
  final String negocio;
  const confirmarPedido({required this.listaPedido, required this.negocio, required this.usuario});

  @override
  _confirmarPedidoState createState() => _confirmarPedidoState();
}

class _confirmarPedidoState extends State<confirmarPedido> {

  void registrarDetalle(idPedido){
    CollectionReference detalle = FirebaseFirestore.instance.collection("DetallePedido");

    for(var dat=0; dat<widget.listaPedido.length;dat++){
      detalle.add({
        "pedido": idPedido.toString(),
        "producto": widget.listaPedido[dat].nombreProducto,
        "cantidad": widget.listaPedido[dat].cant,
        "total": widget.listaPedido[dat].total
      });
    }
  }
  void registrarPedido(){

    DateTime hoy= new DateTime.now();
    DateTime fecha= new DateTime(hoy.year, hoy.month, hoy.day);
    int total=0;
    for(var i=0; i<widget.listaPedido.length;i++){
      total+=widget.listaPedido[i].total;
    }
    CollectionReference pedido = FirebaseFirestore.instance.collection("Pedidos");
    pedido.add({
      "cliente": widget.usuario,
      "persona": widget.negocio,
      "fecha": fecha,
      "total": total
    }).then((value) => registrarDetalle(value.id));
  }
  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      backgroundColor: Colors.blueGrey,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart_sharp, size: 30),
            label: "Agregar\nProductos"
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.app_registration, size: 30),
            label: "TOTAL"
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_business_sharp, size: 30),
            label: "Confirmar\nPedido"
        ),
      ],
      onTap: (indice){
        if(indice==0){
          Navigator.pop(context);
        }else if(indice==1){
          int total=0;
          for(var i=0; i<widget.listaPedido.length;i++){
            total+=widget.listaPedido[i].total;
          }
          showDialog(
              context: context,
              builder: (context)=>AlertDialog(
                title: Text("Total del pedido:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black)),
                contentPadding: EdgeInsets.all(30.0),
                content: Text("\$ "+total.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.lightBlue)),
              ));
        }else{
          showDialog(
              context: context,
              builder: (context)=>AlertDialog(
                title: Text("Confirmar el Pedido:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, fontStyle: FontStyle.italic)),
                contentPadding: EdgeInsets.all(30.0),
                content: Text("Deseas Confirmar la Compra?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.lightBlue)),
                actions: [
                  ElevatedButton(
                    onPressed: (){
                      registrarPedido();
                      Fluttertoast.showToast(msg: "La Compra ha sido Registrada", backgroundColor: Colors.green, textColor: Colors.white,
                          toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
                      for(var i =0;i<widget.listaPedido.length;i++){
                        widget.listaPedido.removeAt(i);
                        for(var i =0;i<widget.listaPedido.length;i++){
                          widget.listaPedido.removeAt(i);
                          for(var i =0;i<widget.listaPedido.length;i++){
                            widget.listaPedido.removeAt(i);
                            for(var i =0;i<widget.listaPedido.length;i++){
                              widget.listaPedido.removeAt(i);
                            }
                          }
                        }
                      }

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>mostrarProductos2(nombreTienda: widget.negocio)));
                    },
                    child: Text("Confirmar"),

                  ),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancelar"),

                  )
                ],
              ));
        }
      },
    );
  }
}

