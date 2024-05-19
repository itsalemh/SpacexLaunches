import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(AplicacionSpaceX());
}

class AplicacionSpaceX extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  @override
  _PantallaPrincipalEstado createState() => _PantallaPrincipalEstado();
}

class _PantallaPrincipalEstado extends State<PantallaPrincipal> {
  List<dynamic> lanzamientos = [];

  @override
  void initState() {
    super.initState();
    obtenerLanzamientos();
  }

  Future<void> obtenerLanzamientos() async {
    var url = Uri.parse('https://api.spacexdata.com/v5/launches');
    var respuesta = await http.get(url);
    if (respuesta.statusCode == 200) {
      var datos = json.decode(respuesta.body);
      setState(() {
        lanzamientos = datos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lanzamientos SpaceX'),
      ),
      body: ListView.builder(
        itemCount: lanzamientos.length,
        itemBuilder: (context, index) {
          var lanzamiento = lanzamientos[index];
          var imagenes = lanzamiento['links']['flickr']['original'];
          var imagenCohete =
              (imagenes != null && imagenes.isNotEmpty) ? imagenes[0] : '';

          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Misión: ${lanzamiento['name']}'),
                Text('Fecha: ${lanzamiento['date_utc']}'),
                Text(
                    'Estado: ${lanzamiento['success'] != null ? (lanzamiento['success'] ? "Éxito" : "Fallo") : "Desconocido"}'),
                if (imagenCohete.isNotEmpty) Image.network(imagenCohete),
              ],
            ),
          );
        },
      ),
    );
  }
}
