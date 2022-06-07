import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}
class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}
String cityname='';
double weather_temp=0;
double weather_feelslike=0;
double weather_pressure=0;
double weather_humidity=0;
double weather_visiblity=0;

class _HomepageState extends State<Homepage> {
  final _textController=TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreenAccent,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Weather forcast",style: TextStyle(color: Colors.lightGreenAccent),),
      ),
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "City name",
                labelText: "Enter the name of a city",
                border: OutlineInputBorder()
              ),
              keyboardType: TextInputType.name,
          ),
          
            TextButton(onPressed: (){apicall();
            cityname=_textController.text;
            Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) => const SecondRoute()),
      );}, child: Text("SEE WEATHER",style: TextStyle(color: Colors.green),)),
          ],
        
        ),
        
      ),
    );
  }
  Future<String> apicall() async{
    final url = Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=bangalore&appid=a5af7a11fc0568045d87aa0492811df7");
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

}
class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
    appBar: AppBar(
        title: Text("Weather Report",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  height: 500,
                  width: 500,
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                    color: Colors.blue,),
                  child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Text("${cityname}"
                              ,style: TextStyle(fontSize: 40.0,color: Colors.white)),                           
                        ),
                        
                        FutureBuilder(future:apicall(),
              builder: (BuildContext context,AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  return Text("Weather Description  :  ${snapshot.data}\n\nTemperature  :  ${double.parse((weather_temp-273).toStringAsFixed(2))}\n\nFeels like  :  ${double.parse((weather_feelslike-273).toStringAsFixed(2))}\n\nHumidity  :  ${weather_humidity}\n\nPressure  :  ${weather_pressure}\n\nVisibility  :  ${weather_visiblity}\n\nHave a Great Day!!:)",style: TextStyle(fontSize: 20.0,color: Colors.white),);
                }
                else{
                  return CircularProgressIndicator();
                }
              })
              
                      ]
                  )
              ),
              



        ]
        ),
      ),
    );
  }
  Future<String> apicall() async{
    final url = Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=${cityname}&appid=a5af7a11fc0568045d87aa0492811df7");
    final response = await http.get(url);
    final response_temp=await http.get(url);
    weather_temp=jsonDecode(response.body)["main"]["temp"];
    weather_feelslike=jsonDecode(response.body)["main"]["feels_like"];
    weather_humidity=jsonDecode(response.body)["main"]["pressure"];
    weather_pressure=jsonDecode(response.body)["main"]["humidity"];
    weather_visiblity=jsonDecode(response.body)["visibility"];
    return jsonDecode(response.body)["weather"][0]["description"];
  }

}