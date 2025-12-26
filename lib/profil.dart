import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Pastikan sudah ada di pubspec.yaml
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
  int _currentIndex = 4; // Index Profil

  // ================= DATA PROFIL (STATE) =================
  // Data default jika belum ada yang disimpan
  String _name = " Pasien ";
  String _email = "pasien@email.com";
  String _phone = "08123456789";
  String _address = "Jl. Kesehatan No. 1";

  @override
  void initState() {
    super.initState();
    _loadProfile(); // Load data saat halaman dibuka
  }

  // 1. FUNGSI MEMUAT DATA DARI PENYIMPANAN
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('profile_name') ?? "Dr. Pasien Contoh";
      _email = prefs.getString('profile_email') ?? "pasien@email.com";
      _phone = prefs.getString('profile_phone') ?? "08123456789";
      _address = prefs.getString('profile_address') ?? "Jl. Kesehatan No. 1";
    });
  }

  // 2. FUNGSI MENYIMPAN PERUBAHAN
  Future<void> _saveProfile(
    String name,
    String email,
    String phone,
    String address,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', name);
    await prefs.setString('profile_email', email);
    await prefs.setString('profile_phone', phone);
    await prefs.setString('profile_address', address);

    // Update tampilan setelah simpan
    setState(() {
      _name = name;
      _email = email;
      _phone = phone;
      _address = address;
    });
  }

  // 3. MENAMPILKAN FORM EDIT (POPUP)
  void _showEditDialog() {
    // Siapkan controller dengan data saat ini
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);
    final phoneController = TextEditingController(text: _phone);
    final addressController = TextEditingController(text: _address);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profil"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Lengkap",
                    icon: Icon(Icons.person),
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    icon: Icon(Icons.email),
                  ),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: "No. Handphone",
                    icon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: "Alamat",
                    icon: Icon(Icons.home),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                // Simpan data dan tutup dialog
                _saveProfile(
                  nameController.text,
                  emailController.text,
                  phoneController.text,
                  addressController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profil berhasil diperbarui!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 11, 76, 130),
              ),
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Navigasi Bottom Bar
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
        return;
      default:
        return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          "Profil Saya",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // FOTO PROFIL
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/profil.jpeg'),
                // Jika gambar gagal load, tampilkan Icon
                onBackgroundImageError: (_, __) {},
                child: null,
              ),
            ),
            const SizedBox(height: 20),

            // INFO DATA DIRI (Mengambil dari Variabel State)
            Text(
              _name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              _email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              "$_phone • $_address",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // LIST MENU PROFIL
            // Saat diklik, panggil _showEditDialog
            _buildProfileItem(
              Icons.person,
              "Edit Profil",
              onTap: _showEditDialog,
            ),

            _buildProfileItem(Icons.settings, "Pengaturan", onTap: () {}),
            _buildProfileItem(Icons.help, "Bantuan", onTap: () {}),
            _buildProfileItem(
              Icons.privacy_tip,
              "Kebijakan Privasi",
              onTap: () {},
            ),

            const SizedBox(height: 20),
            // TOMBOL LOGOUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Logika Logout (kembali ke Login)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Keluar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 11, 76, 130),
        unselectedItemColor: Colors.grey,
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

  Widget _buildProfileItem(
    IconData icon,
    String title, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 11, 76, 130)),
      title: Text(title),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap, // Menggunakan parameter onTap
    );
  }
}
