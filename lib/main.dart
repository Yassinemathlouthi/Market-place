import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'services/data_service.dart';
import 'services/appwrite_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ---------------------------------------------------------
  // CONFIGURATION: Choose your data source here.
  // ---------------------------------------------------------

  // OPTION 1: Use Mock Data (Works immediately without setup)
  //final DataService dataService = MockDataService();

  // OPTION 2: Use Appwrite (Requires Database & Collection setup)
  final DataService dataService = AppwriteService();

  runApp(MyApp(dataService: dataService));
}

class MyApp extends StatelessWidget {
  final DataService dataService;

  const MyApp({super.key, required this.dataService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: HomeScreen(dataService: dataService),
    );
  }
}
