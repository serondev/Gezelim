import 'package:flutter/material.dart';
import '../models/travel_destination.dart';
import '../models/weather_info.dart';
import '../services/weather_service.dart';

class DestinationDetailView extends StatelessWidget {
  final TravelDestination destination;

  const DestinationDetailView({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(destination.name),
              background: Image.network(
                destination.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        destination.rating.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Hakkında',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    destination.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Aktiviteler',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: destination.activities.map((activity) {
                      return Chip(
                        label: Text(activity),
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Hava Durumu',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<WeatherInfo>(
                    future: WeatherService().fetchWeather(destination.name),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Text('Hava durumu bilgisi alınamadı');
                      } else {
                        final weather = snapshot.data!;
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.wb_sunny),
                                    const SizedBox(width: 8),
                                    Text(
                                      weather.description,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.thermostat),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${weather.temperature}°C',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
