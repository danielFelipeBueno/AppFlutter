import 'package:firebase_messaging/firebase_messaging.dart';


class generarToken{
FirebaseMessaging generar = FirebaseMessaging.instance;

notificaciones(){
  generar.requestPermission();
  generar.getToken().then((token) {
    print("Este es el token");
    print(token);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) { //app esta abierto

  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) { //app en segundo plano

  });

  FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async { //app cerrada

  });
}
}