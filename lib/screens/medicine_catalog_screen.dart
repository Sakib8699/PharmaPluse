import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../widgets/medicine_item_card.dart';

class MedicineCatalogScreen extends StatefulWidget {
  const MedicineCatalogScreen({super.key});

  @override
  State<MedicineCatalogScreen> createState() => _MedicineCatalogScreenState();
}

class _MedicineCatalogScreenState extends State<MedicineCatalogScreen> {
  static const _greenColor = Color(0xFF0F6E56);
  static const _greenLight = Color(0xFFE1F5EE);

  List<Medicine> medicines = [];
  List<Medicine> filteredMedicines = [];
  String selectedCategory = 'All';
  String searchQuery = '';

  final List<String> categories = [
    'All',
    'Antibiotics',
    'Pain Relief',
    'Cold & Cough',
    'Vitamins',
    'Digestive',
  ];

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  void _loadMedicines() {
    // Mock data - In production, this would be fetched from Firebase
    medicines = [
      Medicine(
        id: '1',
        name: 'Paracetamol 500mg',
        category: 'Pain Relief',
        price: 15.0,
        imageUrl: '',
        description: 'Effective pain reliever and fever reducer',
        rating: 4.5,
        reviewCount: 100,
        stock: 50,
        dosage: '500mg Tablet',
      ),
      Medicine(
        id: '2',
        name: 'Amoxicillin 250mg',
        category: 'Antibiotics',
        price: 45.0,
        imageUrl: '',
        description: 'Broad-spectrum antibiotic',
        rating: 4.8,
        reviewCount: 256,
        stock: 30,
        dosage: '250mg Capsule',
      ),
      Medicine(
        id: '3',
        name: 'Cough Syrup',
        category: 'Cold & Cough',
        price: 60.0,
        imageUrl: '',
        description: 'Soothing cough relief for all ages',
        rating: 4.3,
        reviewCount: 85,
        stock: 20,
        dosage: '100ml Syrup',
      ),
      Medicine(
        id: '4',
        name: 'Vitamin C 1000mg',
        category: 'Vitamins',
        price: 120.0,
        imageUrl: '',
        description: 'Boosts immunity and energy',
        rating: 4.7,
        reviewCount: 342,
        stock: 100,
        dosage: '1000mg Tablet',
      ),
      Medicine(
        id: '5',
        name: 'Antacid Tablet',
        category: 'Digestive',
        price: 25.0,
        imageUrl: '',
        description: 'Relief from acidity and heartburn',
        rating: 4.4,
        reviewCount: 156,
        stock: 40,
        dosage: '500mg Tablet',
      ),
      Medicine(
        id: '6',
        name: 'Ciprofloxacin 500mg',
        category: 'Antibiotics',
        price: 75.0,
        imageUrl: '',
        description: 'Powerful antibiotic for infections',
        rating: 4.6,
        reviewCount: 201,
        stock: 25,
        dosage: '500mg Tablet',
      ),
      Medicine(
        id: '7',
        name: 'Multivitamin',
        category: 'Vitamins',
        price: 150.0,
        imageUrl: '',
        description: 'Complete daily vitamin supplement',
        rating: 4.5,
        reviewCount: 289,
        stock: 60,
        dosage: 'Tablet',
      ),
      Medicine(
        id: '8',
        name: 'Ibuprofen 400mg',
        category: 'Pain Relief',
        price: 35.0,
        imageUrl: '',
        description: 'Anti-inflammatory pain reliever',
        rating: 4.7,
        reviewCount: 312,
        stock: 0,
        dosage: '400mg Tablet',
      ),
    ];
    _applyFilters();
  }

  void _applyFilters() {
    filteredMedicines = medicines.where((medicine) {
      final matchesCategory =
          selectedCategory == 'All' || medicine.category == selectedCategory;
      final matchesSearch =
          medicine.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          medicine.description.toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
      return matchesCategory && matchesSearch;
    }).toList();
    setState(() {});
  }

  void _onCategorySelected(String category) {
    selectedCategory = category;
    _applyFilters();
  }

  void _onSearchChanged(String query) {
    searchQuery = query;
    _applyFilters();
  }

  void _addToCart(Medicine medicine) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine.name} added to cart'),
        backgroundColor: _greenColor,
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _greenColor,
        elevation: 0,
        title: const Text(
          'Medicine Catalog',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Container(
              color: _greenColor,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: TextField(
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search medicines...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
            // Category Filter
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category == selectedCategory;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () => _onCategorySelected(category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? _greenColor : _greenLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? _greenColor
                                  : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : _greenColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Results Count
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredMedicines.length} medicines found',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Optional: Add sorting button
                  GestureDetector(
                    onTap: () {
                      // Implement sorting logic
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.sort_rounded,
                          size: 18,
                          color: _greenColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Sort',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Medicine Grid
            Padding(
              padding: const EdgeInsets.all(12),
              child: filteredMedicines.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.medication_rounded,
                              size: 64,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No medicines found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: filteredMedicines.length,
                      itemBuilder: (context, index) {
                        final medicine = filteredMedicines[index];
                        return MedicineItemCard(
                          medicine: medicine,
                          onAddToCart: () => _addToCart(medicine),
                          onTap: () {
                            // Navigate to medicine detail page
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Details for ${medicine.name} (WIP)',
                                ),
                                backgroundColor: _greenColor,
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
