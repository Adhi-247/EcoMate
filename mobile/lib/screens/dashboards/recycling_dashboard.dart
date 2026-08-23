import 'package:flutter/material.dart';
import '../../models/recycling_centre.dart';
import '../../services/auth_service.dart';
import '../../services/recycling_service.dart';
import '../login_screen.dart';

class RecyclingDashboard extends StatefulWidget {
  const RecyclingDashboard({super.key});

  @override
  State<RecyclingDashboard> createState() => _RecyclingDashboardState();
}

class _RecyclingDashboardState extends State<RecyclingDashboard> {
  final AuthService _authService = AuthService();
  final RecyclingService _recyclingService = RecyclingService();

  String _officerName = 'Officer';
  String _officerEmail = 'stharanga.rog@gmail.com';
  RecyclingCentre? _myCentre;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOfficerData();
  }

  Future<void> _loadOfficerData() async {
    setState(() => _isLoading = true);

    final storedEmail = await _authService.getEmail();
    final storedName = await _authService.getName();

    final activeEmail = (storedEmail != null && storedEmail.isNotEmpty)
        ? storedEmail
        : 'stharanga.rog@gmail.com';

    final activeName = (storedName != null && storedName.isNotEmpty)
        ? storedName
        : 'Officer';

    final centre = await _recyclingService.getCentreForOfficer(activeEmail);

    if (mounted) {
      setState(() {
        _officerEmail = activeEmail;
        _officerName = activeName;
        _myCentre = centre;
        _isLoading = false;
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    await _authService.logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _toggleStatus(bool isOpen) async {
    if (_myCentre == null) return;
    await _recyclingService.toggleCentreStatus(_myCentre!.id, isOpen);
    setState(() {
      _myCentre = _myCentre!.copyWith(isOpen: isOpen);
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isOpen
              ? 'Centre status updated to OPEN'
              : 'Centre status updated to CLOSED',
        ),
        backgroundColor: isOpen ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openEditCentreModal() {
    if (_myCentre == null) return;

    final nameController = TextEditingController(text: _myCentre!.name);
    final addressController = TextEditingController(text: _myCentre!.address);
    final cityController = TextEditingController(text: _myCentre!.city);
    final phoneController = TextEditingController(text: _myCentre!.contactNumber);
    final emailController = TextEditingController(text: _myCentre!.email);
    final hoursController = TextEditingController(text: _myCentre!.operatingHours);
    final notesController = TextEditingController(text: _myCentre!.notes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Centre Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F5520),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(nameController, 'Centre Name', Icons.storefront),
                const SizedBox(height: 12),
                _buildTextField(addressController, 'Address', Icons.location_on),
                const SizedBox(height: 12),
                _buildTextField(cityController, 'City / District', Icons.location_city),
                const SizedBox(height: 12),
                _buildTextField(phoneController, 'Contact Phone', Icons.phone),
                const SizedBox(height: 12),
                _buildTextField(emailController, 'Official Email', Icons.email),
                const SizedBox(height: 12),
                _buildTextField(hoursController, 'Operating Hours', Icons.access_time),
                const SizedBox(height: 12),
                _buildTextField(notesController, 'Policies & Notes', Icons.notes, maxLines: 2),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final updated = _myCentre!.copyWith(
                      name: nameController.text.trim(),
                      address: addressController.text.trim(),
                      city: cityController.text.trim(),
                      contactNumber: phoneController.text.trim(),
                      email: emailController.text.trim(),
                      operatingHours: hoursController.text.trim(),
                      notes: notesController.text.trim(),
                    );
                    await _recyclingService.saveOrUpdateCentre(updated);
                    setState(() => _myCentre = updated);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Centre details updated successfully'),
                        backgroundColor: Color(0xFF2E7D32),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F5520),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openManageMaterialsModal() {
    if (_myCentre == null) return;

    final masterList = _recyclingService.getMasterMaterialList();
    final selectedSet = _myCentre!.acceptedMaterials
        .where((m) => masterList.contains(m))
        .toSet();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(Icons.inventory_2_outlined, color: Color(0xFF1F5520)),
                  SizedBox(width: 10),
                  Text(
                    'Manage Accepted Items',
                    style: TextStyle(
                      color: Color(0xFF1F5520),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: masterList.length,
                  itemBuilder: (context, index) {
                    final item = masterList[index];
                    final isChecked = selectedSet.contains(item);
                    return CheckboxListTile(
                      activeColor: const Color(0xFF2E7D32),
                      title: Text(
                        item,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setModalState(() {
                          if (value == true) {
                            selectedSet.add(item);
                          } else {
                            selectedSet.remove(item);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final updatedAccepted = selectedSet.toList();
                    final updatedUnsupported = masterList
                        .where((item) => !selectedSet.contains(item))
                        .toList();

                    final updatedCentre = _myCentre!.copyWith(
                      acceptedMaterials: updatedAccepted,
                      unsupportedMaterials: updatedUnsupported,
                    );

                    await _recyclingService.saveOrUpdateCentre(updatedCentre);
                    setState(() {
                      _myCentre = updatedCentre;
                    });
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Accepted and unsupported materials updated'),
                        backgroundColor: Color(0xFF2E7D32),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F5520),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Save Materials'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openRegisterCentreModal() {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController(text: 'Colombo');
    final phoneController = TextEditingController();
    final hoursController = TextEditingController(text: 'Mon - Sat: 8:00 AM - 5:30 PM');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Register Your Recycling Centre',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F5520),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(nameController, 'Centre Name', Icons.storefront),
                const SizedBox(height: 12),
                _buildTextField(addressController, 'Address', Icons.location_on),
                const SizedBox(height: 12),
                _buildTextField(cityController, 'City / Region', Icons.location_city),
                const SizedBox(height: 12),
                _buildTextField(phoneController, 'Contact Phone', Icons.phone),
                const SizedBox(height: 12),
                _buildTextField(hoursController, 'Operating Hours', Icons.access_time),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty || addressController.text.isEmpty) {
                      return;
                    }
                    final newCentre = RecyclingCentre(
                      id: 'rc_${DateTime.now().millisecondsSinceEpoch}',
                      officerEmail: _officerEmail,
                      name: nameController.text.trim(),
                      address: addressController.text.trim(),
                      city: cityController.text.trim(),
                      distanceKm: 1.0,
                      contactNumber: phoneController.text.trim(),
                      email: _officerEmail,
                      operatingHours: hoursController.text.trim(),
                      isOpen: true,
                      acceptedMaterials: [
                        'Plastic Bottles (PET #1)',
                        'Cardboard & Office Paper',
                        'Aluminum & Tin Cans',
                      ],
                      unsupportedMaterials: [
                        'Hazardous Chemicals',
                        'Medical Waste',
                      ],
                      notes: 'Registered official municipal collection facility.',
                    );
                    await _recyclingService.saveOrUpdateCentre(newCentre);
                    setState(() => _myCentre = newCentre);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F5520),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Register Centre',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
        labelStyle: const TextStyle(color: Color(0xFF69756D), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF8FAF7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD9E3DA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD9E3DA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.recycling_rounded,
                color: Color(0xFF1F5520),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Recycling Officer Hub',
              style: TextStyle(
                color: Color(0xFF1F5520),
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFE57373)),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1F5520)))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Officer Profile Banner
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1F5520), Color(0xFF2E7D32)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1F5520).withValues(alpha: 0.15),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.badge_outlined,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome, $_officerName',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _officerEmail,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.85),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // If no centre is registered yet
                        if (_myCentre == null) ...[
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFD9E3DA)),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.store_mall_directory_outlined,
                                  size: 54,
                                  color: Color(0xFF2E7D32),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'No Recycling Centre Assigned',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F5520),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Register your facility details to manage accepted materials and operating hours.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF69756D),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                ElevatedButton.icon(
                                  onPressed: _openRegisterCentreModal,
                                  icon: const Icon(Icons.add_business_rounded),
                                  label: const Text('Register My Centre'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1F5520),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          // Live Status Card
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFD9E3DA)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _myCentre!.isOpen
                                            ? const Color(0xFF2E7D32)
                                            : const Color(0xFFC62828),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Operational Status',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF69756D),
                                          ),
                                        ),
                                        Text(
                                          _myCentre!.isOpen ? 'OPEN FOR DROP-OFFS' : 'TEMPORARILY CLOSED',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: _myCentre!.isOpen
                                                ? const Color(0xFF2E7D32)
                                                : const Color(0xFFC62828),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: _myCentre!.isOpen,
                                  activeThumbColor: const Color(0xFF1F5520),
                                  activeTrackColor: const Color(0xFFA5D6A7),
                                  onChanged: _toggleStatus,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Centre Information Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFD9E3DA)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _myCentre!.name,
                                        style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1F5520),
                                        ),
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: _openEditCentreModal,
                                      icon: const Icon(Icons.edit_outlined, size: 16),
                                      label: const Text('Edit'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(0xFF1F5520),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Color(0xFFECEFF1)),
                                const SizedBox(height: 8),
                                _buildDetailRow(Icons.location_on_outlined, 'Address', _myCentre!.address),
                                const SizedBox(height: 10),
                                _buildDetailRow(Icons.location_city_outlined, 'City', _myCentre!.city),
                                const SizedBox(height: 10),
                                _buildDetailRow(Icons.phone_outlined, 'Phone', _myCentre!.contactNumber),
                                const SizedBox(height: 10),
                                _buildDetailRow(Icons.email_outlined, 'Email', _myCentre!.email),
                                const SizedBox(height: 10),
                                _buildDetailRow(Icons.access_time_outlined, 'Hours', _myCentre!.operatingHours),
                                if (_myCentre!.notes.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  _buildDetailRow(Icons.info_outline, 'Notes', _myCentre!.notes),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Accepted Materials Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFD9E3DA)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: Color(0xFF2E7D32),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Accepted Materials (${_myCentre!.acceptedMaterials.length})',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1F5520),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton.icon(
                                      onPressed: _openManageMaterialsModal,
                                      icon: const Icon(Icons.tune_rounded, size: 16),
                                      label: const Text('Manage'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(0xFF1F5520),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _myCentre!.acceptedMaterials.map((mat) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5E9),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: const Color(0xFFC8E6C9),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.check,
                                            size: 14,
                                            color: Color(0xFF2E7D32),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            mat,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF1B5E20),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Unsupported Materials Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFFFCDD2)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.cancel_outlined,
                                      color: Color(0xFFC62828),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Unsupported Items (${_myCentre!.unsupportedMaterials.length})',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFC62828),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                if (_myCentre!.unsupportedMaterials.isEmpty)
                                  const Text(
                                    'None — all categories are currently accepted.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF757575),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                else
                                  ..._myCentre!.unsupportedMaterials.map((mat) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.remove_circle_outline,
                                            size: 14,
                                            color: Color(0xFFD32F2F),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              mat,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFFB71C1C),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
        const SizedBox(width: 10),
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF69756D),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF2D3748),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}