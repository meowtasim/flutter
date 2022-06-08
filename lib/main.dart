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
        title: Text("Weather forecast",style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: MediaQuery.of(context).size.height-56,
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
                    );},style: ElevatedButton.styleFrom(primary: Colors.white), child: Text("SEE WEATHER",style: TextStyle(color: Colors.green,fontSize: 30.0),)),
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
        height: MediaQuery.of(context).size.height-56,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage("data:image/jpeg;base64,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"),
                fit: BoxFit.cover),

          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 600,
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
                              return Text("Weather Description  :  ${snapshot.data}\n\nFeels like  :  ${double.parse((weather_feelslike-273).toStringAsFixed(2))} Celcius\n\nHumidity  :  ${weather_humidity}g/m3\n\n Pressure  :  ${weather_pressure}Hg\n\nVisibility  :  ${weather_visiblity}m\n\nHave a Great Day!!:)",style: TextStyle(fontSize: 20.0,color: Colors.white),);
                            }
                            else{
                              return CircularProgressIndicator();
                            }
                          })

                    ]
                )
            ),
          ],
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
