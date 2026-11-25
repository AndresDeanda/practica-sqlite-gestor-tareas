import 'package:flutter/material.dart';
import 'data/base_datos.dart';
import 'screens/tareas_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  runApp(GestorTareasApp(db: db));
}

class GestorTareasApp extends StatelessWidget {
  final AppDatabase db;

  const GestorTareasApp({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de tareas',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: TareasPage(db: db),
    );
  }
}