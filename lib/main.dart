import 'package:flutter/material.dart';
import 'belt_screen.dart';
import 'order_screen.dart';

void main() => runApp(const MaterialApp(home: Home()));

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_tab == 0 ? 'The Order' : 'The Belt')),
      body: _tab == 0 ? const OrderScreen() : const BeltScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'The Order'),
          NavigationDestination(icon: Icon(Icons.pets), label: 'The Belt'),
        ],
      ),
    );
  }
}
