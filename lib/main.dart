import 'dart:math';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'item.dart';
import 'person.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

List<Person> people = [
  Person(name: "Random"),
  Person(name: "Gautam"),
  Person(name: "Aniruddh"),
  Person(name: "Sarthak"),
  Person(name: "Sahil"),
  Person(name: "Kunal"),
  Person(name: "Divyanshu"),
  Person(name: "Ambikesh"),
  Person(name: "Agrim"),
  Person(name: "Kartik"),
  Person(name: "Mitul"),
  Person(name: "Shailesh"),
  Person(name: "Khush"),
  Person(name: "Shantanu"),
  Person(name: "Yash"),
  Person(name: "Shivansh"),
];
List<Item> foods = [
  Item(name: "Cold Coffee", cost: 60),
  Item(name: "Peri Peri Fries", cost: 40),
  Item(name: "Aloo pyaz parathe", cost: 25),
  Item(name: "Butter", cost: 15),
  Item(name: "Plain Maggi", cost: 30),
  Item(name: "Fried Maggi", cost: 50),
  Item(name: "Toasted Cheese Sandwich", cost: 60),
  Item(name: "Toasted Chicken Sandwich", cost: 100),
  Item(name: "Shake", cost: 60),
  Item(name: "Aloo Parath", cost: 20),
  Item(name: "Fries", cost: 30),
  Item(name: "Veg Burger", cost: 35),
  Item(name: "Cold Drink", cost: 20),
  Item(name: "Paper Boat", cost: 10),
  Item(name: "Chicken Fried Rice", cost: 70),
  Item(name: "White Sauce Pasta", cost: 70),
  Item(name: "Red Sauce Pasta", cost: 50),
  Item(name: "Honey Chilli Potato", cost: 60),
];
List<int> tot = [];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int sel = 0;
  int overall = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < people.length; i++) {
      while (people[i].val.length < foods.length) {
        people[i].val.add(0);
      }
    }
    while (tot.length < foods.length) {
      tot.add(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(people[sel].name),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  String order = "";
                  String temp = "";
                  for (int i = 0; i < tot.length; i++) {
                    if (tot[i] == 0) {
                      continue;
                    }
                    temp = foods[i].name + ": " + tot[i].toString();
                    order = order + "\n" + temp;
                  }
                  FlutterClipboard.copy(order).then((value) => print('copied'));
                },
                icon: Icon(Icons.copy),
              ),
              IconButton(
                onPressed: () {
                  String order = "";
                  String temp = "";
                  for (int i = 0; i < people.length; i++) {
                    int price = 0;
                    bool cond = false;
                    for (int j = 0; j < people[i].val.length; j++) {
                      if (people[i].val[j] != 0) {
                        cond = true;
                        break;
                      }
                    }
                    if (cond == false) {
                      continue;
                    }
                    order += people[i].name + "\n";
                    for (int j = 0; j < people[i].val.length; j++) {
                      if (people[i].val[j] == 0) {
                        continue;
                      }
                      order += foods[j].name +
                          ": " +
                          people[i].val[j].toString() +
                          "\n";
                      price += foods[j].cost * people[i].val[j];
                    }
                    overall += price;
                    order +=
                        people[i].name + "'s Total: " + price.toString() + "\n";
                  }
                  order += "Overall Total: " + overall.toString();
                  FlutterClipboard.copy(order).then((value) => print('copied'));
                },
                icon: Icon(Icons.copy_all),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.change_circle),
        onPressed: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            context: context,
            builder: (BuildContext context) {
              return ListView.builder(
                itemCount: people.length,
                itemBuilder: (_, ind) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          sel = ind;
                        });
                        Navigator.pop(context);
                        setState(() {});
                      },
                      title: Text(people[ind].name),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (_, ind) {
          return Card(
            child: ListTile(
              title: Text(foods[ind].name),
              subtitle: Column(
                children: [
                  Text(foods[ind].cost.toString()),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (people[sel].val[ind] != 0) {
                            tot[ind]--;
                          }
                          people[sel].val[ind]--;
                          people[sel].val[ind] = max(0, people[sel].val[ind]);
                          setState(() {});
                        },
                        icon: Icon(CupertinoIcons.minus_circle),
                      ),
                      Text(people[sel].val[ind].toString()),
                      IconButton(
                        onPressed: () {
                          people[sel].val[ind]++;
                          tot[ind]++;
                          setState(() {});
                        },
                        icon: Icon(CupertinoIcons.add_circled),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
