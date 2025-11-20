import 'package:flutter/material.dart';
import 'package:ficha/main.dart';

class SettingsPage extends StatefulWidget {

  final Function(String filter, bool value) onFiltros;

  const SettingsPage({super.key, required this.onFiltros});

  @override
  State<SettingsPage> createState() => _SettingsPageState(onFiltros: onFiltros);
}

class _SettingsPageState extends State<SettingsPage> {

  final Function(String filter, bool value) onFiltros;

  _SettingsPageState({required this.onFiltros});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }


        ),
      ),
      body: ListView(

        children: [
          Container(
            decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(0),
              border: Border.all(
                color: listPreferences['isDark']? Colors.white : Colors.black,
                width: 1
              )
         ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text("Modo dark",
                style: TextStyle(fontSize: 20)),
                Switch(value: listPreferences['isDark'], onChanged: (value) {

                  setState(() {
                    listPreferences['isDark'] = value;
                    themeNotifier.value = value? ThemeMode.dark : ThemeMode.light;
                  });
                 onFiltros("isDark", listPreferences['isDark']);

                })
              ],
            ),
          ),

          //Configurações dos filtros

          SizedBox(height: 50,),

          Text("FILTRO SETTINGS",style: TextStyle(fontSize: 30),),

          //filtro do maior para a menor dívida

          Container(

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                border: Border.all(
                    color: listPreferences['isDark']? Colors.white : Colors.black,
                    width: 1
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text("Filtrar por maior divida",
                    style: TextStyle(fontSize: 20)),
                Switch(value: listPreferences['isBiggerFilter'], onChanged: (value) {
                  setState(() {
                    listPreferences['isBiggerFilter'] = value;
                    listPreferences['isSmallerFilter'] = false;
                  });

                  onFiltros("maior", listPreferences['isBiggerFilter']);

                },)
              ],
            ),
          ),

          Container(

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                border: Border.all(
                    color: listPreferences['isDark']? Colors.white : Colors.black,
                    width: 1
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text("Filtrar por menor divida",
                    style: TextStyle(fontSize: 20)),
                Switch(value: listPreferences['isSmallerFilter'], onChanged: (value) {
                  setState(() {
                    listPreferences['isSmallerFilter'] = value;
                    listPreferences['isBiggerFilter'] = false;
                  });

                  onFiltros("menor", listPreferences['isSmallerFilter']);

                })
              ],
            ),
          )
        ],

      )
    );
  }
}
