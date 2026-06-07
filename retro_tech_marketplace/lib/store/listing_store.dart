import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import '../models/listing.dart';
import 'seed_data.dart';

class ListingStore extends ChangeNotifier {
  static const _databaseName = 'retro_tech_marketplace.db';
  static const _databaseVersion = 1;
  static const _tableName = 'listings';

  final List<Listing> _listings = [];
  bool _loaded = false;
  Database? _database;

  List<Listing> get listings => List.unmodifiable(_listings);
  bool get loaded => _loaded;

  Future<Database> get _db async {
    final existing = _database;
    if (existing != null) return existing;

    final databasePath = await getDatabasesPath();
    final database = await openDatabase(
      p.join(databasePath, _databaseName),
      version: _databaseVersion,
      onCreate: _createDatabase,
    );
    _database = database;
    return database;
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        subtitle TEXT NOT NULL,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        condition TEXT NOT NULL,
        description TEXT NOT NULL,
        storage TEXT NOT NULL,
        battery TEXT NOT NULL,
        connector TEXT NOT NULL,
        imageAsset TEXT NOT NULL,
        status TEXT NOT NULL,
        views INTEGER NOT NULL,
        seller TEXT NOT NULL,
        rating REAL NOT NULL,
        reviews INTEGER NOT NULL,
        sortOrder INTEGER NOT NULL
      )
    ''');

    final batch = db.batch();
    for (var index = 0; index < seedListings.length; index += 1) {
      batch.insert(_tableName, seedListings[index].toMap(sortOrder: index));
    }
    await batch.commit(noResult: true);
  }

  Future<void> load() async {
    if (_loaded) return;
    final db = await _db;
    final rows = await db.query(_tableName, orderBy: 'sortOrder ASC');
    _listings
      ..clear()
      ..addAll(rows.map(Listing.fromMap));
    _loaded = true;
    notifyListeners();
  }

  Listing? byId(String id) {
    for (final listing in _listings) {
      if (listing.id == id) return listing;
    }
    return null;
  }

  List<Listing> byCategory(String category) {
    return _listings
        .where(
          (listing) => listing.category.toLowerCase() == category.toLowerCase(),
        )
        .toList();
  }

  Future<void> add(Listing listing) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.rawUpdate('UPDATE $_tableName SET sortOrder = sortOrder + 1');
      await txn.insert(_tableName, listing.toMap(sortOrder: 0));
    });
    _listings.insert(0, listing);
    notifyListeners();
  }

  Future<void> update(Listing listing) async {
    final index = _listings.indexWhere((item) => item.id == listing.id);
    if (index == -1) return;
    final db = await _db;
    await db.update(
      _tableName,
      listing.toMap(),
      where: 'id = ?',
      whereArgs: [listing.id],
    );
    _listings[index] = listing;
    notifyListeners();
  }

  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    _listings.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
