import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../viewmodels/travel_viewmodel.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  final Function(String email) onRegisterSuccess;

  const RegisterView({super.key, required this.onRegisterSuccess});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Hesap Oluştur',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF795548),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Ad',
                      icon: Icons.person,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Lütfen adınızı girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _surnameController,
                      label: 'Soyad',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Lütfen soyadınızı girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: 'E-posta',
                      icon: Icons.email,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Lütfen e-posta adresinizi girin';
                        }
                        if (!value!.contains('@')) {
                          return 'Geçerli bir e-posta adresi girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Şifre',
                      icon: Icons.lock,
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Lütfen şifrenizi girin';
                        }
                        if (value!.length < 6) {
                          return 'Şifre en az 6 karakter olmalıdır';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Telefon',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _selectDate,
                      child: AbsorbPointer(
                        child: _buildTextField(
                          controller: _birthDateController,
                          label: 'Doğum Tarihi',
                          icon: Icons.calendar_today,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _register,
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
                        'Kayıt Ol',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF795548),
                      ),
                      child: const Text(
                        'Zaten hesabınız var mı? Giriş yapın',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF795548)),
        prefixIcon: Icon(icon, color: const Color(0xFF795548)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF795548)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF795548), width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final userData = {
          'email': _emailController.text,
          'password': _passwordController.text,
          'name': _nameController.text,
          'surname': _surnameController.text,
          'phoneNumber': _phoneController.text,
          'birthDate': _birthDateController.text,
        };

        await DatabaseService().insertUser(userData);
        widget.onRegisterSuccess(_emailController.text);

        // Kullanıcı bilgilerini güncelle
        Provider.of<TravelViewModel>(context, listen: false).updateUserProfile(
          _nameController.text,
          _surnameController.text,
          _phoneController.text,
          _birthDateController.text,
          _emailController.text,
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kayıt işlemi başarısız oldu: $e')),
        );
      }
    }
  }
}
