import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


class CreateCustomer extends StatefulWidget {


  @override
  _CreateCustomerState createState() => _CreateCustomerState();
}

class _CreateCustomerState extends State<CreateCustomer> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Customer"),
      ),
      //resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 50.0,
          horizontal: 10.0,
        ),
        child: SingleChildScrollView(
          child: _buildForm(),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            debugPrint('All validations passed!!!');
            _saveformData();
          }
        },
        child: Icon(Icons.done),
      ),
    );
  }

  void showToast(String msg){
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameController,
              validator: (String value) {
                if(value.length < 3){
                  return "Name must be at least 3 characters long";
                }
                return null;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _emailController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Email cannot be empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _mobileController,
              validator: (String value) {
                return null;
              },
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Mobile',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: true,
              controller: _passwordController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Password cannot be empty';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters long.';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: true,
              controller: _confirmPasswordController,
              validator: (String value) {
                if (value != _passwordController.value.text) {
                  return 'Passwords do not match!';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _addressController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Address can not be empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<int> _saveformData() async {
    final name = _nameController.text.toString();
    final email = _emailController.text.toString();
    final password = _passwordController.text.toString();
    final mobile = _mobileController.text.toString();
    final address = _addressController.text.toString();

    Map postData = {
      "name":name,
      "email": email,
      "password": password,
      "mobile": mobile,
      "address": address
    };

    final String url = "http://192.168.31.26:8000/api/create";
    var response = await http.post(url,body: jsonEncode(postData),headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    });


    Navigator.pop(context);
  }
}