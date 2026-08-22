import 'package:flutter/material.dart';
import '../../models/recycling_centre.dart';
import '../../services/recycling_service.dart';
import 'centre_detail_screen.dart';

class RecyclingCentresScreen extends StatefulWidget {
  const RecyclingCentresScreen({super.key});

  @override
  State<RecyclingCentresScreen> createState() => _RecyclingCentresScreenState();
}

class _RecyclingCentresScreenState extends State<RecyclingCentresScreen> {
  final RecyclingService _recyclingService = RecyclingService();
  final TextEditingController _searchController = TextEditingController();

  List<RecyclingCentre> _displayedCentres = [];
  String _selectedMaterial = 'All';

  final List<String> _materialOptions = [
    'All',
    'Plastic',
    'Paper',
    'Glass',
    'Metal',
    'E-Waste',
    'Organic',
  ];

  @override
  void initState() {
    super.initState();
    _fetchCentres();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchCentres() {
    setState(() {
      _displayedCentres = _recyclingService.getRecyclingCentres(
        query: _searchController.text,
        materialFilter: _selectedMaterial,
      );
    });
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
          'Nearby Recycling Centres',
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
                // Top Search & Filter Container
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  color: const Color(0xFF0B2528),
                  child: Column(
                    children: [
                      // Location/Centre Search Field
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => _fetchCentres(),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search by centre name, city or location...',
                          hintStyle: const TextStyle(color: Color(0xFF6B8A86)),
                          prefixIcon: const Icon(
                            Icons.location_searching_rounded,
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
                                    _fetchCentres();
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

                      // Horizontal Material Filter Chips
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _materialOptions.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final option = _materialOptions[index];
                            final isSelected = _selectedMaterial == option;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedMaterial = option;
                                });
                                _fetchCentres();
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF68E1BF)
                                      : const Color(0xFF102D2F),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF68E1BF)
                                        : const Color(0xFF1E4C4E),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: isSelected
                                          ? const Color(0xFF071D20)
                                          : const Color(0xFFB4CCC9),
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Centres Count Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Found ${_displayedCentres.length} active centre${_displayedCentres.length == 1 ? '' : 's'}',
                        style: const TextStyle(
                          color: Color(0xFF9AB5B1),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.near_me_rounded, color: Color(0xFF68E1BF), size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Sorted by distance',
                            style: TextStyle(
                              color: Color(0xFF68E1BF),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // List of Centres
                Expanded(
                  child: _displayedCentres.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off_rounded,
                                size: 56,
                                color: const Color(0xFF68E1BF).withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'No recycling centres match your criteria',
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
                          itemCount: _displayedCentres.length,
                          itemBuilder: (context, index) {
                            final centre = _displayedCentres[index];
                            return _buildCentreCard(centre);
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

  Widget _buildCentreCard(RecyclingCentre centre) {
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
                builder: (_) => CentreDetailScreen(centre: centre),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Name, distance badge, status badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            centre.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.place_rounded,
                                color: Color(0xFF68E1BF),
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  centre.address,
                                  style: const TextStyle(
                                    color: Color(0xFF9AB5B1),
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF102D2F),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFF1A4648),
                            ),
                          ),
                          child: Text(
                            '${centre.distanceKm} km',
                            style: const TextStyle(
                              color: Color(0xFF68E1BF),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: centre.isOpen
                                ? const Color(0xFF0B2E26)
                                : const Color(0xFF33151E),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            centre.isOpen ? 'OPEN' : 'CLOSED',
                            style: TextStyle(
                              color: centre.isOpen
                                  ? const Color(0xFF34D399)
                                  : const Color(0xFFF87171),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(color: Color(0xFF133639)),
                const SizedBox(height: 8),

                // Accepted items preview tags
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Accepts: ',
                      style: TextStyle(
                        color: Color(0xFF6B8A86),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        centre.acceptedMaterials.take(3).join(', ') +
                            (centre.acceptedMaterials.length > 3
                                ? ' +${centre.acceptedMaterials.length - 3} more'
                                : ''),
                        style: const TextStyle(
                          color: Color(0xFFC7DFDC),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFF68E1BF),
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

