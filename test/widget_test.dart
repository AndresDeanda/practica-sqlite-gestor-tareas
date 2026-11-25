import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/base_datos.dart';
import 'package:gestor_tareas_local/main.dart';

void main() {
  testWidgets('Muestra el gestor de tareas inicial', (WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async => await db.close());

    await tester.pumpWidget(GestorTareasApp(db: db));
    await tester.pumpAndSettle();

    expect(find.text('Gestor de tareas'), findsOneWidget);
    expect(find.text('Todavía no hay tareas guardadas'), findsOneWidget);
  });
}