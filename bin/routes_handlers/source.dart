import 'package:supabase/supabase.dart';

import '../keys.dart';

export 'package:shelf/shelf.dart';

final client = SupabaseClient(supabaseEndpoint, supabaseSecret);
