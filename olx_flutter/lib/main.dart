import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'route/routes.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Jual Mobil',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black38,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue[700],
        ),
      ),
      initialRoute: AppRoutes.login,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  List<dynamic> _carList = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCarData();
  }

  Future<void> _fetchCarData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _errorMessage = 'Gagal terhubung koneksi';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.djncloud.my.id/api/v1/mobil'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() {
            _carList = data;
            _isLoading = false;
          });
        } else {
          throw Exception('Format data tidak valid');
        }
      } else {
        setState(() {
          _errorMessage = 'Gagal mengambil data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Terjadi kesalahan jaringan. Silakan periksa koneksi Anda dan coba lagi.';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCar(int id) async {
    final response = await http.delete(
      Uri.parse('https://api.djncloud.my.id/api/v1/mobil/$id'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _carList.removeWhere((car) => car['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mobil berhasil dihapus!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus mobil!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  String _formatCurrency(dynamic price) {
    if (price == null || price == '') {
      return 'Tidak diketahui';
    }

    // Pastikan harga adalah angka
    final parsedPrice = double.tryParse(price.toString());
    if (parsedPrice == null) {
      return 'Harga tidak valid';
    }

    final formatter = NumberFormat.currency(
      locale: 'id_ID', // Format Indonesia
      symbol: 'Rp ', // Simbol Rupiah
      decimalDigits: 0, // Tanpa desimal
    );

    return formatter.format(parsedPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchCarData,
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Memuat data mobil...', style: TextStyle(fontSize: 16)),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.redAccent, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.redAccent),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage ?? 'Terjadi kesalahan',
                            style: TextStyle(
                              color: Colors.red[800],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _carList.length,
                  itemBuilder: (context, index) {
                    final car = _carList[index];
                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        title: Text(
                          car['nama'] ?? 'Nama tidak tersedia',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Harga: ${_formatCurrency(car['harga'])}',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        leading: car['image_url'] != null &&
                                car['image_url'] != ""
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  car['image_url'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.broken_image,
                                            color: Colors.red),
                                        Text("Gagal memuat gambar",
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : Icon(Icons.image_not_supported,
                                color: Colors.grey[500], size: 40),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool? confirmDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Konfirmasi Hapus'),
                                      content: Text(
                                          'Apakah Anda yakin ingin menghapus mobil ini?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Batal'),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Hapus'),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmDelete == true) {
                                  _deleteCar(car['id']);
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.visibility, color: Colors.blue),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.viewCar,
                                  arguments: car,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.editCar,
                                  arguments: car,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addCar);
        },
        label: Text('Tambah Mobil', style: TextStyle(fontSize: 16)),
        icon: Icon(Icons.add),
      ),
    );
  }
}
