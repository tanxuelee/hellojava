import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellojava/constants.dart';
import 'package:hellojava/models/admin.dart';
import 'package:hellojava/models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ManageUserScreen extends StatefulWidget {
  final Admin admin;
  const ManageUserScreen({
    Key? key,
    required this.admin,
  }) : super(key: key);

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<User> userList = <User>[];
  String titlecenter = "";
  Widget _verticalDivider = const VerticalDivider(
    thickness: 2,
  );

  @override
  void initState() {
    super.initState();
    _loadUserList();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage User',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: userList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)))
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: DataTable(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          columnSpacing: 30.0,
                          dividerThickness: 2.0,
                          columns: [
                            const DataColumn(
                                label: Text(
                              'User Email',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            DataColumn(label: _verticalDivider),
                            const DataColumn(label: Text('')),
                          ],
                          rows: List<DataRow>.generate(
                            userList.length,
                            (index) => DataRow(
                              cells: [
                                DataCell(
                                  GestureDetector(
                                    onTap: () => {_moreDetails(index)},
                                    child: Text(
                                      userList[index].email.toString(),
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black),
                                    ),
                                  ),
                                ),
                                DataCell(_verticalDivider),
                                DataCell(
                                  IconButton(
                                      onPressed: () =>
                                          _confirmationDelete(index),
                                      icon: const Center(
                                        child: Icon(
                                          Icons.delete,
                                          size: 20.0,
                                          color: Color(0xFFF9A03F),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _loadUserList() {
    http
        .post(
      Uri.parse(CONSTANTS.server + "/hellojava/php/load_users.php"),
    )
        .timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        titlecenter = "Timeout Please retry again later";
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['user'] != null) {
          userList = <User>[];
          extractdata['user'].forEach((v) {
            userList.add(User.fromJson(v));
          });
        } else {
          titlecenter = "No User Available";
          userList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No User Available";
        userList.clear();
        setState(() {});
      }
    });
  }

  _confirmationDelete(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF4F4F4),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text('Delete User Account?'),
        content: const Text('Are you sure want to delete this user account?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteUser(index);
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(int index) async {
    var url = Uri.parse(CONSTANTS.server + "/hellojava/php/delete_user.php");
    var response = await http.post(url, body: {
      'id': userList[index].id.toString(),
    });
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: jsondata['data'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFF4F646F));
        setState(() {
          _loadUserList();
        });
      } else {
        Fluttertoast.showToast(
            msg: jsondata['data'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14,
            backgroundColor: const Color(0xFFAB3232));
      }
    } else {
      Fluttertoast.showToast(
          msg: "Failed to delete user account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14,
          backgroundColor: const Color(0xFFAB3232));
    }
  }

  void _moreDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: AlertDialog(
              backgroundColor: const Color(0xFFF4F4F4),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: const Text("User Details:",
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              content: SingleChildScrollView(
                  child: Text(
                      'Name: ' +
                          userList[index].name.toString() +
                          '\nEmail: ' +
                          userList[index].email.toString() +
                          '\nPhone Number: ' +
                          userList[index].phone.toString() +
                          '\nRegistration Date:\n' +
                          userList[index].datereg.toString(),
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black))),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        });
  }
}
