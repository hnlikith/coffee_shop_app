import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:coffee_shop_app/core/constants/supabase_constants.dart';

/// Low-level Supabase service — handles direct table operations
class SupabaseService {
  /// Get the Supabase client instance
  SupabaseClient get client => Supabase.instance.client;

  /// Initialize Supabase — call this in main.dart before runApp
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConstants.supabaseUrl,
      publishableKey: SupabaseConstants.supabaseAnonKey,
    );
  }

  /// Fetch all rows from a table
  Future<List<Map<String, dynamic>>> fetchAll(String table) async {
    try {
      final response = await client.from(table).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch from $table: $e');
    }
  }

  /// Fetch rows with a filter
  Future<List<Map<String, dynamic>>> fetchWhere(
    String table,
    String column,
    dynamic value,
  ) async {
    try {
      final response = await client.from(table).select().eq(column, value);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch from $table where $column=$value: $e');
    }
  }

  /// Fetch a single row by ID
  Future<Map<String, dynamic>> fetchById(String table, String id) async {
    try {
      final response = await client.from(table).select().eq('id', id).single();
      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch from $table with id=$id: $e');
    }
  }

  /// Insert a row
  Future<Map<String, dynamic>> insert(
    String table,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await client.from(table).insert(data).select().single();
      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw Exception('Failed to insert into $table: $e');
    }
  }

  /// Update a row by ID
  Future<void> update(
    String table,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      await client.from(table).update(data).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update $table with id=$id: $e');
    }
  }

  /// Delete a row by ID
  Future<void> delete(String table, String id) async {
    try {
      await client.from(table).delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete from $table with id=$id: $e');
    }
  }
}
