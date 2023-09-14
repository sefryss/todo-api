import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/snackbar_helper.dart';

class AddScreen extends StatefulWidget {
  final Map? todo;
  const AddScreen({
    super.key,
    this.todo,
  });

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  //Membuat controller untuk Judul dan Deskripsi
  TextEditingController judulController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final judul = todo['title'];
      final deskripsi = todo['description'];
      judulController.text = judul;
      deskripsiController.text = deskripsi;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Data' : 'Tambah Data',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: judulController,
            decoration: const InputDecoration(
              labelText: 'Judul',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: deskripsiController,
            decoration: const InputDecoration(
              labelText: 'Deskripsi',
            ),
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  isEdit ? 'Update' : 'Submit',
                ),
              ))
        ],
      ),
    );
  }

  //Form Handling

  //Update
  Future<void> updateData() async {
    //Mengambil data dari form
    final todo = widget.todo;
    if (todo == null) {
      print('Tidak bisa mengupdate data tanpa todo data');
      return;
    }
    final id = todo['_id'];
    final judul = judulController.text;
    final deskripsi = deskripsiController.text;
    final body = {
      "title": judul,
      "description": deskripsi,
      "is_completed": false
    };

    //Menyimpan perubahan data ke server
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    //Menampilkan pesan berhasil maupun error
    if (response.statusCode == 200) {
      //Menampilkan pesan sukses
      showSuccessMessage(context, message: 'Data berhasil diubah');
    } else {
      //Menampilkan pesan error
      showErrorMessage(context, message: 'Data gagal diubah');
    }
  }

  //GET
  Future<void> submitData() async {
    //Mengambil data dari form
    final judul = judulController.text;
    final deskripsi = deskripsiController.text;
    final body = {
      "title": judul,
      "description": deskripsi,
      "is_completed": false
    };

    //Menyimpan data ke server
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    //Menampilkan pesan berhasil maupun error
    if (response.statusCode == 201) {
      //Ketika data berhasil dibuat form kembali kosong
      judulController.text = '';
      deskripsiController.text = '';

      //Menampilkan pesan sukses
      showSuccessMessage(context, message: 'Data berhasil dibuat');
    } else {
      //Menampilkan pesan error
      showErrorMessage(context, message: 'Data gagal dibuat');
    }
  }
}
