import 'package:supabase/supabase.dart';

import 'api_secrets.dart';
import 'routes_handlers/source.dart';

class Database {
  static final client = SupabaseClient(supabaseEndpoint, supabaseSecret);

  static Future<PostgrestResponse> match(Map<String, dynamic> query,
      {String table = userTable}) async {
    return await client.from(table).select().match(query).execute();
  }

  static Future<PostgrestResponse> add(String table, var item) async =>
      await client.from(table).insert(item).execute();

  static Future<PostgrestResponse> update(String table, Map values) async {
    final email = values['email'];
    final _values = Map.from(values);
    //just remaining with updated values
    _values.remove('email');
    return await client
        .from(table)
        .update(_values)
        .eq('email', email)
        .execute();
  }

  static Future<PostgrestResponse> delete(String table, String email) async =>
      await client.from(table).delete().eq('email', email).execute();
}
