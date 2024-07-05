import 'dart:convert';
import 'package:uasFlutter/login/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uasFlutter/users/add.dart';
import 'package:uasFlutter/users/update.dart';

/// Flutter code sample for [Card].

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static final _client = http.Client();
  static final _logoutUrl = Uri.parse('${dotenv.env['url']}/logout');
  static final _deleteUrl = Uri.parse('${dotenv.env['url']}/deleteUsers');

  // ignore: non_constant_identifier_names
  Future Logout() async {
    try {
      EasyLoading.show(status: 'loading...');
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      http.Response response = await _client.get(_logoutUrl, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      // print(response.body);
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        setState(() {
          preferences.remove("id");
          preferences.remove("name");
          preferences.remove("no_hp");
          preferences.remove("alamat");
          preferences.remove("role_id");
          preferences.remove("jabatan_id");
          preferences.remove("status");
          preferences.remove("token");
          preferences.remove("is_login");
        });
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future DeleteUsers(id) async {
    try {
      EasyLoading.show(status: 'loading...');
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      http.Response response = await _client
          .get(Uri.parse('${dotenv.env['url']}/deleteUsers/$id'), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      // print(response.body);
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const Homepage(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showMyDialog(String title, String text, String nobutton,
      String yesbutton, Function onTap, bool isValue) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: isValue,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(nobutton),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(yesbutton),
              onPressed: () async {
                Logout();
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogDelete(String title, String text, String nobutton,
      String yesbutton, Function onTap, bool isValue, id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: isValue,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(nobutton),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(yesbutton),
              onPressed: () async {
                DeleteUsers(id);
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
          ],
        );
      },
    );
  }

  List _listsData = [];
  Future<dynamic> listUsers() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      var url = Uri.parse('${dotenv.env['url']}/getAllUsers');
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print(data);
        setState(() {
          _listsData = data['data'];
          // print(_listsData);
        });
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    listUsers();
  }

  Future refresh() async {
    setState(() {
      listUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new),
            onPressed: () {
              _showMyDialog('Log Out', 'Are you sure you want to logout?', 'No',
                  'Yes', () async {}, false);

              // ignore: unused_label
              child:
              const Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              );
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          itemCount: _listsData.length,
          itemBuilder: (context, index) => Card(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ListTile(
                  onLongPress: () {
                    _showMyDialogDelete(
                        'Delete',
                        'Are you sure you want to Delete Users?',
                        'No',
                        'Yes',
                        () async {},
                        false,
                        _listsData[index]['id']);
                  },
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateUsers(
                                  id: _listsData[index]['id'].toString(),
                                  name: _listsData[index]['name'],
                                  email: _listsData[index]['email'],
                                  alamat: _listsData[index]['alamat'],
                                )));
                  },
                  title: Text(
                    "Nama: ${_listsData[index]['name']}",
                    style: const TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    "Alamat : ${_listsData[index]['alamat']}",
                    maxLines: 2,
                    style: const TextStyle(fontSize: 14.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UsersAdd(),
              ));
          // setState(() {
          //   if (res is String) {
          //     print(res);
          //   }
          // });
          // var url = Uri.parse('${dotenv.env['url']}/absen');
          // final response = await http.post(url, headers: {
          //   "Accept": "application/json",
          //   "Authorization": "Bearer $token",
          // }, body: {
          //   "status": 1,
          //   "latitude": '',
          //   "longitude": '',
          // });
          // // print(response.body);
          // if (response.statusCode == 200) {
          //   final data = jsonDecode(response.body);
          //   // print(data);
          //   setState(() async {
          //     // _listsData = data['file'];
          //     // print(data['file']);
          //     // final Uri uri = Uri.parse(data['file']);
          //   });
          // }
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
