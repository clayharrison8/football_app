import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Simulator extends StatefulWidget {
  const Simulator({Key? key}) : super(key: key);

  @override
  _SimulatorState createState() => _SimulatorState();
}

class _SimulatorState extends State<Simulator> {
  bool showCalculations = false;
  var calculations = [];

  final oddsC = TextEditingController();
  final startingBankC = TextEditingController();
  final percentageStakeC = TextEditingController();
  final strikeRateC = TextEditingController();
  final betsPlacedC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simulator'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: oddsC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Average Odds',
                  ),
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: startingBankC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Starting Bank',
                  ),
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: percentageStakeC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Percentage Staked',
                  ),
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: strikeRateC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Strike Rate',
                  ),
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: betsPlacedC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Bets Placed',
                  ),
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      calculations = totalPercentage(
                        double.parse(oddsC.text),
                        double.parse(startingBankC.text),
                        double.parse(percentageStakeC.text),
                        double.parse(strikeRateC.text),
                        int.parse(betsPlacedC.text),
                      );

                      showCalculations = true;
                    });
                  },
                  child: Text("Calculate"),
                ),
                showCalculations
                    ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              calculations[0],
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              calculations[1],
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                      )
                    : Text('')
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void getLeagueStats() async {
    Query favRef = await FirebaseDatabase.instance.ref().child("valid_leagues");

    print(favRef); // to debug and see if data is returned

    // Map<dynamic, dynamic> values = favRef.da;
    // values.forEach((key, values) {
    //   print(key);
    // });

    // return posts;
  }

  List totalPercentage(double odds, double startingBank, double percentage,
      double strikeRate, int numBets) {
    double win = 0;

    for (int i = 0; i < numBets; i++) {
      var stake = startingBank * percentage / 100;

      double randomNum = (Random().nextDouble() * 100) + 1;

      if (randomNum > strikeRate) {
        startingBank -= stake;
      } else {
        var profit = (stake * odds) - stake;
        startingBank += profit;
        win++;
      }
    }
    var f = NumberFormat("###,###.0#", "en_US");
    return [
      "Strike Rate = " + (win / numBets).toStringAsFixed(3),
      'Total = £${f.format(double.parse(startingBank.toStringAsFixed(2)))}'
    ];
  }
}
