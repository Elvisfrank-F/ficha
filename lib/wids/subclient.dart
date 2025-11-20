import 'package:flutter/material.dart';
import 'package:ficha/wids/client.dart';
import 'package:ficha/main.dart';

class Subclient extends StatefulWidget {


  final String name;
  final double divida;
  final String endereco;

  const Subclient({super.key, required  this.name, required this.divida, required this.endereco});

  @override
  State<Subclient> createState() => _SubclientState(name: name, divida: divida, endereco: endereco);

}

class _SubclientState extends State<Subclient> {
  final String name;
  final double divida;
  final String endereco;

  _SubclientState({required  this.name, required this.divida, required this.endereco});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Card(
          elevation: 10,
          child: Expanded(

            child: Row(
              children: [
                Icon(Icons.account_circle_rounded, size: 60),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$name",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("$endereco"),

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("R\$$divida",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
