import 'dart:convert';
import 'dart:ui';
import 'package:weatherapp/secrets.dart';
import 'HourlyForecasetItem.dart';
import 'AdditionaInfo.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';
      final result = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherAPIKey'),
      );
      final data = jsonDecode(result.body);
      if (data['cod'] != '200') {
        throw "An Unexpected Error Occured";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            final data = snapshot.data;
            final commonapart = data?["list"][0];
            final currentTemp = commonapart['main']['temp'];
            final currentSky = commonapart['weather'][0]['main'];
            final Humidity = commonapart['main']['humidity'];
            final Pressure = commonapart['main']['pressure'];
            final Wind = commonapart['wind']['speed'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //main card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "$currentTemp K",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Icon(
                                  currentSky == "Clouds" || currentSky == "Rain"
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 64,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  currentSky,
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Weather Forecast",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // const SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       HourlyForecastItem(
                  //         icon: Icons.wind_power,
                  //         time: "09:00",
                  //         temp: "94",
                  //       ),

                  //       HourlyForecastItem(
                  //           icon: Icons.radar, time: "09:00", temp: "94"),
                  //       HourlyForecastItem(
                  //           icon: Icons.wind_power,
                  //           time: "09:00",
                  //           temp: "94"),
                  //       HourlyForecastItem(
                  //           icon: Icons.air, time: "09:00", temp: "94"),
                  //       HourlyForecastItem(
                  //           icon: Icons.sunny, time: "09:00", temp: "94"),
                  //       HourlyForecastItem(
                  //           icon: Icons.wind_power,
                  //           time: "09:00",
                  //           temp: "94"),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data!['list'][index + 1];
                        final hourlySky =
                            data['list'][index + 1]['weather'][0]['main'];
                        final time = DateTime.parse(hourlyForecast['dt_txt']);
                        return HourlyForecastItem(
                            icon: hourlySky == "Clouds" || hourlySky == "Rain"
                                ? Icons.cloud
                                : Icons.sunny,
                            time: DateFormat.Hm().format(time),
                            temp: hourlyForecast['main']['temp'].toString());
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Additional Information",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfo(
                        icon: Icons.water_drop,
                        label: "Humidity",
                        temperature: Humidity.toString(),
                      ),
                      AdditionalInfo(
                        icon: Icons.air,
                        label: "Wind",
                        temperature: Wind.toString(),
                      ),
                      AdditionalInfo(
                        icon: Icons.beach_access,
                        label: "Pressure",
                        temperature: Pressure.toString(),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
