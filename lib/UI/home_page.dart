import 'package:ficha/UI/sobre_page.dart';
import 'package:ficha/main.dart';
import 'package:flutter/material.dart';
import '../wids/client.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:ficha/UI/settings_page.dart';
import 'package:ficha/wids/subclient.dart';

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
  List<Map<String, dynamic>> listSubclient = [];


  String filtroStr="";


  @override
  void initState(){
    super.initState();

    _loadData();

      _loadPreferences().then((a){

        setState(() {
          themeNotifier.value = listPreferences['isDark'] ? ThemeMode.dark : ThemeMode.light;


          if(listPreferences['isBiggerFilter']){
            listSubclient.sort((a,b){
              filtroStr = "\"MAIOR PARA O MENOR\"";
              if(a['divida'] > b['divida']) return -1;
              else if(a['divida'] < b['divida']) return 1;
              else return 0;
            });
          }
          else if(listPreferences['isSmallerFilter']){
            listSubclient.sort((a,b){
              filtroStr = "\"MENOR PARA O maior\"";
              if(a['divida'] > b['divida']) return 1;
              else if(a['divida'] < b['divida']) return -1;
              else return 0;
            });
          }
          else {
            listSubclient = List.from(listClient);
          }
        });


      });











  }

  //função para deletar o client

  void _deleteClient(String name){

    setState(() {

      listClient.removeWhere((client) => client['name'] == name);
      listReClient.removeWhere((client) => client['name'] == name);
      listSubclient.removeWhere((client) => client['name'] ==name);

    });

    _saveData();
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

  //salvando as configurações de preferencias

  Future<File> _getPreferences() async {

    final dataBaseDir = await getApplicationDocumentsDirectory();
    final customDB = Directory("${dataBaseDir.path}/FichaDir");

    if(!await customDB.exists()){
      await customDB.create(recursive: true);

    }

    return File("${customDB.path}/preferences.json");



  }
  //função que insere os dados no arquivo
  Future<File> _saveData() async{
    String data = json.encode(listClient);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  //função que salva as preferencias

  Future<File> _savePreferences() async{
    String preferences = json.encode(listPreferences);
    final file = await _getPreferences();
    return file.writeAsString(preferences);
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

  //função que lÊ as preferencias

  Future<String> _readPreferences() async {
    try{
      final file = await _getPreferences();

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

  Future<void> _loadData() async{

    String data = await _readData();


    setState(() {
      listClient = List<Map<String, dynamic>>.from(json.decode(data));
      listSubclient = List.from(listClient);
    });

  }

  //função que "baixa" as preferencias

  Future<void> _loadPreferences() async {

    String preferences = await _readPreferences();

    setState(() {
      listPreferences = Map<String, dynamic>.from(json.decode(preferences));
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
      listSubclient.add(novoClient);
    });

    _controllerDivida.clear();
    _controllerEndereco.clear();
    _controllerName.clear();

    _saveData();

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

        drawer: Drawer(

          child: ListView(

            padding: EdgeInsets.zero,
            children: [

              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child:  Text("")),

              ListTile(
                leading: Icon(Icons.home),
                title: Text('Início'),
                onTap: () {
                  Navigator.pop(context);
                                },
              ),

              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configurações'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage(onFiltros: (filter, cond) {
                        setState(() {

                          if(filter == "isDark"){

                          }

                         else if(filter == "maior" && cond){
                            listSubclient.sort((a,b){
                              filtroStr = "\"MAIOR PARA O MENOR\"";
                              if(a['divida'] > b['divida']) return -1;
                              else if(a['divida'] < b['divida']) return 1;
                              else return 0;
                            });
                          }
                          else if(filter == "menor" && cond){
                            listSubclient.sort((a,b){
                              filtroStr = "\"MENOR PARA O maior\"";
                              if(a['divida'] > b['divida']) return 1;
                              else if(a['divida'] < b['divida']) return -1;
                              else return 0;
                            });
                          }
                          else {
                            listSubclient = List.from(listClient);
                          }
                        });
                        _savePreferences();

                      },))
                  );//
                },
              ),

              ListTile(
                leading: Icon(Icons.info),
                title: Text('Sobre'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SobrePage()));
                },
              ),


            ],
          ),
        ),

        backgroundColor: listPreferences['isDark']? const Color.fromARGB(255, 3, 12, 76) :const Color.fromARGB(255, 29, 149, 185),
        appBar: AppBar(
          backgroundColor: listPreferences['isDark']? const Color.fromARGB(255, 3, 12, 76):const Color.fromARGB(255, 29, 149, 185),
          centerTitle: true,
          title: Text("Ficha", style: TextStyle(color: Colors.white, )),
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu, color: Colors.white,),
            onPressed:(){
              Scaffold.of(context).openDrawer();
            },); }
          ),

          actions: [

            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.add),
              ),
              onTap: () {
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
                              SizedBox(height: 30,),
                              GestureDetector(
                                child: Expanded(child: Column(children: [
                                
                                  Icon(Icons.account_circle_rounded, size: 80),
                                  Text("Clique para adicionar uma foto")
                                ],)),
                              )
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
            ),


          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
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
                                      color:listPreferences['isDark']? const Color.fromARGB(
                                          255, 52, 74, 76):const Color.fromARGB(255, 142, 206, 211)
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
                                  //list buuilder para os filtros
                                ),


                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("FILTRO $filtroStr APLICADO",
                                      style: TextStyle(fontSize: 20)),
                                ),

                                //listar os subclients

                                SizedBox(
                                  height: 500,

                                  child: ListView.builder( scrollDirection: Axis.vertical,
                                     itemCount: listSubclient.length,
                                      itemBuilder: (context, index)
                                  {
                                   final client = listSubclient[index];

                                   return Padding(
                                     padding: const EdgeInsets.only(top:1.0),
                                     child: SizedBox(
                                         height: 100,
                                         width: constraints.maxWidth*0.9,

                                       child: Subclient(name: client['name'],
                                           divida: client['divida'],
                                           endereco: client['endereco'],
                                           key:ValueKey(client['name'])),
                                     ),
                                   );



                                  })
                                ),


            
            
            
                              ])
                      ),
                    ),
                  );
                }
            ),
          ),
        )
    );
  }
}