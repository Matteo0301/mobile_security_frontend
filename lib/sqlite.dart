import 'package:mobile_security/config.dart';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class SavedConfig {
  final bool darkTheme;

  SavedConfig({required this.darkTheme});
}

Database? db;

void openDB(String username, String password) async {
  db = await openDatabase(
    join(await getDatabasesPath(), '$username.db'),
    password: password,
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      db.execute('CREATE TABLE bool_settings(id TEXT PRIMARY KEY, value BIT)');
      db.insert('bool_settings', {
        'id': 'darkTheme',
        'value': 0,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  loadConfig();
}

Future<void> loadConfig() async {
  if (db == null) return;

  final List<Map<String, Object?>> bool_settings = await db!.query(
    'bool_settings',
  );
  print(bool_settings);
  for (var setting in bool_settings) {
    if (setting['id'] == 'darkTheme') {
      Config.darkTheme = (setting['value'] as int) == 1;
    }
  }
}

Future<void> updateTheme(bool darkTheme) async {
  if (db == null) return;
  await db!.update(
    'bool_settings',
    {'id': 'darkTheme', 'value': darkTheme ? 1 : 0},
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: ['darkTheme'],
  );
}

void closeDB() {
  db = null;
}
