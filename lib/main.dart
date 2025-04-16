import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin/admin_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://onrolwqjeygbcuqyxoah.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ucm9sd3FqZXlnYmN1cXl4b2FoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ4MDE1MjksImV4cCI6MjA2MDM3NzUyOX0._Nw4VYwzXIMIvvVJHIDXf1sqQ0j-NTcpIK3pnoYH77M',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Admin Feed App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[100],
        ),
        home:   AdminView()
    );
  }
}
