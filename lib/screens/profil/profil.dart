import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pay_sphere_app/services/notification_service.dart';
import 'package:pay_sphere_app/services/storage.dart';
import '../../models/client_model.dart';
import '../../providers/auth_providers.dart';
import '../autres/custom_app_bar.dart';
import '../autres/navigation_wrapper.dart';

class ProfilPage extends StatefulWidget {
  final Client? client;

  const ProfilPage({super.key, required this.client});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  File? _imageFile;
  bool _isLoadingImage = true;
  final ImagePicker _picker = ImagePicker();
  final List<String> _avatars = [
    'lib/assets/avatar/00.jpg',
    'lib/assets/avatar/01.jpg',
    'lib/assets/avatar/02.jpg',
    'lib/assets/avatar/10.jpg',
  ];
  String? _selectedAvatarPath;

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    setState(() {
      _isLoadingImage = true;
    });
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/avatar.jpg';
    final file = File(path);
    if (await file.exists()) {
      _imageFile = file;
    }
    setState(() {
      _isLoadingImage = false;
    });
  }

  Future<void> _pickFromGallery() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedFile = await _cropImage(File(pickedFile.path));
      if (croppedFile != null && await croppedFile.exists()) {
        final savedFile = await _saveImageLocally(croppedFile);
        _imageFile = savedFile;
        _selectedAvatarPath = null;
        await _loadSavedImage();
      }
    }
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<File?> _cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recadrer',
          toolbarColor: Colors.blue.shade700,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: 'Recadrer',
          aspectRatioLockEnabled: true,
        )
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  Future<File> _saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/avatar.jpg';
    final savedImage = await imageFile.copy(path);
    return savedImage;
  }

  Future<void> _selectAndCropAvatar(String assetPath) async {
    final byteData = await DefaultAssetBundle.of(context).load(assetPath);
    final tempDir = Directory.systemTemp;
    final tempFile = await File('${tempDir.path}/avatar_crop.jpg').writeAsBytes(byteData.buffer.asUint8List());

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final croppedFile = await _cropImage(tempFile);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    if (croppedFile != null && await croppedFile.exists()) {
      final savedFile = await _saveImageLocally(croppedFile);
      _imageFile = savedFile;
      _selectedAvatarPath = null;
      await _loadSavedImage();
    }
  }

  void _openAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choisir un avatar"),
        content: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _avatars.map((path) {
            return GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();
                await _selectAndCropAvatar(path);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedAvatarPath == path ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  backgroundImage: AssetImage(path),
                  radius: 30,
                ),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Annuler"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationWrapper(
      currentIndex: 3,
      client: widget.client,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: CustomAppBar(
            title: "Profil",
            showNotifications: true,
            client: widget.client,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (_selectedAvatarPath != null
                            ? AssetImage(_selectedAvatarPath!)
                            : const AssetImage("lib/assets/avatar/00.jpg")) as ImageProvider,
                      ),
                      if (_isLoadingImage)
                        const SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (_) => Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text("Choisir depuis la galerie"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _pickFromGallery();
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.face),
                                      title: const Text("Choisir un avatar"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _openAvatarSelectionDialog();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.edit, size: 20, color: Colors.blue),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "${widget.client?.prenom ?? ''} ${widget.client?.nom ?? ''}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.client?.email ?? "",
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 30),
                _sectionTitle("Paramètres du profil"),
                const SizedBox(height: 12),
                _buildSettingCard([
                  _settingTile(Icons.phone, "Changer le téléphone", "Modifier votre numéro", () {context.push("/modifier-tel", extra: {"client": widget.client});}),
                  _settingTile(Icons.email, "Changer l'email", "Modifier votre adresse email", () {context.push("/modifier-email", extra: {"client": widget.client});}),
                ]),
                const SizedBox(height: 30),
                _sectionTitle("Paramètres de sécurité"),
                const SizedBox(height: 12),
                _buildSettingCard([
                  _settingTile(Icons.lock, "Changer le mot de passe", "Mettez à jour votre mot de passe", () {context.push("/modifier-mdp",extra: {"client": widget.client});}),
                ]),
                const SizedBox(height: 40),
                TextButton.icon(
                  onPressed: () async {
                      bool isNotLogged = await AuthProvider().logout();
                      if (isNotLogged && context.mounted) {
                        NotificationService.clear();
                        context.go('/demarrage');
                        StorageService.deleteClient();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Vous avez été déconnecté avec succès.")),
                        );
                    }

                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text("Se déconnecter", style: TextStyle(color: Colors.red)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildSettingCard(List<Widget> tiles) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: tiles,
      ),
    );
  }

  Widget _settingTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade50,
        child: Icon(icon, color: Colors.blue.shade700),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
