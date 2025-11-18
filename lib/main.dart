import 'package:flutter/material.dart';
import 'client.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
  
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



   TextEditingController _controllerName = new TextEditingController();
            TextEditingController _controllerDivida = new TextEditingController();
            TextEditingController _controllerEndereco = new TextEditingController();

  List<Map<String, dynamic>> listClient = [];
  List<Map<String, dynamic>> listReClient = [];

  @override
  void initState(){
    super.initState();

    _loadData();

    


  }

  //função para deletar o client

  void _deleteClient(String name){

    setState(() {
      
      listClient.removeWhere((client) => client['name'] == name);
      listReClient.removeWhere((client) => client['name'] == name);

    });

    __saveData();
  }
   
   
   //função para puxar o arquivo que contem as informações do cliente

   Future<File> _getFile() async {

    final dataBaseDir = await getApplicationDocumentsDirectory();
    final customDB = Directory("${dataBaseDir.path}/FichaDir");
     
     if(!await customDB.exists()){
      await customDB.create(recursive: true);

     }

     return File("${customDB.path}/dataFicha.json");


   
   }

   //função que insere os dados no arquivo
   Future<File> __saveData() async{
    String data = json.encode(listClient);
    final file = await _getFile();
    return file.writeAsString(data);
   }

   //função que le os dados do arquivo
   
   Future<String> _readData() async {
    try{
      final file = await _getFile();

    if(await file.exists()){
        return file.readAsString();

    }
    else {
      return "[]";
    }
    
    }

    catch(e){
      return "[]";
    }
   }

   //função que "baixa" os dados do arquivo para a list de clientes

   void _loadData() async{
    
    String data = await _readData();

   
      setState(() {
         listClient = List<Map<String, dynamic>>.from(json.decode(data));
      });
     
    }
   



   //criar cliente
  

  void CreateClient(String name, double divida, String endereco) {

    //Client cliente = new Client(divida: divida, name: name, endereco: endereco);

   // var logger = Logger();

    Map<String, dynamic> novoClient = {
     'name': name,
     'divida': divida,
     'endereco': endereco
    };


 setState(() {
   listClient.add(novoClient);
   listReClient = List.from(listClient);
 });

 _controllerDivida.clear();
 _controllerEndereco.clear();
 _controllerName.clear();
    
 __saveData();
   
  }

  void _search(String a){

    setState(() {

      if(a.isEmpty){
 listClient = List.from(listReClient);
 return;
}

if(listReClient.isEmpty){
   listReClient = List.from(listClient);
}
      
    
final resultado = listReClient.where((client){

  final name = client['name'].toString().toLowerCase();
  return name.contains(a.toLowerCase());
}).toList();

listClient = resultado;

  });


    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 149, 185),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 29, 149, 185),
        centerTitle: true,
        title: Text("Ficha", style: TextStyle(color: Colors.white, )),
        leading: Icon(Icons.menu, color: Colors.white),
        
        actions: [
        

        
          
         ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            iconColor: WidgetStateProperty.all(Colors.black),
            ),
          
          onPressed: () { 
            
           
          
            
            showDialog<String>(
            
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Adicionar cliente", textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400)),
              
              content:  SizedBox(
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
              actions: <Widget>[
                TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context, 'Cancel')),
                TextButton(child: const Text('Adicionar'), 
                onPressed: () {

               
                 
                    CreateClient( _controllerName.text, 
                  double.tryParse(_controllerDivida.text) ?? 0,
                   _controllerEndereco.text);

               
                       Navigator.pop(context, 'Ok');

                
                
  }),
              ]
            )
          ); },
          icon:  Icon(Icons.add),
          label: Text("")
         )
          
         
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
        
          builder: (context, constraints) {
        
           
          return  Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      width: constraints.maxWidth * 0.9,
            
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 142, 206, 211)
                      ),
                      child: TextField(
                        onChanged: _search,
                        
                        decoration: InputDecoration(
                          
                          prefixIcon: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Icon(Icons.search, color: Colors.white, size: 30),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.red
                            )
                          )
                        ),
                      ),
                    ),
        
                    SizedBox(height: 30,),
        
                    
        
                    SizedBox(
                      height: 320,
                      width: constraints.maxWidth * 0.9,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listClient.length,
                        itemBuilder: (context, index){
                          final client = listClient[index];
                          return Client(
                            onDelete: () => _deleteClient(client['name'] as String? ?? ''),
                            name: client['name'] as String? ?? 'Nome Desconhecido',
                            divida: client['divida'] as double? ?? 0.0,
                            endereco: client['endereco'] as String? ?? 'Endereoço desconhecido',
                            key: ValueKey(client['name']),
                          );
                        },
                                      ),
                    ),
          ])
              ),
            ),
          );
          }
        ),
      )
    );
  }
}