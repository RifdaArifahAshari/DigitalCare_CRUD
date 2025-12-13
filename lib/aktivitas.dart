import 'package:flutter/material.dart';
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
  int _currentIndex = 3; // Aktivitas

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
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Jadwal Pemeriksaan'),
              subtitle: const Text('Tidak ada jadwal untuk hari ini'),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Buat Baru'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Rekam Medis Singkat',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.note_alt_outlined),
              title: const Text('Pemeriksaan Gula Darah'),
              subtitle: const Text('12 Mei 2025 · Normal'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.note_alt_outlined),
              title: const Text('Tekanan Darah'),
              subtitle: const Text('05 Apr 2025 · Slightly High'),
            ),
          ),
        ],
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
}
