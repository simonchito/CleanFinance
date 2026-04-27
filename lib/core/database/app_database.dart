import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../constants/app_constants.dart';

// SQLite remains unencrypted by design to keep the app lightweight and offline-first.
// Access is intentionally centralized behind repositories so the storage boundary
// stays explicit and easier to harden over time.
class AppDatabase {
  Database? _database;

  Future<Database> get instance async {
    if (_database != null) {
      return _database!;
    }
    _database = await _open();
    return _database!;
  }

  Future<void> reset() async {
    final existing = _database;
    _database = null;
    if (existing != null && existing.isOpen) {
      await existing.close();
    }

    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, AppConstants.databaseName);
    await deleteDatabase(path);
  }

  Future<Database> _open() async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, AppConstants.databaseName);
    if (kDebugMode) {
      debugPrint('[startup] Opening SQLite database at $path');
    }

    return openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            icon_key TEXT NOT NULL DEFAULT 'category',
            scope TEXT NOT NULL,
            parent_id TEXT,
            is_default INTEGER NOT NULL DEFAULT 0,
            reminder_enabled INTEGER NOT NULL DEFAULT 0,
            reminder_day INTEGER,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE savings_goals(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            target_amount REAL NOT NULL,
            target_date TEXT,
            is_archived INTEGER NOT NULL DEFAULT 0,
            reminder_enabled INTEGER NOT NULL DEFAULT 0,
            reminder_day INTEGER,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE movements(
            id TEXT PRIMARY KEY,
            type TEXT NOT NULL,
            amount REAL NOT NULL,
            category_id TEXT NOT NULL,
            subcategory_id TEXT,
            goal_id TEXT,
            occurred_on TEXT NOT NULL,
            note TEXT,
            payment_method TEXT,
            monthly_reminder_enabled INTEGER NOT NULL DEFAULT 0,
            reminder_day INTEGER,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT,
            FOREIGN KEY (goal_id) REFERENCES savings_goals(id) ON DELETE SET NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE budgets(
            id TEXT PRIMARY KEY,
            category_id TEXT NOT NULL,
            monthly_limit REAL NOT NULL CHECK (monthly_limit >= 0),
            month TEXT NOT NULL,
            FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
          )
        ''');

        await db.execute('''
          CREATE TABLE app_settings(
            id INTEGER PRIMARY KEY CHECK (id = 1),
            currency_code TEXT NOT NULL,
            currency_symbol TEXT NOT NULL,
            show_sensitive_amounts INTEGER NOT NULL DEFAULT 1,
            theme_mode TEXT NOT NULL,
            biometric_enabled INTEGER NOT NULL DEFAULT 0,
            auto_lock_minutes INTEGER NOT NULL DEFAULT 5,
            locale_code TEXT NOT NULL DEFAULT 'system',
            payment_methods TEXT NOT NULL,
            notifications_enabled INTEGER NOT NULL DEFAULT 0,
            notification_reminder_hour INTEGER NOT NULL DEFAULT 9,
            notification_reminder_minute INTEGER NOT NULL DEFAULT 0,
            notification_permission_requested INTEGER NOT NULL DEFAULT 0
          )
        ''');

        await db.insert('app_settings', {
          'id': 1,
          'currency_code': AppConstants.defaultCurrencyCode,
          'currency_symbol': AppConstants.defaultCurrencySymbol,
          'show_sensitive_amounts':
              AppConstants.defaultShowSensitiveAmounts ? 1 : 0,
          'theme_mode': 'system',
          'biometric_enabled': 0,
          'auto_lock_minutes': AppConstants.defaultAutoLockMinutes,
          'locale_code': AppConstants.defaultLocalePreferenceCode,
          'payment_methods': jsonEncode(AppConstants.defaultPaymentMethods),
          'notifications_enabled': 0,
          'notification_reminder_hour': 9,
          'notification_reminder_minute': 0,
          'notification_permission_requested': 0,
        });

        await db.execute(
          'CREATE INDEX idx_movements_occurred_on ON movements(occurred_on)',
        );
        await db.execute(
          'CREATE INDEX idx_movements_category_id ON movements(category_id)',
        );
        await db.execute(
          'CREATE INDEX idx_movements_goal_id ON movements(goal_id)',
        );
        await db.execute(
          'CREATE INDEX idx_movements_monthly_reminder ON movements(type, monthly_reminder_enabled, occurred_on)',
        );
        await db.execute(
          'CREATE UNIQUE INDEX idx_budgets_category_month ON budgets(category_id, month)',
        );
        await db.execute('CREATE INDEX idx_budgets_month ON budgets(month)');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (kDebugMode) {
          debugPrint(
            '[startup] Upgrading SQLite database from $oldVersion to $newVersion',
          );
        }
        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE app_settings ADD COLUMN locale_code TEXT NOT NULL DEFAULT 'es'",
          );
          await db.execute(
            "ALTER TABLE app_settings ADD COLUMN payment_methods TEXT NOT NULL DEFAULT '[\"transfer\",\"debit_card\",\"credit_card\",\"cash\",\"qr\"]'",
          );
        }
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS budgets(
              id TEXT PRIMARY KEY,
              category_id TEXT NOT NULL,
              monthly_limit REAL NOT NULL CHECK (monthly_limit >= 0),
              month TEXT NOT NULL,
              FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
            )
          ''');
          await db.execute(
            'CREATE UNIQUE INDEX IF NOT EXISTS idx_budgets_category_month ON budgets(category_id, month)',
          );
          await db.execute(
            'CREATE INDEX IF NOT EXISTS idx_budgets_month ON budgets(month)',
          );
        }
        if (oldVersion < 4) {
          await db.execute(
            'ALTER TABLE app_settings ADD COLUMN show_sensitive_amounts INTEGER NOT NULL DEFAULT 1',
          );
        }
        if (oldVersion < 5) {
          await db.execute(
            'ALTER TABLE movements ADD COLUMN monthly_reminder_enabled INTEGER NOT NULL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE movements ADD COLUMN reminder_day INTEGER',
          );
          await db.execute(
            'CREATE INDEX IF NOT EXISTS idx_movements_monthly_reminder ON movements(type, monthly_reminder_enabled, occurred_on)',
          );
        }
        if (oldVersion < 6) {
          await db.execute(
            'ALTER TABLE categories ADD COLUMN reminder_enabled INTEGER NOT NULL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE categories ADD COLUMN reminder_day INTEGER',
          );
          await db.execute(
            'ALTER TABLE savings_goals ADD COLUMN reminder_enabled INTEGER NOT NULL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE savings_goals ADD COLUMN reminder_day INTEGER',
          );
        }
        if (oldVersion < 7) {
          await db.execute(
            "ALTER TABLE categories ADD COLUMN icon_key TEXT NOT NULL DEFAULT 'category'",
          );
        }
        if (oldVersion < 8) {
          await db.execute(
            "UPDATE app_settings SET locale_code = 'system' "
            "WHERE locale_code IS NULL OR TRIM(locale_code) = '' "
            "OR LOWER(locale_code) NOT IN ('system', 'es', 'en')",
          );
        }
        if (oldVersion < 9) {
          await db.execute(
            'ALTER TABLE app_settings ADD COLUMN notifications_enabled INTEGER NOT NULL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE app_settings ADD COLUMN notification_reminder_hour INTEGER NOT NULL DEFAULT 9',
          );
          await db.execute(
            'ALTER TABLE app_settings ADD COLUMN notification_reminder_minute INTEGER NOT NULL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE app_settings ADD COLUMN notification_permission_requested INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
    );
  }
}
