import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
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

class MyApp extends StatefulWidget {
  final DataService dataService;

  const MyApp({super.key, required this.dataService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    if (widget.dataService is AppwriteService) {
      final appwriteService = widget.dataService as AppwriteService;
      final user = await appwriteService.getCurrentUser();
      setState(() {
        _isLoggedIn = user != null;
        _isLoading = false;
      });
    } else {
      // Mock service, just let them in
      setState(() {
        _isLoggedIn = true;
        _isLoading = false;
      });
    }
  }

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
      home: _isLoading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : _isLoggedIn
          ? HomeScreen(dataService: widget.dataService)
          : LoginScreen(appwriteService: widget.dataService as AppwriteService),
    );
  }
}
