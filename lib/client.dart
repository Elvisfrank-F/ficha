import 'package:flutter/material.dart';


class Client extends StatefulWidget {
  const Client({super.key});

  @override
  State<Client> createState() => _ClientState();
}

class _ClientState extends State<Client> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      child: Card(
        elevation: 10,
        child: SizedBox(
          width: 300,
          height: 300,
          child: Column(
            children: [
              Icon(Icons.supervised_user_circle),
              Text("Nome da Cliente"),
            ],
          )),
      ),
    );
  }
}