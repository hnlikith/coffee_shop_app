/// Supabase configuration constants
/// Replace these with your actual Supabase project credentials
class SupabaseConstants {
  SupabaseConstants._();

  /// Your Supabase project URL
  static const String supabaseUrl = 'https://cpgqtlgigbnzxdvpwlxe.supabase.co';

  /// Your Supabase anonymous/public key
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNwZ3F0bGdpZ2JuenhkdnB3bHhlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM1ODE2MjksImV4cCI6MjA5OTE1NzYyOX0.oo9eRQ_lWDCYxungkEhof9kmffZ93TwrPuBxCjpIH7w';

  // Table names
  static const String categoriesTable = 'categories';
  static const String productsTable = 'products';
  static const String cartTable = 'cart';

  // Storage
  static const String imagesBucket = 'coffee-images';
}
