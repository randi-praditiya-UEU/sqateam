import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'route/routes.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  String? _validateEmail(String value) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) {
      return 'Email tidak valid';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password harus lebih dari 6 karakter';
    }
    return null;
  }

  String? _validateName(String value) {
    if (value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    return null;
  }

  Future<void> _register() async {
    String? emailError = _validateEmail(_emailController.text);
    String? passwordError = _validatePassword(_passwordController.text);
    String? nameError = _validateName(_nameController.text);

    if (emailError != null || passwordError != null || nameError != null) {
      setState(() {
        _errorMessage =
            emailError ?? passwordError ?? nameError ?? 'Periksa input Anda';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.djncloud.my.id/api/v1/account'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
          'name': _nameController.text,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi berhasil!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else if (response.statusCode == 400) {
        final responseData = json.decode(response.body);
        setState(() {
          _errorMessage = 'Email sudah terdaftar: ${responseData['message']}';
        });
      } else if (response.statusCode == 500) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan server, coba lagi nanti.';
        });
      } else {
        final responseData = json.decode(response.body);
        setState(() {
          _errorMessage = responseData['message'] ?? 'Gagal mendaftar';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Kesalahan Koneksi'),
          content: Text(
              'Tidak ada koneksi internet. Pastikan Anda terhubung ke jaringan dan coba lagi.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tutup'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Akun'),
        backgroundColor: Colors.blue[800], // Blue theme color
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selamat Datang!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Silakan daftarkan akun Anda untuk melanjutkan',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                  errorText: _isEmailValid
                      ? null
                      : _validateEmail(_emailController.text),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    _isEmailValid = _validateEmail(value) == null;
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  errorText: _isPasswordValid
                      ? null
                      : _validatePassword(_passwordController.text),
                ),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _isPasswordValid = _validatePassword(value) == null;
                  });
                },
              ),
              SizedBox(height: 24),
              if (_isLoading)
                CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    child: Text('Daftar', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue[800],
                    ),
                  ),
                ),
              if (_errorMessage != null) ...[
                SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ],
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sudah punya akun?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    child: Text('Login di sini'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
