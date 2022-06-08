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
                      image: NetworkImage("https://images.unsplash.com/photo-1533460004989-cef01064af7e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Z3Jhc3N8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60"),
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
                image: NetworkImage("https://media.istockphoto.com/photos/blue-sky-background-with-white-clouds-picture-id1327185011?b=1&k=20&m=1327185011&s=170667a&w=0&h=ru7L4HLxzKW_u1KC9CJlRotdtM5zJW_X6iPhudwvLK4="),
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
                  color: Colors.lightBlueAccent,),
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
