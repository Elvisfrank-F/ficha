import 'package:flutter/material.dart';


class Client extends StatefulWidget {

  final String name;
  final double divida;
  final String endereco;
  final VoidCallback onDelete;

  const Client({super.key, required  this.name, required this.divida, required this.endereco, required this.onDelete});

  @override
  State<Client> createState() => _ClientState(name: name, divida: divida, endereco: endereco, onDelete: onDelete);
}

class _ClientState extends State<Client> {

  String name;
  double divida;
  String endereco;
  VoidCallback onDelete;

   TextEditingController _controllerName = new TextEditingController();
   TextEditingController _controllerDivida = new TextEditingController();
   TextEditingController _controllerEndereco = new TextEditingController();

  _ClientState({required  this.name, required this.divida, required this.endereco, required this.onDelete});

  @override
  void initState() {
    // TODO: implement initState

  _controllerDivida.text = divida.toString();
  _controllerEndereco.text = endereco;
  _controllerName.text =  name;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    String srtDivida = divida.toStringAsFixed(2);
    return Card(
        elevation: 10,
        child: SizedBox(
          width: 230,
          
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ 

                  GestureDetector(
                    onTap: onDelete,
                  child:  Icon(Icons.remove_circle_outline, size: 35),
                  ),

                 
                  
                  GestureDetector(
                     onTap: () => showDialog<String>(
                      context: context,

                      builder:(context) => AlertDialog(
                        title: Text("Editar os dados de $name"),

                        content: SizedBox(
                height: 300,
                width: 300,
                child: Column(
                  children: [
                    TextField(
                      controller: _controllerName,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: Text('Nome'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      )
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _controllerDivida,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: Text('Valor da dívida'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      )
                    ),
                      SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _controllerEndereco,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        label: Text('Endereço'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      )
                    ),
                  ],
                ),
              ),
                            
                          
                       
                        
                        actions: [
                          TextButton(child: Text("Cancelar"), onPressed: () => Navigator.pop(context, "Cancelar")),
                          TextButton(child: Text("Aplicar"), onPressed: () {

                            setState(() {
                                name = _controllerName.text;
                            divida = double.tryParse(_controllerDivida.text) ?? 0;
                            endereco = _controllerEndereco.text;
                            });
                          
                             Navigator.pop(context, 'Aplicar');
                             
                             }),
                        ]
                      ),

                     ),
                    
                    child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Icon(Icons.edit)),
                  ),],
              ),
             
              SizedBox(height: 10),
              Icon(Icons.account_circle, size: 100),
              SizedBox(height: 20,),
              Text(name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
               Text(endereco, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100)),
              SizedBox(height: 10),
              Text("Dívida", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              Text("R\$$srtDivida", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))


              

            ],
          )),
      );
  }
}