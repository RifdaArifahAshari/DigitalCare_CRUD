import 'package:flutter/material.dart';
import 'package:tugas_crud/aktivitas.dart';
import 'package:tugas_crud/home.dart';
import 'package:tugas_crud/profil.dart';
import 'package:tugas_crud/konsultasi.dart';

class PembayaranPage extends StatefulWidget {
  const PembayaranPage({super.key});

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  int _currentIndex = 2; // Index halaman Pembayaran
  int _selectedPaymentIndex = -1; // -1 artinya belum ada yang dipilih

  // Data Dummy Metode Pembayaran
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'title': 'E-Wallet (SeaBank/Gopay)',
      'subtitle': 'Bebas biaya admin',
      'icon': Icons.account_balance_wallet,
      'color': Colors.orange,
    },
    {
      'title': 'QRIS',
      'subtitle': 'Scan cepat & mudah',
      'icon': Icons
          .qr_code_2, // Pastikan icon ini ada di flutter versi baru, atau pakai qr_code
      'color': Colors.black,
    },
    {
      'title': 'Kartu Kredit / Debit',
      'subtitle': 'Visa / Mastercard',
      'icon': Icons.credit_card,
      'color': Colors.blueAccent,
    },
    {
      'title': 'Transfer Bank',
      'subtitle': 'BCA / Mandiri / BRI',
      'icon': Icons.account_balance,
      'color': Colors.indigo,
    },
  ];

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
        return;
      case 3:
        page = const AktivitasPage();
        break;
      case 4:
        page = const ProfilePage();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  // Fungsi untuk memproses pembayaran
  void _processPayment() {
    if (_selectedPaymentIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan pilih metode pembayaran terlebih dahulu!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simulasi Sukses
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Pembayaran Berhasil!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text("Metode: ${_paymentMethods[_selectedPaymentIndex]['title']}"),
            const Text("Total: Rp 150.000"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              // Opsional: Pindah ke halaman aktivitas
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AktivitasPage()),
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
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
          'Metode Pembayaran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 125, 218, 234),
      ),

      body: Column(
        children: [
          // 1. INFO TAGIHAN
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Tagihan",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Rp 150.000",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 11, 76, 130),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "Konsultasi Dokter Umum",
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Pilih Metode",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),

          // 2. LIST METODE PEMBAYARAN
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _paymentMethods.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _paymentMethods[index];
                final isSelected = _selectedPaymentIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPaymentIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(item['icon'], color: item['color'], size: 30),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                              Text(
                                item['subtitle'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: Colors.blue),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 3. TOMBOL BAYAR
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 11, 76, 130),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Bayar Sekarang",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 11, 76, 130),
        unselectedItemColor: Colors.grey,
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
