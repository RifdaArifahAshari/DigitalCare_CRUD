import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_crud/konsultasi.dart';
import 'package:tugas_crud/home.dart';
import 'package:tugas_crud/aktivitas.dart';
import 'package:tugas_crud/pembayaran.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 4; // Profil

  // ================= BOTTOM NAV =================
  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    Widget page;

    switch (index) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const KonsultasiPage();
        break;
      case 2:
        page = const PembayaranPage();
        break;
      case 3:
        page = const AktivitasPage();
        break;
      case 4:
        return; // Profil (page ini)
      default:
        return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  // ================= CONTROLLER =================
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // ================= DATA =================
  List<Map<String, dynamic>> profileList = [];
  static const String prefsKey = "profileList";
  int? editingIndex;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(prefsKey);

    if (raw != null) {
      setState(() {
        profileList = raw
            .map((e) => jsonDecode(e))
            .cast<Map<String, dynamic>>()
            .toList();
      });
    }
  }

  Future<void> _saveProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final data = profileList.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList(prefsKey, data);
  }

  void _showProfileDetail(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Detail Profil Pasien"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nama : ${item["username"]}"),
              Text("Email : ${item["email"]}"),
              Text("No HP : ${item["phone"]}"),
              Text("Umur : ${item["age"]}"),
              Text("Alamat : ${item["address"]}"),
              const SizedBox(height: 10),
              Text(
                "Dibuat: ${item["createdAt"].toString().substring(0, 10)}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  void _addOrUpdateProfile() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final age = _ageController.text.trim();

    if (username.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username & Email wajib diisi")),
      );
      return;
    }

    final newProfile = {
      "username": username,
      "email": email,
      "phone": phone,
      "address": address,
      "age": age,
      "createdAt": DateTime.now().toIso8601String(),
    };

    setState(() {
      if (editingIndex == null) {
        profileList.add(newProfile);
      } else {
        profileList[editingIndex!] = newProfile;
        editingIndex = null;
      }
    });

    _saveProfiles();
    _clearForm();
  }

  void _clearForm() {
    _usernameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();
    _ageController.clear();
    setState(() => editingIndex = null);
  }

  void _editProfile(int index) {
    final item = profileList[index];

    setState(() {
      editingIndex = index;
      _usernameController.text = item["username"];
      _emailController.text = item["email"];
      _phoneController.text = item["phone"];
      _addressController.text = item["address"];
      _ageController.text = item["age"];
    });
  }

  void _deleteProfile(int index) {
    setState(() {
      profileList.removeAt(index);
    });
    _saveProfiles();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
        ),
        backgroundColor: const Color.fromARGB(255, 125, 218, 234),
        title: const Text(
          "Profil Pasien",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // FORM
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildField(
                    _usernameController,
                    "Nama Lengkap",
                    Icons.person,
                  ),
                  _buildField(_emailController, "Email", Icons.email),
                  _buildField(_phoneController, "Nomor Telepon", Icons.phone),
                  _buildField(_ageController, "Umur", Icons.calendar_today),
                  _buildField(_addressController, "Alamat", Icons.home),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addOrUpdateProfile,
                      child: Text(
                        editingIndex == null
                            ? "Tambah Profil"
                            : "Update Profil",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: profileList.length,
              itemBuilder: (context, index) {
                final item = profileList[index];
                return Card(
                  child: ListTile(
                    onTap: () => _showProfileDetail(item),
                    title: Text(item["username"]),
                    subtitle: Text(item["email"]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editProfile(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteProfile(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Konsultasi'),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Pembayaran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Aktivitas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      ),
    );
  }
}
