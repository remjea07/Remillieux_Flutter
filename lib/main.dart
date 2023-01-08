import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {


  // Déclarez une variable de type Future qui contiendra les données de météo
  Future<Map<String, dynamic>> weatherData = Future.value({});


  // Déclarez une fonction qui appelle l'API météo et récupère les données de météo
  Future<Map<String, dynamic>> getWeatherData() async {
    // Remplacez l'URL par l'URL de l'API météo que vous souhaitez utiliser
    String url = 'https://www.data.corsica/explore/dataset/query-outfields-and-where-1-3d1-and-fgeojson/information/';

    // Envoyez une requête HTTP GET à l'API
    http.Response response = await http.get(url);

    // Vérifiez que la réponse est correcte (code HTTP 200)
    if (response.statusCode == 200) {
      // Décodez la réponse JSON
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      // Si la réponse est incorrecte, renvoyez un message d'erreur
      return {'error': 'Failed to get weather data.'};
    }
  }

  @override
  void initState() {
    super.initState();

    // Appelez la fonction getWeatherData lorsque la page est chargée
    weatherData = getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Météo'),
    ),
    body: Center(
    child: FutureBuilder(
    // Attendez la réponse de l'API avant de construire l'interface utilisateur
    future: weatherData,
    builder: (context, snapshot) {
    // Si les données sont prêtes, affichez-les
    if (snapshot.hasData && snapshot.data['main'] != null) {
      return Text('Température : ${snapshot.data['main']['temp']}°C');
    }
    // Si il y a une erreur, affichez un message d'erreur
    else if (snapshot.hasError) {
      return Text('${snapshot.error}');
    }
    // Si les données ne sont pas encore prêtes, affichez un message de chargement
    else {
      return Text('Chargement en cours...');
    }
    },
    ),
    ),
    );
  }
}


