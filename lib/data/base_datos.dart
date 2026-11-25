import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'base_datos.g.dart';

class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titulo => text().withLength(min: 1)();
  BoolColumn get completada => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Tareas])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'gestor_tareas_db',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.dart.js'),
    ),
  );
}

  Stream<List<Tarea>> observarTareas() {
    final query = select(tareas)..orderBy([(t) => OrderingTerm.desc(t.id)]);
    return query.watch();
  }

  Future<int> insertarTarea(String titulo) async {
    final limpio = titulo.trim();
    if (limpio.isEmpty) {
      throw ArgumentError('El título de la tarea no puede estar vacío.');
    }
    return into(tareas).insert(
      TareasCompanion.insert(titulo: limpio),
    );
  }

  Future<void> actualizarTitulo(int id, String nuevoTitulo) async {
    final limpio = nuevoTitulo.trim();
    if (limpio.isEmpty) {
      throw ArgumentError('El título de la tarea no puede estar vacío.');
    }
    await (update(tareas)..where((t) => t.id.equals(id))).write(
      TareasCompanion(titulo: Value(limpio)),
    );
  }

  Future<void> actualizarCompletada(int id, bool completada) async {
    await (update(tareas)..where((t) => t.id.equals(id))).write(
      TareasCompanion(completada: Value(completada)),
    );
  }

  Future<void> eliminarTarea(int id) async {
    await (delete(tareas)..where((t) => t.id.equals(id))).go();
  }
}