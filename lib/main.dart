import 'package:flutter/material.dart';
import 'package:tugas_crud/home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Kesehatan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Home(), // Halaman awal adalah Login
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  bool _obscurePass = true; // status sembunyikan password

  void _handleLogin() {
    // 1. Validasi Input Sederhana
    if (usernameC.text.isEmpty || passwordC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username dan Password tidak boleh kosong!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 2. Navigasi Login (Gunakan pushReplacement)
    // Agar user tidak bisa kembali ke login saat tekan tombol Back
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 220, 237, 244),
              Color.fromARGB(255, 125, 218, 234),
              Color.fromARGB(255, 11, 76, 130),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // JUDUL APLIKASI
                const Text(
                  "JagaRaga",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 4, 36, 106),
                    shadows: [
                      Shadow(
                        color: Color.fromARGB(66, 255, 255, 255),
                        offset: Offset(2, 2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // LOGO
                // Pastikan file rs.png sudah didaftarkan di pubspec.yaml
                const Image(
                  image: AssetImage('assets/images/rs.png'),
                  height: 200,
                ),

                const SizedBox(height: 30),

                // KOTAK LOGIN
                Container(
                  width: 300,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // USERNAME
                      TextField(
                        controller: usernameC,
                        decoration: InputDecoration(
                          labelText: "Username",
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // PASSWORD
                      TextField(
                        controller: passwordC,
                        obscureText: _obscurePass,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePass = !_obscurePass;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // TOMBOL MASUK
                      SizedBox(
                        width: double
                            .infinity, // Agar tombol memenuhi lebar container
                        child: ElevatedButton(
                          onPressed: _handleLogin, // Panggil fungsi login
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Masuk",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
