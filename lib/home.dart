import 'package:flutter/material.dart';
import 'package:tugas_crud/profil.dart';
import 'package:tugas_crud/konsultasi.dart';
import 'package:tugas_crud/pembayaran.dart';
import 'package:tugas_crud/aktivitas.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // posisi Home

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const KonsultasiPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PembayaranPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AktivitasPage()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 220, 237, 244),
            Color.fromARGB(255, 125, 218, 234),
            Color.fromARGB(255, 11, 76, 130),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ).color,
      appBar: AppBar(
        title: const Text(
          'Jaga Raga',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 125, 218, 234),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 64) / 2,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.favorite,
                            size: 36,
                            color: Color.fromARGB(255, 11, 76, 130),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Obat Dan Perawatan ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),

                          const Text(
                            'Obat dan perawatan untuk menjaga kesehatan Anda.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 212, 238, 253),
                    Color.fromARGB(255, 125, 218, 234),
                  ],
                ),
              ),
              child: const Center(
                child: Text(
                  'Yuk Jaga Kesehatanmu Setiap Hari!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 11, 76, 130),
                  ),
                ),
              ),
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
}
