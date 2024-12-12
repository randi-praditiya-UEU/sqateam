import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class EditCarPage extends StatefulWidget {
  final Map<String, dynamic> car;

  EditCarPage({required this.car});

  @override
  _EditCarPageState createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _transmissionController;
  late TextEditingController _fuelController;
  late TextEditingController _ccController;
  late TextEditingController _colorController;
  late TextEditingController _yearController;

  File? _imageFile;
  String? _imageError;
  String? _previousImageUrl;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.car['nama']);
    _priceController =
        TextEditingController(text: widget.car['harga'].toString());
    _brandController = TextEditingController(text: widget.car['merk']);
    _modelController = TextEditingController(text: widget.car['model']);
    _transmissionController =
        TextEditingController(text: widget.car['transmisi']);
    _fuelController = TextEditingController(text: widget.car['bahan_bakar']);
    _ccController = TextEditingController(text: widget.car['cc']);
    _colorController = TextEditingController(text: widget.car['warna']);
    _yearController = TextEditingController(text: widget.car['tahun']);

    _previousImageUrl = widget.car['image_url'];
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && mounted) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageError = null;
      });
    }
  }

  bool _isImageValid() {
    if (_imageFile == null) {
      return true;
    }

    final mimeType = lookupMimeType(_imageFile!.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      setState(() {
        _imageError = 'File yang dipilih bukan gambar!';
      });
      return false;
    }
    return true;
  }

  Future<void> _updateCar() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null && !_isImageValid()) {
        return;
      }

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            'https://api.djncloud.my.id/api/v1/mobil/${widget.car['id']}'),
      );

      // Menambahkan field data lainnya
      request.fields['nama'] = _nameController.text;
      request.fields['harga'] = _priceController.text;
      request.fields['merk'] = _brandController.text;
      request.fields['model'] = _modelController.text;
      request.fields['transmisi'] = _transmissionController.text;
      request.fields['bahan_bakar'] = _fuelController.text;
      request.fields['cc'] = _ccController.text;
      request.fields['warna'] = _colorController.text;
      request.fields['tahun'] = _yearController.text;

      if (_imageFile != null) {
        var mimeType = lookupMimeType(_imageFile!.path);
        var file = await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
          contentType: MediaType.parse(mimeType!),
        );
        request.files.add(file);
      }

      try {
        var response = await request.send();

        if (mounted) {
          if (response.statusCode == 200) {
            setState(() {
              _statusMessage = 'Mobil berhasil diperbarui!';
            });
            print('Response Status Code: 200');
            print('Response Body: ${await response.stream.bytesToString()}');
          } else {
            setState(() {
              _statusMessage =
                  'Gagal memperbarui mobil! Status Code: ${response.statusCode}';
            });
            print('Failed response with status code: ${response.statusCode}');
            print('Response Body: ${await response.stream.bytesToString()}');
          }
        }
      } catch (e) {
        print('Error: $e');
        if (mounted) {
          setState(() {
            _statusMessage = 'Terjadi kesalahan saat mengupdate mobil!';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Mobil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nama Mobil'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama mobil tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Harga Mobil'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga mobil tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(labelText: 'Merk Mobil'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Merk mobil tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _modelController,
                  decoration: InputDecoration(labelText: 'Model Mobil'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Model mobil tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _transmissionController,
                  decoration: InputDecoration(labelText: 'Transmisi Mobil'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Transmisi mobil tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _fuelController,
                  decoration: InputDecoration(labelText: 'Bahan Bakar Mobil'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bahan bakar mobil tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ccController,
                  decoration: InputDecoration(labelText: 'CC Mobil'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'CC mobil tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _colorController,
                  decoration: InputDecoration(labelText: 'Warna Mobil'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Warna mobil tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(labelText: 'Tahun Mobil'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tahun mobil tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : (_previousImageUrl != null
                        ? Image.network(
                            _previousImageUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Container()),
                if (_imageError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _imageError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pilih Gambar Mobil'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateCar,
                  child: Text('Perbarui Mobil'),
                ),
                if (_statusMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      _statusMessage!,
                      style: TextStyle(
                          color: _statusMessage == 'Mobil berhasil diperbarui!'
                              ? Colors.green
                              : Colors.red),
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
