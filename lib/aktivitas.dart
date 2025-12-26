import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_crud/profil.dart';
import 'package:tugas_crud/konsultasi.dart';
import 'package:tugas_crud/pembayaran.dart';
import 'package:tugas_crud/home.dart';

class AktivitasPage extends StatefulWidget {
  const AktivitasPage({super.key});

  @override
  State<AktivitasPage> createState() => _AktivitasPageState();
}

class _AktivitasPageState extends State<AktivitasPage> {
  int _currentIndex = 3; // Index Aktivitas

  // ================= DATA & CONTROLLER =================
  List<Map<String, dynamic>> aktivitasList = [];
  static const String prefsKey = "aktivitasList";

  final TextEditingController _kegiatanController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _hasilController = TextEditingController();

  // Index untuk edit (-1 artinya mode tambah baru)
  int _editingIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadAktivitas();
  }

  // ================= CRUD LOGIC =================

  // 1. READ (Ambil Data)
  Future<void> _loadAktivitas() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(prefsKey);
    if (raw != null) {
      setState(() {
        aktivitasList = raw
            .map((e) => jsonDecode(e))
            .cast<Map<String, dynamic>>()
            .toList();
      });
    }
  }

  // Simpan ke SharedPreferences
  Future<void> _saveAktivitas() async {
    final prefs = await SharedPreferences.getInstance();
    final data = aktivitasList.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList(prefsKey, data);
  }

  // 2. CREATE & UPDATE (Tambah / Edit)
  void _submitData() {
    final kegiatan = _kegiatanController.text.trim();
    final tanggal = _tanggalController.text.trim();
    final hasil = _hasilController.text.trim();

    if (kegiatan.isEmpty || tanggal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama Kegiatan & Tanggal wajib diisi")),
      );
      return;
    }

    final newData = {
      "kegiatan": kegiatan,
      "tanggal": tanggal,
      "hasil": hasil.isEmpty ? "-" : hasil, // Default dash jika kosong
    };

    setState(() {
      if (_editingIndex == -1) {
        // Mode Tambah
        aktivitasList.add(newData);
      } else {
        // Mode Edit
        aktivitasList[_editingIndex] = newData;
      }
    });

    _saveAktivitas();
    Navigator.pop(context); // Tutup Dialog
    _resetForm();
  }

  // 3. DELETE (Hapus)
  void _deleteAktivitas(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Aktivitas?"),
        content: const Text("Data yang dihapus tidak bisa dikembalikan."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                aktivitasList.removeAt(index);
              });
              _saveAktivitas();
              Navigator.pop(ctx);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Helper: Reset Form
  void _resetForm() {
    _kegiatanController.clear();
    _tanggalController.clear();
    _hasilController.clear();
    _editingIndex = -1;
  }

  // Helper: Buka Dialog Form
  void _showFormDialog({int? index}) {
    if (index != null) {
      // Jika Edit, isi form dengan data lama
      _editingIndex = index;
      _kegiatanController.text = aktivitasList[index]['kegiatan'];
      _tanggalController.text = aktivitasList[index]['tanggal'];
      _hasilController.text = aktivitasList[index]['hasil'];
    } else {
      // Jika Tambah Baru
      _resetForm();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            _editingIndex == -1 ? "Tambah Aktivitas" : "Edit Aktivitas",
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _kegiatanController,
                  decoration: const InputDecoration(
                    labelText: "Nama Kegiatan",
                    hintText: "Contoh: Cek Gula Darah",
                    icon: Icon(Icons.local_hospital),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _tanggalController,
                  decoration: const InputDecoration(
                    labelText: "Tanggal",
                    hintText: "Contoh: 12 Mei 2025",
                    icon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _hasilController,
                  decoration: const InputDecoration(
                    labelText: "Hasil / Keterangan",
                    hintText: "Contoh: Normal / 120 mmHg",
                    icon: Icon(Icons.note),
                  ),
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
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 125, 218, 234),
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

  // ================= NAVIGASI =================
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
        return;
      case 4:
        page = const ProfilePage();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text(
          'Aktivitas Pemeriksaan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 125, 218, 234),
      ),

      // TOMBOL TAMBAH (FLOATING ACTION BUTTON)
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        backgroundColor: const Color.fromARGB(255, 11, 76, 130),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: aktivitasList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history, size: 80, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    "Belum ada riwayat aktivitas.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () => _showFormDialog(),
                    child: const Text("Tambah Sekarang"),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: aktivitasList.length,
              itemBuilder: (context, index) {
                final item = aktivitasList[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      child: const Icon(
                        Icons.medical_services,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      item['kegiatan'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${item['tanggal']}"),
                        Text(
                          "Hasil: ${item['hasil']}",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            backgroundColor: Colors.yellow.shade100,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _showFormDialog(index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteAktivitas(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
}
