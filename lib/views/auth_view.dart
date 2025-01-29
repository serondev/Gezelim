import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'register_view.dart';
import 'welcome_view.dart';
import 'package:provider/provider.dart';
import '../viewmodels/travel_viewmodel.dart';
import 'home_view.dart';
import 'profile_view.dart';
import 'admin_view.dart';
import 'admin_login_view.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();

  int _logoClickCount = 0;
  DateTime? _lastClickTime;

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final users = await DatabaseService().getUsers();
    final user = users.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      if (mounted) {
        // Kullanıcı bilgilerini güncelle
        final viewModel = Provider.of<TravelViewModel>(context, listen: false);

        // Önce tüm tercihleri sıfırla
        viewModel.resetPreferences();

        // Sonra kullanıcı bilgilerini güncelle
        viewModel.updateUserProfile(
          user['name'],
          user['surname'],
          user['phoneNumber'],
          user['birthDate'],
          user['email'],
        );

        // WelcomeView'a yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeView(
              onGetStarted: () {
                viewModel.completeWelcomeScreen();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeView()),
                );
              },
              userName: user['name'],
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giriş başarısız')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFFF8E1), // Açık bej
                const Color(0xFFFFE0B2), // Turuncu-bej
              ],
            ),
          ),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 48),
                  GestureDetector(
                    onTap: () {
                      final now = DateTime.now();
                      if (_lastClickTime != null &&
                          now.difference(_lastClickTime!) >
                              const Duration(seconds: 2)) {
                        _logoClickCount = 0;
                      }
                      _lastClickTime = now;

                      setState(() {
                        _logoClickCount++;
                        if (_logoClickCount >= 5) {
                          _logoClickCount = 0;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminLoginView(),
                            ),
                          );
                        }
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/logo_gezelim.png',
                          height: 150,
                          width: 150,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Gezelim',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF795548), // Kahverengi tonu
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'E-posta',
                      labelStyle: const TextStyle(color: Color(0xFF795548)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF795548)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF795548), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      labelStyle: const TextStyle(color: Color(0xFF795548)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF795548)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF795548), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF795548),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Giriş Yap',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterView(
                            onRegisterSuccess: (email) {
                              _emailController.text = email;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Kayıt başarılı! Şimdi giriş yapabilirsiniz.'),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF795548),
                    ),
                    child: const Text(
                      'Hesabınız yok mu? Kayıt olun',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
