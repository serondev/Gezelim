import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/travel_viewmodel.dart';

class WelcomeView extends StatelessWidget {
  final VoidCallback onGetStarted;
  final String userName;

  const WelcomeView({
    super.key,
    required this.onGetStarted,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TravelViewModel>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          // Arka plan resmi
          Image.network(
            'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          // Karartma katmanı
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          // İçerik
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.travel_explore,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Hayalinizdeki\nTatili Keşfedin',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Merhaba $userName',
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Size özel seyahat önerileri ile\nunutulmaz deneyimler yaşayın',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        viewModel.setUserName(userName);
                        onGetStarted();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Başlayalım',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
