import 'package:flutter/material.dart';

class SearchResultListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultados de búsqueda"),
        backgroundColor:
            Color.fromARGB(255, 228, 89, 24), // Utilizando el color principal
      ),
      body: _buildSearchResults(context),
    );
  }

  // Asumiendo que tienes una lista de resultados para mostrar, aquí puedes introducir un ListView
  Widget _buildSearchResults(BuildContext context) {
    // Simulación de una lista de resultados con un ListView
    // Este widget se debe reemplazar por tu contenido dinámico actual
    List<String> dummyResults =
        List.generate(10, (index) => "Resultado ${index + 1}");
    return ListView.builder(
      itemCount: dummyResults.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(dummyResults[index]),
            onTap: () {
              // Acción al seleccionar un elemento de la lista, como navegar a otra página con detalles
              _showResultDetail(context, dummyResults[index]);
            },
          ),
        );
      },
    );
  }

  void _showResultDetail(BuildContext context, String result) {
    // Aquí puedes implementar la lógica para mostrar detalles del resultado seleccionado
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Detalle del Resultado"),
          content: Text("Detalles del resultado para: $result"),
          actions: <Widget>[
            TextButton(
              child: Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
