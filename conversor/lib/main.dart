import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
const request = "https://api.hgbrasil.com/finance?format=json&key=";
void main()async {


  runApp(MaterialApp(
      home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.amber
    ),

  ));
}

  Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
  }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChange(String value){
    print(value);

    setState(() {
      double real = double.parse(value);
      dolarController.text = (real*dolar).toStringAsFixed(2);
      euroController.text = (real*euro).toStringAsFixed(2);
    });
  }

  void _dolarChange(String value){
    print(value);
    double dolar = double.parse(value);
    realController.text = (dolar / this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar/euro).toStringAsFixed(2);
  }

  void _euroChange(String value){
    print(value);
    double euro = double.parse(value);
    realController.text = (euro / this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context,snapshot){
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Text("Carregando Dados...",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0),
                    textAlign: TextAlign.center,)
              );
            default:
              if(snapshot.hasError){
                return Center(
                    child: Text("Erro ao carregar Dados  :-(...",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0),
                      textAlign: TextAlign.center,)
                );
              }else{
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                        color: Colors.amber, size: 150.0,
                      ),
                       buildTextField("Reais","RS\$",realController,_realChange),
                      Divider(),
                      buildTextField("Dólares","US\$",dolarController,_dolarChange),
                      Divider(),
                      buildTextField("Euros","€\$",euroController,_euroChange)
                    ,
                    ],
                  ),
                );
              }
          }
          })
    );
    }


    Widget buildTextField(labelText, prefix,controller, Function f){
    return   TextField(decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,

    ),
      keyboardType: TextInputType.number,
      controller: controller,
      style: TextStyle(
          color: Colors.amber, fontSize: 25.0
      ),
      onChanged: f,
    );
  }
}


