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

class UpdateUsers extends StatefulWidget {
  const UpdateUsers({Key? key, this.id, this.name, this.email, this.alamat})
      : super(key: key);
  final String? id;
  final String? name;
  final String? email;
  final String? alamat;

  @override
  _UpdateUsersState createState() => _UpdateUsersState();
}

class _UpdateUsersState extends State<UpdateUsers> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // ignore: override_on_non_overriding_member

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  late String? emailEdit;
  late String? nameEdit;
  late String? alamatEdit;
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
              title: const Text('Update Users'),
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
                          initialValue: widget.name,
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
                              nameEdit = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: widget.email,
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
                              emailEdit = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: widget.alamat,
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
                              alamatEdit = value;
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
                                var url = Uri.parse(
                                    '${dotenv.env['url']}/updateUsers');
                                var request =
                                    http.MultipartRequest("POST", url);
                                // print(imagepath);
                                request.fields['id'] = widget.id.toString();
                                request.fields['name'] = nameEdit.toString();
                                request.fields['email'] = emailEdit.toString();
                                request.fields['alamat'] = alamatEdit.toString();
                                print(required);
                                request.headers['Authorization'] =
                                    'Bearer $token';
                                request.headers['Accept'] = 'application/json';
                                request.headers['Content-Type'] =
                                    'multipart/form-data';

                                final response = await request.send();
                                print(response);
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
                                  "Update",
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
