import 'package:flutter/material.dart';

import 'screens/appreciation_screen.dart';
import 'screens/b3_screen.dart';
import 'screens/converter_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/indices_screen.dart';
import 'screens/simulator_screen.dart';
import 'screens/sp500_screen.dart';

void main() {
  runApp(const InvestWatchApp());
}

class InvestWatchApp extends StatelessWidget {
  const InvestWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InvestWatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), useMaterial3: true),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _titles = ['Monitor', 'Conversor', 'Simulador', 'Ações B3', 'Ações S&P 500', 'Índices', 'Valorização'];

  static const _screens = [
    DashboardScreen(),
    ConverterScreen(),
    SimulatorScreen(),
    B3Screen(),
    SP500Screen(),
    IndicesScreen(),
    AppreciationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 720;

    final destinations = const [
      NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Monitor'),
      NavigationDestination(icon: Icon(Icons.currency_exchange), label: 'Conversor'),
      NavigationDestination(icon: Icon(Icons.calculate_outlined), selectedIcon: Icon(Icons.calculate), label: 'Simulador'),
      NavigationDestination(icon: Icon(Icons.show_chart), label: 'Ações B3'),
      NavigationDestination(icon: Icon(Icons.flag), label: 'S&P 500'),
      NavigationDestination(icon: Icon(Icons.public), label: 'Índices'),
      NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Valorização'),
    ];

    final body = IndexedStack(index: _index, children: _screens);

    if (wide) {
      return Scaffold(
        appBar: AppBar(title: Text(_titles[_index])),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(icon: d.icon, selectedIcon: d.selectedIcon, label: Text(d.label)),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: destinations,
      ),
    );
  }
}
