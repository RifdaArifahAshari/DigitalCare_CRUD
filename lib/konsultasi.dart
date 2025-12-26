import 'package:flutter/material.dart';
import 'package:tugas_crud/home.dart';
import 'package:url_launcher/url_launcher.dart';

class KonsultasiPage extends StatefulWidget {
  const KonsultasiPage({super.key});

  @override
  State<KonsultasiPage> createState() => _KonsultasiPageState();
}

class _KonsultasiPageState extends State<KonsultasiPage> {
  // 1. Controller untuk mengambil teks dari inputan
  final TextEditingController _pesanController = TextEditingController();

  // Fungsi buka WhatsApp
  Future<void> _launchWhatsApp() async {
    const String phoneNumber = '6282210315518'; // Nomor tujuan

    // Ambil pesan dari TextField, jika kosong pakai pesan default
    String message = _pesanController.text.trim();
    if (message.isEmpty) {
      message = 'Halo Dokter, saya ingin berkonsultasi mengenai kesehatan saya';
    }

    final Uri whatsappUrl = Uri.parse(
      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
    );

    try {
      // Mode externalApplication agar membuka aplikasi WA asli
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        // Fallback jika check gagal (tetap coba launch)
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal membuka WhatsApp: $e')));
      }
    }
  }

  @override
  void dispose() {
    _pesanController.dispose();
    super.dispose();
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
          'Konsultasi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 125, 218, 234),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat, color: Colors.white),
            onPressed: _launchWhatsApp,
            tooltip: 'Chat via WhatsApp',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.green),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Tekan tombol kirim di bawah untuk terhubung langsung ke WhatsApp Dokter.",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                // contoh tampilan chat sederhana
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Halo, ada keluhan apa hari ini?'),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 147, 219, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Saya demam sejak kemarin.'),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Riwayat konsultasi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: const Text('Dr. Siti - Konsultasi Umum'),
                    subtitle: const Text('10 Apr 2025 · Selesai'),
                    trailing: IconButton(
                      onPressed: _launchWhatsApp, // Tombol riwayat juga ke WA
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // input sederhana
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle_outline),
                ),
                Expanded(
                  child: TextField(
                    controller: _pesanController, // 2. Pasang controller
                    decoration: const InputDecoration(
                      hintText: 'Tulis pesan...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _launchWhatsApp, // 3. Panggil fungsi di sini
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
