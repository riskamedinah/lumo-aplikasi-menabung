import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://danlcemiapskvymvohah.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRhbmxjZW1pYXBza3Z5bXZvaGFoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMwMDEwOTUsImV4cCI6MjA3ODU3NzA5NX0.JuXJq_Qcth2A8SlttjQxRHsK39uOXhwkXs0hbdxxmws',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lumo',
      theme: base.copyWith(
        textTheme: GoogleFonts.manropeTextTheme(base.textTheme),
        primaryTextTheme: GoogleFonts.manropeTextTheme(base.primaryTextTheme),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
