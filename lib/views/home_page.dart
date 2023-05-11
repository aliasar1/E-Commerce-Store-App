import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var count = 0;
  var myText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text("My App"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                myText = "Logout Clicked";
              });
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                myText = "";
              });
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              myText,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Press Add to increament",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 40,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  if (count > 0) {
                    count--;
                  }
                });
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber)),
              icon: const Icon(Icons.remove),
              label: const Text("Decrement"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            count++;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
