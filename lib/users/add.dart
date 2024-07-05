import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uasFlutter/home/HomePage.dart';

class UsersAdd extends StatefulWidget {
  const UsersAdd({Key? key}) : super(key: key);

  @override
  _UsersAddState createState() => _UsersAddState();
}

class _UsersAddState extends State<UsersAdd> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // ignore: override_on_non_overriding_member

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  late String email;
  late String name;
  late String alamat;
  late String password;
  

  bool _passwordVisible = false;
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Tambah Users'),
              leading: IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () => Navigator.pop(context, false),
              ),
            ),
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Form(
                key: _formKey,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan Nama Lengkap';
                            }
                            return null;
                          },
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: const Icon(Icons.person),
                              labelText: 'Masukan Nama',
                              hintText: 'Masukan Nama'),
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan Email';
                            }
                            return null;
                          },
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: const Icon(Icons.person),
                              labelText: 'Masukan Email',
                              hintText: 'Masukan Email'),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: !_passwordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan Password';
                            }
                            return null;
                          },
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _passwordVisible =
                                        _passwordVisible ? false : true;
                                  });
                                },
                                child: Icon(_passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              prefixIcon: const Icon(Icons.key),
                              labelText: 'Masukan Password',
                              hintText: 'Masukan Password'),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan Alamat';
                            }
                            return null;
                          },
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: const Icon(Icons.person),
                              labelText: 'Masukan Alamat',
                              hintText: 'Masukan Alamat'),
                          onChanged: (value) {
                            setState(() {
                              alamat = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                // print(filePath);
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                var token = preferences.getString('token');
                                var url =
                                    Uri.parse('${dotenv.env['url']}/addUsers');
                                var request =
                                    http.MultipartRequest("POST", url);
                                // print(imagepath);
                                request.fields['name'] = name;
                                request.fields['email'] = email;
                                request.fields['password'] = password;
                                request.fields['alamat'] = alamat;

                                request.headers['Authorization'] =
                                    'Bearer $token';
                                request.headers['Accept'] = 'application/json';
                                request.headers['Content-Type'] =
                                    'multipart/form-data';

                                final response = await request.send();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const Homepage(),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 10),
                              child: const Center(
                                child: Text(
                                  "Simpan",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(9, 107, 199, 1),
                                  borderRadius: BorderRadius.circular(10)),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
