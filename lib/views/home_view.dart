import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/travel_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../views/survey_view.dart';
import '../views/welcome_view.dart';
import '../models/travel_destination.dart';
import '../views/profile_view.dart';
import '../models/weather_info.dart';
import '../services/weather_service.dart';
import '../views/destination_detail_view.dart';
import '../views/login_view.dart';
import '../views/register_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TravelViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.welcomeScreenCompleted) {
          return WelcomeView(
            onGetStarted: () => viewModel.completeWelcomeScreen(),
            userName: viewModel.userName,
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Gezelim'),
            actions: [
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileView(
                        userEmail: viewModel.userEmail,
                        userName: viewModel.userName,
                        userSurname: viewModel.userSurname,
                        userPhoneNumber: viewModel.userPhoneNumber,
                        userBirthDate: viewModel.userBirthDate,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
          body: !viewModel.surveyCompleted
              ? const SurveyView()
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 200,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        title: const Text('Gezelim'),
                        background: Image.network(
                          'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Merhaba ${viewModel.userName}!',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Sizin İçin Öneriler',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tercihlerinize göre seçilmiş en iyi seyahat rotaları:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (viewModel.recommendations.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Henüz öneri bulunmuyor',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final destination =
                                  viewModel.recommendations[index];
                              return _buildDestinationCard(
                                  context, destination);
                            },
                            childCount: viewModel.recommendations.length,
                          ),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildDestinationCard(
      BuildContext context, TravelDestination destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DestinationDetailView(destination: destination),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: destination.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      destination.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          destination.rating.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
