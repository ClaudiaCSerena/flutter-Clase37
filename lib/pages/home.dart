import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Me creo mi lista de bandas:
  List<Band> bands = [
    //Se leerán desde el backend
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 6),
    Band(id: '3', name: 'Héroes del Silencio', votes: 3),
    Band(id: '4', name: 'Bon Jovi', votes: 6)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible( //para poder eliminar de la lista moviendo hacia el lado
      key: Key(band.id),
      direction: DismissDirection.startToEnd, //no funciona
      onDismissed: (direction) {
        //TODO: llamar el borrado en el server
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete band', style: TextStyle(color: Colors.white),),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: const TextStyle(fontSize: 15),
        ),
        onTap: () {},
      ),
    );
  }

  //Método para crear una nueva banda
  addNewBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () {
                    return addBandToList(textController.text);
                  },
                  child: const Text('Add'))
            ],
          );
        },
      );
    }

    //En caso que no sea android:
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text('New band name'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Add'),
              onPressed: () => addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text(
                  'Dismiss'), //necesito este botón para que se cierre, ya que si me paro afuera no lo hace
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  //Para agregar una banda a la lista
  void addBandToList(String name) {
    if (name.length > 1) {
      //Podemos agregar
      bands.add( Band(id: '15', name: name, votes: 0)); //Fernando ocupa "this.bands.add"
      setState(() {});
    }
    Navigator.pop(context);
  }
}
