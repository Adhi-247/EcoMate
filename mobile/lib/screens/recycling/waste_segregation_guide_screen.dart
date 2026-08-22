import 'package:flutter/material.dart';
import '../../models/waste_category.dart';
import '../../services/recycling_service.dart';
import 'category_detail_screen.dart';

class WasteSegregationGuideScreen extends StatefulWidget {
  const WasteSegregationGuideScreen({super.key});

  @override
  State<WasteSegregationGuideScreen> createState() =>
      _WasteSegregationGuideScreenState();
}

class _WasteSegregationGuideScreenState
    extends State<WasteSegregationGuideScreen> {
  final RecyclingService _recyclingService = RecyclingService();
  final TextEditingController _searchController = TextEditingController();

  List<WasteCategory> _displayedCategories = [];
  String _selectedFilter = 'All'; // 'All', 'Recyclable', 'Non-Recyclable'

  @override
  void initState() {
    super.initState();
    _displayedCategories = _recyclingService.getWasteCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final results = _recyclingService.searchCategoriesAndItems(query);
    setState(() {
      if (_selectedFilter == 'Recyclable') {
        _displayedCategories = results.where((c) => c.isRecyclable).toList();
      } else if (_selectedFilter == 'Non-Recyclable') {
        _displayedCategories = results.where((c) => !c.isRecyclable).toList();
      } else {
        _displayedCategories = results;
      }
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _onSearchChanged(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071D20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2528),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF68E1BF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Waste Segregation Guide',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                // Top Search & Filter Bar
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  color: const Color(0xFF0B2528),
                  child: Column(
                    children: [
                      // Search Input
                      TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search waste (e.g. bottle, battery, paper)...',
                          hintStyle: const TextStyle(color: Color(0xFF6B8A86)),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Color(0xFF68E1BF),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Color(0xFF9AB5B1),
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: const Color(0xFF102D2F),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFF1A4648)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFF1A4648)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFF68E1BF),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Filter chips
                      Row(
                        children: [
                          _buildFilterChip('All'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Recyclable'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Non-Recyclable'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Category List
                Expanded(
                  child: _displayedCategories.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 56,
                                color: const Color(0xFF68E1BF).withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'No matching waste categories found',
                                style: TextStyle(
                                  color: Color(0xFF9AB5B1),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _displayedCategories.length,
                          itemBuilder: (context, index) {
                            final category = _displayedCategories[index];
                            return _buildCategoryCard(category);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () => _onFilterChanged(label),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF68E1BF)
              : const Color(0xFF102D2F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF68E1BF) : const Color(0xFF1E4C4E),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF071D20) : const Color(0xFFB4CCC9),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(WasteCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B2528),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF163D3F)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryDetailScreen(category: category),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: category.binColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: category.binColor.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Icon(
                        category.icon,
                        color: category.binColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: category.binColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category.binColorName,
                                style: TextStyle(
                                  color: category.binColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFF68E1BF),
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  category.description,
                  style: const TextStyle(
                    color: Color(0xFF9AB5B1),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                // Chips for examples
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: category.commonItems.take(3).map((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF102D2F),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF1E4C4E),
                        ),
                      ),
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Color(0xFFC7DFDC),
                          fontSize: 11,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

