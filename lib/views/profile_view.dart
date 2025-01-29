import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../services/database_service.dart';
import 'package:provider/provider.dart';
import '../viewmodels/travel_viewmodel.dart';

class ProfileView extends StatefulWidget {
  final String userEmail;
  final String userName;
  final String userSurname;
  final String? userPhoneNumber;
  final String? userBirthDate;

  const ProfileView({
    super.key,
    required this.userEmail,
    required this.userName,
    required this.userSurname,
    this.userPhoneNumber,
    this.userBirthDate,
  });

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final users = await DatabaseService().getUsers();
    final user = users.firstWhere(
      (user) => user['email'] == widget.userEmail,
      orElse: () => {},
    );

    if (user.isNotEmpty && user['imagePath'] != null) {
      setState(() {
        _imagePath = user['imagePath'];
      });
    }
  }

  Future<void> _showImageSourceActionSheet() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeriden Seç'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Fotoğraf Çek'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              if (_imagePath != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Fotoğrafı Kaldır',
                      style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    // Veritabanından resmi kaldır
                    await DatabaseService()
                        .updateUserImage(widget.userEmail, '');

                    // Eğer eski resim dosyası varsa sil
                    if (_imagePath != null) {
                      try {
                        final file = File(_imagePath!);
                        if (await file.exists()) {
                          await file.delete();
                        }
                      } catch (e) {
                        debugPrint('Dosya silinirken hata: $e');
                      }
                    }

                    // State ve ViewModel'i güncelle
                    setState(() {
                      _imagePath = null;
                    });

                    Provider.of<TravelViewModel>(context, listen: false)
                        .updateProfileImage('');

                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1000,
      );
      if (image != null) {
        // Eski resmi sil
        if (_imagePath != null) {
          try {
            final file = File(_imagePath!);
            if (await file.exists()) {
              await file.delete();
            }
          } catch (e) {
            debugPrint('Eski dosya silinirken hata: $e');
          }
        }

        // Yeni resmi kaydet
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName =
            '${widget.userEmail}_profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String permanentPath = '${appDir.path}/$fileName';

        await File(image.path).copy(permanentPath);
        await DatabaseService()
            .updateUserImage(widget.userEmail, permanentPath);

        setState(() {
          _imagePath = permanentPath;
        });

        Provider.of<TravelViewModel>(context, listen: false)
            .updateProfileImage(permanentPath);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fotoğraf işlemi başarısız: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: _showImageSourceActionSheet,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _imagePath != null
                          ? FileImage(File(_imagePath!))
                          : null,
                      child: _imagePath == null
                          ? const Icon(Icons.person,
                              size: 60, color: Colors.grey)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 20),
                        onPressed: _showImageSourceActionSheet,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.grey),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ad',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            Text(
                              widget.userName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, color: Colors.grey),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Soyad',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            Text(
                              widget.userSurname,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.grey),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Telefon',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            Text(
                              widget.userPhoneNumber ?? 'Belirtilmemiş',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.grey),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Doğum Tarihi',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            Text(
                              widget.userBirthDate ?? 'Belirtilmemiş',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
