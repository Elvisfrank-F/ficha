import 'package:flutter/material.dart';
import 'client.dart';
import 'package:logger/logger.dart';

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
   
   
  

  void CreateClient(String name, double divida, String endereco) {

    Client cliente = new Client(divida: divida, name: name, endereco: endereco);

    var logger = Logger();


 setState(() {
   listClient.add({
    'name': name,
    'divida' : divida,
    'endereco' : endereco,
   }
   );
   listReClient = List.from(listClient);
 });

 _controllerDivida.clear();
 _controllerEndereco.clear();
 _controllerName.clear();
    

   
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
      body: LayoutBuilder(

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
                          name: client['name'],
                          divida: client['divida'],
                          endereco: client['endereco'],
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
      )
    );
  }
}