import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details); 
    Clipboard.setData(ClipboardData(text: details.toString()));
  };

  await Supabase.initialize(
    url: 'https://zpayorelnjoucbryorka.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpwYXlvcmVsbmpvdWNicnlvcmthIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQzOTMxNjAsImV4cCI6MjA5OTk2OTE2MH0.1v_o7_ZJVoH6lJWX_1ZQDxUkc8OpRXZz8QZVzcwDlkA',
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
