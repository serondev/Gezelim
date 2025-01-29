import 'package:flutter/material.dart';
import 'admin_view.dart';

class AdminLoginView extends StatefulWidget {
  const AdminLoginView({super.key});

  @override
  _AdminLoginViewState createState() => _AdminLoginViewState();
}

class _AdminLoginViewState extends State<AdminLoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Admin bilgileri (gerçek uygulamada bu bilgiler daha güvenli bir şekilde saklanmalı)
  static const String _adminUsername = 'admin';
  static const String _adminPassword = 'admin';

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    print('Girilen kullanıcı adı: $username'); // Debug için
    print('Girilen şifre: $password'); // Debug için

    if (username == _adminUsername && password == _adminPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminView()),
      );
    } else {
      // Hata mesajını daha detaylı hale getirelim
      String errorMessage = 'Geçersiz admin bilgileri\n';
      if (username != _adminUsername) {
        errorMessage += 'Kullanıcı adı hatalı\n';
      }
      if (password != _adminPassword) {
        errorMessage += 'Şifre hatalı';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Girişi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Kullanıcı Adı',
                border: OutlineInputBorder(),
                hintText: 'admin',
              ),
              autocorrect: false,
              enableSuggestions: false,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
                hintText: 'admin',
              ),
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Giriş'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
