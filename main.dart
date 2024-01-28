import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class Transakcja {
  final String title;
  final double amount;
  final DateTime timestamp;

  Transakcja({required this.title, required this.amount, required this.timestamp});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Bilans(),
    );
  }
}

class Bilans extends StatefulWidget {
  @override
  BilansState createState() => BilansState();
}

class BilansState extends State<Bilans> {
  double accountBalance = 0.0;
  List<Transakcja> transactionHistory = [];

  void addTransaction(String title, double amount) {
    setState(() {
      accountBalance += amount;
      transactionHistory.insert(0, Transakcja(title: title, amount: amount, timestamp: DateTime.now()));
    });
  }

  Color mainColor() {
    return accountBalance >= 0 ? Colors.green[100]! : Colors.red[100]!;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pieniążki',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Bieżące',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  'Historia',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: Container(
          color: mainColor(),
          child: TabBarView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Stan Konta: ${accountBalance.toStringAsFixed(2)} zł',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String title = '';
                            double amount = 0.0;
                            return AlertDialog(
                              title: Text('Dodaj kwotę'),
                              content: Column(
                                children: [
                                  TextField(
                                    decoration: InputDecoration(labelText: 'Tytuł'),
                                    onChanged: (value) {
                                      setState(() {
                                        title = value;
                                      });
                                    },
                                  ),
                                  TextField(
                                    decoration: InputDecoration(labelText: 'Kwota'),
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        double parsedAmount = double.tryParse(value) ?? 0.0;
                                        setState(() {
                                          amount = parsedAmount;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Dodaj'),
                                  onPressed: () {
                                    addTransaction(title, amount);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Odejmij'),
                                  onPressed: () {
                                    addTransaction(title, -amount);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Dodaj'),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                itemCount: transactionHistory.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Transakcja: ${transactionHistory[index].amount.toStringAsFixed(2)} zł'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tytuł: ${transactionHistory[index].title}'),
                        Text('Data: ${DateFormat('dd-MM-yyyy HH:mm:ss').format(transactionHistory[index].timestamp)}'),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
