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
        title: Text("Weather forcast",style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 700,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage("data:image/jpeg;base64,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"),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor:Colors.white,
                          hintText: "City name",
                          labelText: "Enter the name of a city",
                          border: OutlineInputBorder()
                      ),
                      keyboardType: TextInputType.name,
                    ),

                    ElevatedButton(onPressed: (){apicall();
                    cityname=_textController.text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SecondRoute()),
                    );},style: ElevatedButton.styleFrom(primary: Colors.white), child: Text("SEE WEATHER",style: TextStyle(color: Colors.green,fontSize: 40.0),)),
                  ],
                )// Foreground widget here
            )

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
                  height: 700,
                  width: 600,
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
                          child: Text("${cityname.toUpperCase()}"
                              ,style: TextStyle(fontSize: 40.0,color: Colors.white)),
                        ),
                        FutureBuilder(future:apicall(),
                            builder: (BuildContext context,AsyncSnapshot snapshot){
                              if(snapshot.hasData){
                                return Text("${double.parse((weather_temp-273).toStringAsFixed(2))} Celcius\n\n",style: TextStyle(fontSize: 40.0,color: Colors.white),);
                              }
                              else{
                                return CircularProgressIndicator();
                              }
                            }),

                        FutureBuilder(future:apicall(),
                            builder: (BuildContext context,AsyncSnapshot snapshot){
                              if(snapshot.hasData){
                                return Text("Weather Description  :  ${snapshot.data}\n\nFeels like  :  ${double.parse((weather_feelslike-273).toStringAsFixed(2))}\n\nHumidity  :  ${weather_humidity}\n\nPressure  :  ${weather_pressure}\n\nVisibility  :  ${weather_visiblity}\n\nHave a Great Day!!:)",style: TextStyle(fontSize: 20.0,color: Colors.white),);
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
    weather_temp=jsonDecode(response.body)["main"]["temp"];
    weather_feelslike=jsonDecode(response.body)["main"]["feels_like"];
    weather_humidity=jsonDecode(response.body)["main"]["pressure"];
    weather_pressure=jsonDecode(response.body)["main"]["humidity"];
    weather_visiblity=jsonDecode(response.body)["visibility"];
    return jsonDecode(response.body)["weather"][0]["description"];
  }

}
