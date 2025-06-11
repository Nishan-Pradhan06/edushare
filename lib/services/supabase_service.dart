// lib/services/supabase_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late final SupabaseClient _client;
  bool _isInitialized = false;
  final Future<void> _initFuture;

  // Singleton pattern
  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal() : _initFuture = _initializeSupabase();

  // Internal initialization logic
  static Future<void> _initializeSupabase() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    _instance._client = Supabase.instance.client;
    _instance._isInitialized = true;
  }

  // Client getter (async)
  Future<SupabaseClient> get client async {
    if (!_isInitialized) {
      await _initFuture;
    }
    return _client;
  }

  // Auth helper methods
  User? get currentUser => _client.auth.currentUser;
  
  bool get isAuthenticated => currentUser != null;
  
  bool get isAdmin {
    if (currentUser?.userMetadata?['role'] == 'admin') return true;
    // Mock admin credentials for demo
    return currentUser?.email == 'admin@edushare.com';
  }

  // Sign in with email and password
  Future<AuthResponse> signInWithPassword(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      throw Exception('Sign-in failed: $error');
    }
  }

  // Sign up with email and password
  Future<AuthResponse> signUp(String email, String password) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      throw Exception('Sign-up failed: $error');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw Exception('Sign-out failed: $error');
    }
  }

  // Admin operations
  Future<List<dynamic>> getUsers() async {
    try {
      final response = await _client.from('profiles').select();
      return response;
    } catch (error) {
      throw Exception('Failed to fetch users: $error');
    }
  }

  Future<List<dynamic>> getPosts() async {
    try {
      final response = await _client.from('posts').select('*, profiles(*)');
      return response;
    } catch (error) {
      throw Exception('Failed to fetch posts: $error');
    }
  }

  Future<void> updateUserRole(String userId, String role) async {
    try {
      await _client.from('profiles').update({'role': role}).eq('id', userId);
    } catch (error) {
      throw Exception('Failed to update user role: $error');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _client.from('posts').delete().eq('id', postId);
    } catch (error) {
      throw Exception('Failed to delete post: $error');
    }
  }
}