import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/base_datos.dart';
import 'package:gestor_tareas_local/main.dart';

Future<void> _limpiarWidgetYDb(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(Duration.zero);
  await tester.pumpAndSettle();
  await tester.runAsync(() => db.close());
}

void main() {
  testWidgets('Muestra el gestor de tareas inicial', (WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(GestorTareasApp(db: db));
    await tester.pumpAndSettle();

    expect(find.text('Gestor de tareas'), findsOneWidget);
    expect(find.text('Todavía no hay tareas guardadas'), findsOneWidget);

    await _limpiarWidgetYDb(tester, db);
  });

  testWidgets('Rechaza guardar tareas vacías o solo con espacios',
      (WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(GestorTareasApp(db: db));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '     ');
    await tester.tap(find.text('Agregar tarea'));
    await tester.pumpAndSettle();

    expect(find.text('Escribe un título válido para la tarea.'), findsOneWidget);
    expect(find.text('Todavía no hay tareas guardadas'), findsOneWidget);

    await _limpiarWidgetYDb(tester, db);
  });

  testWidgets('Guarda una tarea y actualiza su estado de completada',
      (WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(GestorTareasApp(db: db));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Estudiar Drift');
    await tester.tap(find.text('Agregar tarea'));
    await tester.pumpAndSettle();

    expect(find.text('Estudiar Drift'), findsOneWidget);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    final tareasGuardadas =
        await tester.runAsync(() => db.select(db.tareas).get());
    expect(tareasGuardadas!.length, 1);
    expect(tareasGuardadas.first.titulo, 'Estudiar Drift');
    expect(tareasGuardadas.first.completada, isTrue);

    await _limpiarWidgetYDb(tester, db);
  });
}