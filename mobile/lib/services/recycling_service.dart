import 'package:flutter/material.dart';
import '../models/recycling_centre.dart';
import '../models/waste_category.dart';

class RecyclingService {
  static const List<WasteCategory> _categories = [
    WasteCategory(
      id: 'plastics',
      name: 'Plastics',
      binColorName: 'Orange / Yellow Bin',
      binColor: Color(0xFFF59E0B),
      icon: Icons.local_drink_rounded,
      description:
          'Clean and dry recyclable plastics such as bottles, containers, and rigid packaging.',
      isRecyclable: true,
      commonItems: [
        'Water & Soda Bottles (PET #1)',
        'Milk & Detergent Jugs (HDPE #2)',
        'Rigid Food Containers (PP #5)',
        'Plastic Bottle Caps',
        'Clean Plastic Tubs & Trays',
      ],
      preparationSteps: [
        'Empty all remaining liquid or food residue completely.',
        'Rinse the container with a small amount of water.',
        'Flatten/crush plastic bottles to save bin space.',
        'Keep caps on or collect them separately based on local policy.',
      ],
      dos: [
        'Rinse out food residue before disposing',
        'Check for the recycling symbol with resin code (#1, #2, #5)',
        'Crush bottles to maximize bin space',
      ],
      donts: [
        'Do not include soft plastic bags/film in regular recycling',
        'Do not recycle greasy takeaway food containers',
        'Do not dispose of plastic toys with electronics here',
      ],
    ),
    WasteCategory(
      id: 'paper',
      name: 'Paper & Cardboard',
      binColorName: 'Blue Bin',
      binColor: Color(0xFF3B82F6),
      icon: Icons.menu_book_rounded,
      description:
          'Dry paper products, cardboard packaging, newspapers, and clean office stationery.',
      isRecyclable: true,
      commonItems: [
        'Cardboard Shipping Boxes',
        'Newspapers & Magazines',
        'Office Paper & Notebooks',
        'Cereal & Food Packaging Boxes',
        'Paper Bags & Envelopes',
      ],
      preparationSteps: [
        'Flatten cardboard boxes completely.',
        'Remove any plastic film, bubble wrap, or heavy packing tape.',
        'Ensure the paper is 100% dry and free of oil or food stains.',
      ],
      dos: [
        'Flatten all corrugated cardboard boxes',
        'Bundle loose sheets together or keep in a dry bag',
        'Remove metal spiral bindings from notebooks where possible',
      ],
      donts: [
        'Do not recycle greasy pizza boxes or wax-coated paper',
        'Do not dispose of wet or moldy paper in recycling',
        'Do not include used tissues, napkins, or sanitary paper',
      ],
    ),
    WasteCategory(
      id: 'glass',
      name: 'Glass',
      binColorName: 'Red / Brown Bin',
      binColor: Color(0xFFEF4444),
      icon: Icons.wine_bar_rounded,
      description:
          'Clear, green, and brown glass bottles and food jars. Highly recyclable indefinitely.',
      isRecyclable: true,
      commonItems: [
        'Beverage & Soft Drink Bottles',
        'Glass Food & Jam Jars',
        'Sauce & Condiment Glass Bottles',
        'Glass Cosmetic Containers (Clean)',
      ],
      preparationSteps: [
        'Rinse jars and bottles to remove leftover contents.',
        'Remove metal lids and plastic corks (recycle separately).',
        'Carefully place in bin to prevent shattering.',
      ],
      dos: [
        'Rinse glass containers with water',
        'Separate metal lids and recycle with metals',
        'Handle carefully to avoid broken shards',
      ],
      donts: [
        'Do not mix window panes, mirrors, or ceramics with bottle glass',
        'Do not recycle drinking glasses, Pyrex, or heat-resistant cookware',
        'Do not dispose of broken glass without safe wrapping',
      ],
    ),
    WasteCategory(
      id: 'metals',
      name: 'Metals & Cans',
      binColorName: 'Brown / Grey Bin',
      binColor: Color(0xFF94A3B8),
      icon: Icons.hardware_rounded,
      description:
          'Aluminum beverage cans, steel food tins, and clean metallic household containers.',
      isRecyclable: true,
      commonItems: [
        'Aluminum Soda & Beverage Cans',
        'Steel/Tin Canned Food Tins',
        'Clean Aluminum Foil & Trays',
        'Metal Bottle Caps & Jar Lids',
      ],
      preparationSteps: [
        'Empty and rinse cans thoroughly.',
        'Crush aluminum soda cans if possible.',
        'Push sharp tin can lids inside the can or dispose safely.',
      ],
      dos: [
        'Rinse food residue from soup and fish tins',
        'Crush aluminum cans to save space',
        'Recycle clean foil by balling it up',
      ],
      donts: [
        'Do not dispose of aerosol spray cans that are not completely empty',
        'Do not mix paint cans with wet paint residue',
        'Do not include sharp automotive parts or wires',
      ],
    ),
    WasteCategory(
      id: 'organic',
      name: 'Organic & Compost',
      binColorName: 'Green Bin',
      binColor: Color(0xFF10B981),
      icon: Icons.eco_rounded,
      description:
          'Biodegradable waste from kitchen and garden. Perfect for community or home composting.',
      isRecyclable: true,
      commonItems: [
        'Fruit & Vegetable Peels',
        'Leftover Cooked Food (No plastic packaging)',
        'Eggshells & Coffee Grounds',
        'Tea Bags & Loose Leaves',
        'Garden Leaves, Grass & Small Twigs',
      ],
      preparationSteps: [
        'Drain excessive liquids before putting in the compost bin.',
        'Ensure zero plastic wrappers or stickers remain on fruit peels.',
        'Store in a breathable or compost-friendly container.',
      ],
      dos: [
        'Separate organic waste daily to avoid foul odors',
        'Remove plastic stickers from fruit peels',
        'Mix green waste (food) with brown waste (dry leaves) for compost',
      ],
      donts: [
        'Do not wrap organic food waste in non-biodegradable polythene bags',
        'Do not include plastic cutlery, toothpicks, or pet waste',
        'Do not mix large tree logs or treated timber',
      ],
    ),
    WasteCategory(
      id: 'e_waste',
      name: 'E-Waste (Electronics)',
      binColorName: 'Special Collection / Drop-off',
      binColor: Color(0xFF8B5CF6),
      icon: Icons.devices_other_rounded,
      description:
          'Discarded electrical and electronic devices containing valuable and hazardous materials.',
      isRecyclable: true,
      commonItems: [
        'Mobile Phones & Tablets',
        'Chargers, USB Cables & Power Banks',
        'Laptops & Desktop Components',
        'Keyboards, Mice & Small Appliances',
        'Printers & Ink Cartridges',
      ],
      preparationSteps: [
        'Perform a factory reset and remove personal data from devices.',
        'Bundle cords and cables neatly with a rubber band.',
        'Drop off at an authorized E-Waste recycling center.',
      ],
      dos: [
        'Take items to designated e-waste drop-off kiosks or recycling centers',
        'Remove rechargeable batteries if removable',
        'Keep electronics dry and sheltered from rain',
      ],
      donts: [
        'Do not throw electronics into regular municipal garbage bins',
        'Do not dismantle or break screens and tubes yourself',
        'Do not burn electronic cables or circuits',
      ],
    ),
    WasteCategory(
      id: 'hazardous',
      name: 'Hazardous & Medical Waste',
      binColorName: 'Designated Hazardous Collection',
      binColor: Color(0xFFE11D48),
      icon: Icons.warning_amber_rounded,
      description:
          'Materials posing health, fire, or environmental hazards requiring strict disposal procedures.',
      isRecyclable: false,
      commonItems: [
        'Household Alkaline & Lithium Batteries',
        'Fluorescent Light Tubes & CFL Bulbs',
        'Paints, Thinners & Solvents',
        'Pesticides & Chemical Cleaners',
        'Expired Medicines & Syringes',
      ],
      preparationSteps: [
        'Keep in original sealed containers with labels intact.',
        'Tape the terminals of lithium batteries with electrical tape.',
        'Deliver to designated municipal hazardous waste collection points.',
      ],
      dos: [
        'Store hazardous chemicals out of reach of children',
        'Keep chemicals in their original labelled bottles',
        'Drop off at municipal hazardous drives or hospital disposal points',
      ],
      donts: [
        'Never pour chemicals, oils, or solvents down household drains',
        'Never mix different chemical products together',
        'Do not throw loose batteries or syringes into standard waste bins',
      ],
    ),
  ];

  static const List<RecyclingCentre> _centres = [
    RecyclingCentre(
      id: 'rc_01',
      name: 'GreenCycle Central Hub',
      address: 'No. 45 Baseline Road, Colombo 09',
      city: 'Colombo',
      distanceKm: 1.2,
      contactNumber: '+94 11 268 4590',
      email: 'contact@greencyclehub.lk',
      operatingHours: 'Mon - Sat: 8:00 AM - 5:30 PM',
      isOpen: true,
      acceptedMaterials: [
        'Plastic Bottles (PET #1)',
        'Rigid Plastics (HDPE #2, PP #5)',
        'Cardboard & Office Paper',
        'Aluminum & Tin Cans',
        'Glass Bottles & Jars',
      ],
      unsupportedMaterials: [
        'Hazardous Chemicals',
        'Medical & Clinical Waste',
        'Single-use Polythene Bags',
      ],
      notes:
          'Offers drop-off points for bulk recyclables. Weight-based incentives provided.',
    ),
    RecyclingCentre(
      id: 'rc_02',
      name: 'EcoTech E-Waste Recovery Centre',
      address: '120 High Level Road, Maharagama',
      city: 'Maharagama',
      distanceKm: 3.8,
      contactNumber: '+94 11 285 9940',
      email: 'info@ecotech-recovery.lk',
      operatingHours: 'Tue - Sun: 9:00 AM - 6:00 PM',
      isOpen: true,
      acceptedMaterials: [
        'Mobile Phones & Tablets',
        'Computers, Monitors & Laptops',
        'Batteries & Power Banks',
        'Cables, Adapters & Small Appliances',
        'Fluorescent Bulbs',
      ],
      unsupportedMaterials: [
        'Organic Waste',
        'Glass Bottles',
        'General Cardboard',
      ],
      notes:
          'Specialized authorized e-waste facility. Free certified data wiping on computer drives.',
    ),
    RecyclingCentre(
      id: 'rc_03',
      name: 'BioRecycle Organic Composting Plant',
      address: '88 Temple Road, Nawala, Rajagiriya',
      city: 'Rajagiriya',
      distanceKm: 4.5,
      contactNumber: '+94 11 442 1102',
      email: 'support@biorecycle.org',
      operatingHours: 'Mon - Fri: 7:30 AM - 4:00 PM',
      isOpen: true,
      acceptedMaterials: [
        'Fruit & Vegetable Scraps',
        'Garden Leaves & Grass Clippings',
        'Coffee Grounds & Tea Leaves',
        'Eggshells & Biodegradable Packaging',
      ],
      unsupportedMaterials: [
        'Plastic Packaging',
        'Metal Cans',
        'Animal Bones & Meat Waste',
        'Treated Timber',
      ],
      notes:
          'Free organic compost bag exchange for every 10kg of kitchen waste delivered.',
    ),
    RecyclingCentre(
      id: 'rc_04',
      name: 'MetalWorks Recycling & Scrap Yard',
      address: '15 Industrial Zone, Kelaniya',
      city: 'Kelaniya',
      distanceKm: 6.2,
      contactNumber: '+94 11 291 0334',
      email: 'metals@scrapworks.lk',
      operatingHours: 'Mon - Sat: 8:30 AM - 5:00 PM',
      isOpen: false,
      acceptedMaterials: [
        'Aluminum Beverage Cans',
        'Steel Food Tins',
        'Copper Wires & Brass Fittings',
        'Old Metal Cookware & Roof Sheets',
      ],
      unsupportedMaterials: [
        'Plastic Products',
        'Paper & Cardboard',
        'Organic Waste',
        'Pressurized Gas Cylinders',
      ],
      notes:
          'Instant cash payouts for scrap metals based on daily market weight rates.',
    ),
    RecyclingCentre(
      id: 'rc_05',
      name: 'Urban Clean Glass & Paper Depot',
      address: '202 Galle Road, Dehiwala',
      city: 'Dehiwala',
      distanceKm: 5.1,
      contactNumber: '+94 11 273 8819',
      email: 'depot@urbanclean.lk',
      operatingHours: 'Mon - Sat: 8:00 AM - 6:00 PM',
      isOpen: true,
      acceptedMaterials: [
        'Clear & Colored Glass Bottles',
        'Glass Food Jars',
        'Cardboard Boxes & Newspapers',
        'Office Shredded Paper',
      ],
      unsupportedMaterials: [
        'Broken Window Panes',
        'Ceramics & Porcelain',
        'Food Contaminated Cardboard',
      ],
      notes:
          'Drive-through drop-off lane available for quick unloading of cartons and glass crates.',
    ),
  ];

  List<WasteCategory> getWasteCategories() {
    return _categories;
  }

  WasteCategory? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  List<WasteCategory> searchCategoriesAndItems(String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return _categories;

    return _categories.where((category) {
      final matchesName = category.name.toLowerCase().contains(cleanQuery);
      final matchesDesc = category.description.toLowerCase().contains(cleanQuery);
      final matchesItem = category.commonItems.any(
        (item) => item.toLowerCase().contains(cleanQuery),
      );
      final matchesDos = category.dos.any(
        (d) => d.toLowerCase().contains(cleanQuery),
      );
      return matchesName || matchesDesc || matchesItem || matchesDos;
    }).toList();
  }

  List<RecyclingCentre> getRecyclingCentres({
    String? query,
    String? materialFilter,
  }) {
    List<RecyclingCentre> list = List.from(_centres);

    if (query != null && query.trim().isNotEmpty) {
      final cleanQuery = query.trim().toLowerCase();
      list = list.where((centre) {
        final matchesName = centre.name.toLowerCase().contains(cleanQuery);
        final matchesCity = centre.city.toLowerCase().contains(cleanQuery);
        final matchesAddr = centre.address.toLowerCase().contains(cleanQuery);
        final matchesMat = centre.acceptedMaterials.any(
          (m) => m.toLowerCase().contains(cleanQuery),
        );
        return matchesName || matchesCity || matchesAddr || matchesMat;
      }).toList();
    }

    if (materialFilter != null && materialFilter.isNotEmpty && materialFilter != 'All') {
      final filterLower = materialFilter.toLowerCase();
      list = list.where((centre) {
        return centre.acceptedMaterials.any(
          (mat) => mat.toLowerCase().contains(filterLower),
        );
      }).toList();
    }

    return list;
  }

  RecyclingCentre? getCentreById(String id) {
    try {
      return _centres.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}

