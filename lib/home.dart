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
  int _currentIndex = 0; // Posisi saat ini di Home

  // 1. DATA MENU: Membuat daftar menu agar tidak "Obat" semua
  final List<Map<String, dynamic>> menuItems = [
    {
      'icon': Icons.local_hospital,
      'title': 'RS Terdekat',
      'desc': 'Cari RS di sekitarmu',
      'color': Colors.redAccent,
    },
    {
      'icon': Icons.medication,
      'title': 'Beli Obat',
      'desc': 'Apotek online 24 jam',
      'color': Colors.green,
    },
    {
      'icon': Icons.medical_services,
      'title': 'Lab Medis',
      'desc': 'Cek darah & lab',
      'color': Colors.orange,
    },
    {
      'icon': Icons.health_and_safety,
      'title': 'Asuransi',
      'desc': 'Proteksi kesehatan',
      'color': Colors.blue,
    },
    {
      'icon': Icons.coronavirus,
      'title': 'Covid-19',
      'desc': 'Info & Vaksinasi',
      'color': Colors.purple,
    },
    {
      'icon': Icons.more_horiz,
      'title': 'Lainnya',
      'desc': 'Layanan lainnya',
      'color': Colors.grey,
    },
  ];

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    // Navigasi Bottom Bar
    // Catatan: Menggunakan pushReplacement akan me-reset halaman.
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
      // Background Gradient
      backgroundColor: const Color.fromARGB(
        255,
        240,
        248,
        255,
      ), // Warna dasar muda
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
        elevation: 0,
      ),

      body: Container(
        // Pindahkan gradient ke Container body agar cover full screen jika mau
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 125, 218, 234),
              Color.fromARGB(255, 240, 248, 255),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Sapaan
              const Text(
                "Halo, Sehat Selalu!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 11, 76, 130),
                ),
              ),
              const SizedBox(height: 16),

              // 2. GRID MENU DINAMIS
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(menuItems.length, (index) {
                  final item = menuItems[index];

                  return SizedBox(
                    width:
                        (MediaQuery.of(context).size.width - 48) /
                        2, // Perbaikan kalkulasi lebar
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      // Tambahkan InkWell agar bisa diklik
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // Aksi jika menu diklik
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Menu ${item['title']} dipilih'),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            children: [
                              Icon(
                                item['icon'],
                                size: 36,
                                color: item['color'], // Warna icon berbeda-beda
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['desc'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // Banner Bawah
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 11, 76, 130),
                      Color.fromARGB(255, 125, 218, 234),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Yuk Jaga Kesehatanmu!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Konsultasi dokter kapan saja dimana saja.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(
          255,
          11,
          76,
          130,
        ), // Warna saat aktif
        unselectedItemColor: Colors.grey, // Warna saat tidak aktif
        showUnselectedLabels: true,
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
