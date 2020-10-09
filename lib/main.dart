import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'customer.dart';
import 'models/customer.dart';
import 'package:alice/alice.dart';

void main() {
  runApp(MyApp());
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorKey: navigatorKey,
      home: MyHomePage(title: 'All Customers'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Alice alice;

  @override
  void initState() {
    alice = Alice(showNotification: true,navigatorKey: navigatorKey);
  }

  Future<List<Customer>> getCustomers() async {
    final url = "http://192.168.31.26:8000/api/customers";
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    });
    alice.onHttpResponse(response);

    var jsonData = json.decode(response.body);

    List<Customer> customers = [];

    for (var item in jsonData['customers']) {
      Customer customer = Customer(item['id'].toString(),item['name'], item['email'],
          item['password'], item['address'], item['mobile']);
      customers.add(customer);
    }
    return customers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: getCustomers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading.."),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Customer customer = snapshot.data[index];
                    return ListTile(
                      title: Text(customer.name),
                      subtitle: Text(customer.email),
                      trailing: GestureDetector(
                        onTap: () async{
                          final url = "http://192.168.31.26:8000/api/delete";
                          var response = await http.post(url,body: {"customer_id": customer.id});
                          setState(() {

                          });
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    );
                  });
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateCustomer()),
          );
          setState(() {});
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _deleteCustomer(String id) async {

  }
}
