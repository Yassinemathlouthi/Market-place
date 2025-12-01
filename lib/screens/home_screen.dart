import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/service_item.dart';
import '../services/data_service.dart';
import '../services/appwrite_service.dart';
import 'details_screen.dart';
import 'login_screen.dart';
import 'my_bookings_screen.dart';

class HomeScreen extends StatefulWidget {
  final DataService dataService;

  const HomeScreen({super.key, required this.dataService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ServiceItem> _services = [];
  List<ServiceItem> _filteredServices = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Design',
    'Home',
    'Tech',
    'Education',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() => _isLoading = true);
    try {
      final services = await widget.dataService.getServices();
      setState(() {
        _services = services;
        _filteredServices = services;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error
    }
  }

  void _filterServices(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredServices = _services.where((item) {
        final matchesSearch =
            item.title.toLowerCase().contains(lowerQuery) ||
            item.description.toLowerCase().contains(lowerQuery);
        final matchesCategory =
            _selectedCategory == 'All' || item.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterServices(_searchController.text);
  }

  Future<void> _seedDatabase() async {
    // Mock data to seed
    final List<ServiceItem> mockItems = [
      ServiceItem(
        id: '',
        title: 'Logo Design',
        description: 'Professional logo design for your brand.',
        price: 50.0,
        providerName: 'Alice Creative',
        contactInfo: 'alice@example.com',
        category: 'Design',
        imageUrl:
            'https://plus.unsplash.com/premium_photo-1661331911412-330f3e995733?w=500',
      ),
      ServiceItem(
        id: '',
        title: 'House Cleaning',
        description: 'Full house cleaning service. 3 hours max.',
        price: 80.0,
        providerName: 'CleanFast',
        contactInfo: '+1234567890',
        category: 'Home',
        imageUrl:
            'https://plus.unsplash.com/premium_photo-1661666507862-275842989117?w=500',
      ),
      ServiceItem(
        id: '',
        title: 'Flutter Dev',
        description: 'Fix bugs or build small features.',
        price: 40.0,
        providerName: 'DevExpert',
        contactInfo: 'dev@code.com',
        category: 'Tech',
        imageUrl:
            'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=500&auto=format&fit=crop&q=60',
      ),
      ServiceItem(
        id: '',
        title: 'Piano Lessons',
        description: '1 hour piano lesson for beginners.',
        price: 30.0,
        providerName: 'MusicMaster',
        contactInfo: 'music@piano.com',
        category: 'Education',
        imageUrl:
            'https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=500&auto=format&fit=crop&q=60',
      ),
    ];

    int successCount = 0;
    for (var item in mockItems) {
      try {
        await widget.dataService.createService(item);
        successCount++;
      } catch (e) {
        debugPrint('Failed to seed item: ${item.title}');
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seeded $successCount items to database')),
      );
    }
    _loadServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Matala Market',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            tooltip: 'Seed Database',
            onPressed: _seedDatabase,
          ),
          if (widget.dataService is AppwriteService) ...[
            IconButton(
              icon: const Icon(Icons.calendar_today),
              tooltip: 'My Bookings',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyBookingsScreen(dataService: widget.dataService),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () async {
                await (widget.dataService as AppwriteService).logout();
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(
                        appwriteService: widget.dataService as AppwriteService,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterServices,
              decoration: InputDecoration(
                hintText: 'Search services...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 20,
                ),
              ),
            ),
          ),

          // Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => _onCategorySelected(category),
                    backgroundColor: Colors.white,
                    selectedColor: Colors.blue[100],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.blue[800] : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          // List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredServices.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No services found',
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: _filteredServices.length,
                    itemBuilder: (context, index) {
                      final item = _filteredServices[index];
                      return Card(
                        elevation: 4,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                  serviceItem: item,
                                  dataService: widget.dataService,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image
                              Expanded(
                                child: Hero(
                                  tag: 'service-img-${item.id}',
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      item.imageUrl ??
                                          'https://placehold.co/400x300?text=${item.category}',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[300],
                                              child: const Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.category.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${item.price.toStringAsFixed(0)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
