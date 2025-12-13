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
  int _currentIndex = 2; // Pembayaran

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
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('E-Wallet'),
              subtitle: const Text('SeaBank'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text('QRIS'),
              subtitle: const Text('Qris'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Kartu Kredit / Debit'),
              subtitle: const Text('Credit/Debit Card'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Bank Transfer / Virtual'),
              subtitle: const Text('BCA / ATM Bersama'),
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
