import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_info.dart';

class WeatherService {
  final String apiKey = 'e96202e3a285606a54e187159079e184';

  Future<WeatherInfo> fetchWeather(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=tr'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherInfo(
        description: data['weather'][0]['description'],
        temperature: data['main']['temp'],
      );
    } else {
      throw Exception('Hava durumu bilgisi alınamadı');
    }
  }
}
