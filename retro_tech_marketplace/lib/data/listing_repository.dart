import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/listing.dart';
import '../models/order_record.dart';
import '../models/user_profile.dart';
import '../store/seed_data.dart';

class ListingRepository {
  static const _databaseName = 'retro_tech_marketplace.db';
  static const _databaseVersion = 2;
  static const _listingsTable = 'listings';
  static const _profileTable = 'profile';
  static const _savedItemsTable = 'saved_items';
  static const _ordersTable = 'orders';
  static const _sellerFollowsTable = 'seller_follows';

  Database? _database;

  Future<Database> get _db async {
    final existing = _database;
    if (existing != null) return existing;

    final databasePath = await getDatabasesPath();
    final database = await openDatabase(
      p.join(databasePath, _databaseName),
      version: _databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
    _database = database;
    return database;
  }

  Future<void> _createDatabase(Database db, int version) async {
    await _createListingsTable(db);
    await _createFeatureTables(db);
    await _seedListings(db);
    await _ensureDefaultProfile(db);
  }

  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await _createFeatureTables(db);
      await _ensureDefaultProfile(db);
    }
  }

  Future<void> _createListingsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $_listingsTable (
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
  }

  Future<void> _seedListings(Database db) async {
    final batch = db.batch();
    for (var index = 0; index < seedListings.length; index += 1) {
      batch.insert(_listingsTable, seedListings[index].toMap(sortOrder: index));
    }
    await batch.commit(noResult: true);
  }

  Future<void> _createFeatureTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_profileTable (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        displayName TEXT NOT NULL,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        bio TEXT NOT NULL,
        location TEXT NOT NULL,
        sellerName TEXT NOT NULL,
        preferredContact TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_savedItemsTable (
        listingId TEXT PRIMARY KEY,
        savedAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_ordersTable (
        id TEXT PRIMARY KEY,
        listingId TEXT NOT NULL,
        listingTitle TEXT NOT NULL,
        seller TEXT NOT NULL,
        imageAsset TEXT NOT NULL,
        itemPrice REAL NOT NULL,
        shipping REAL NOT NULL,
        protectionFee REAL NOT NULL,
        paymentMethodId TEXT NOT NULL,
        paymentMethodTitle TEXT NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_sellerFollowsTable (
        seller TEXT PRIMARY KEY,
        followedAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _ensureDefaultProfile(Database db) async {
    await db.insert(
      _profileTable,
      UserProfile.defaults.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Listing>> load() async {
    final db = await _db;
    final rows = await db.query(_listingsTable, orderBy: 'sortOrder ASC');
    return rows.map(Listing.fromMap).toList();
  }

  Future<void> add(Listing listing) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE $_listingsTable SET sortOrder = sortOrder + 1',
      );
      await txn.insert(_listingsTable, listing.toMap(sortOrder: 0));
    });
  }

  Future<void> update(Listing listing) async {
    final db = await _db;
    await db.update(
      _listingsTable,
      listing.toMap(),
      where: 'id = ?',
      whereArgs: [listing.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete(_listingsTable, where: 'id = ?', whereArgs: [id]);
    await db.delete(_savedItemsTable, where: 'listingId = ?', whereArgs: [id]);
  }

  Future<UserProfile> loadProfile() async {
    final db = await _db;
    await _ensureDefaultProfile(db);
    final rows = await db.query(_profileTable, limit: 1);
    return rows.isEmpty
        ? UserProfile.defaults
        : UserProfile.fromMap(rows.first);
  }

  Future<void> saveProfile(UserProfile profile) async {
    final db = await _db;
    await db.insert(
      _profileTable,
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Set<String>> loadSavedItemIds() async {
    final db = await _db;
    final rows = await db.query(_savedItemsTable, orderBy: 'savedAt DESC');
    return rows.map((row) => row['listingId'] as String).toSet();
  }

  Future<void> setSaved(String listingId, bool saved) async {
    final db = await _db;
    if (saved) {
      await db.insert(_savedItemsTable, {
        'listingId': listingId,
        'savedAt': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      return;
    }
    await db.delete(
      _savedItemsTable,
      where: 'listingId = ?',
      whereArgs: [listingId],
    );
  }

  Future<List<OrderRecord>> loadOrders() async {
    final db = await _db;
    final rows = await db.query(_ordersTable, orderBy: 'createdAt DESC');
    return rows.map(OrderRecord.fromMap).toList();
  }

  Future<void> addOrder(OrderRecord order) async {
    final db = await _db;
    await db.insert(
      _ordersTable,
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Set<String>> loadFollowedSellers() async {
    final db = await _db;
    final rows = await db.query(_sellerFollowsTable);
    return rows.map((row) => row['seller'] as String).toSet();
  }

  Future<void> setFollowing(String seller, bool following) async {
    final db = await _db;
    if (following) {
      await db.insert(_sellerFollowsTable, {
        'seller': seller,
        'followedAt': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      return;
    }
    await db.delete(
      _sellerFollowsTable,
      where: 'seller = ?',
      whereArgs: [seller],
    );
  }
}
