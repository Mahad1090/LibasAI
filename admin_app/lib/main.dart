import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/admin_shell.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = true;
  try {
    await GoogleFonts.pendingFonts([
      GoogleFonts.manrope(),
      GoogleFonts.playfairDisplay(),
    ]).timeout(const Duration(seconds: 3));
  } catch (_) {/* offline / slow - fall back to runtime load */}
  runApp(const LibasAIAdminApp());
}

class LibasAIAdminApp extends StatelessWidget {
  const LibasAIAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LibasAI Operations Admin',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const AdminShell(),
    );
  }
}
