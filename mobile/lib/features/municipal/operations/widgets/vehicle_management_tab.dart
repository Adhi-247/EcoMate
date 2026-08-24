import 'package:flutter/material.dart';
import '../../theme/municipal_colors.dart';
import '../models/operations_models.dart';
import '../services/operations_service.dart';

class VehicleManagementTab extends StatefulWidget {
  const VehicleManagementTab({super.key});

  @override
  State<VehicleManagementTab> createState() => _VehicleManagementTabState();
}

class _VehicleManagementTabState extends State<VehicleManagementTab> {
  final OperationsService _apiService = OperationsService();
  List<Vehicle> _vehicles = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final vehicles = await _apiService.getAllVehicles();
      setState(() {
        _vehicles = vehicles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
        _isLoading = false;
      });
    }
  }

  void _showVehicleForm([Vehicle? vehicle]) {
    final isEditing = vehicle != null;
    final formKey = GlobalKey<FormState>();

    final regNumberController = TextEditingController(text: vehicle?.registrationNumber ?? '');
    final capacityController = TextEditingController(text: vehicle?.capacity.toString() ?? '');

    String selectedType = vehicle?.vehicleType ?? 'Compactor';
    String selectedStatus = vehicle?.status ?? 'AVAILABLE';
    DateTime selectedServiceDate = vehicle?.lastServiceDate ?? DateTime.now();
    bool isActive = vehicle?.active ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: MunicipalColors.pageBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEditing ? 'Edit Vehicle Info' : 'Register Vehicle',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: MunicipalColors.primaryText,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Registration Number
                      TextFormField(
                        controller: regNumberController,
                        enabled: !isEditing,
                        decoration: InputDecoration(
                          labelText: 'Registration Number',
                          prefixIcon: const Icon(Icons.local_shipping_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: isEditing,
                          fillColor: isEditing ? MunicipalColors.primaryBg : null,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter Registration Number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Capacity
                      TextFormField(
                        controller: capacityController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Load Capacity (Tons)',
                          prefixIcon: const Icon(Icons.line_weight_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter capacity';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Capacity must be a number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Vehicle Type dropdown
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: InputDecoration(
                          labelText: 'Vehicle Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Compactor', child: Text('Compactor (Garbage Truck)')),
                          DropdownMenuItem(value: 'Dumper', child: Text('Dumper Truck')),
                          DropdownMenuItem(value: 'Flatbed', child: Text('Flatbed Truck')),
                          DropdownMenuItem(value: 'Roll-off', child: Text('Roll-off Container Truck')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() => selectedType = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Status dropdown
                      DropdownButtonFormField<String>(
                        value: selectedStatus,
                        decoration: InputDecoration(
                          labelText: 'Availability Status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'AVAILABLE', child: Text('Available')),
                          DropdownMenuItem(value: 'ON_DUTY', child: Text('On Duty')),
                          DropdownMenuItem(value: 'MAINTENANCE', child: Text('Maintenance')),
                          DropdownMenuItem(value: 'INACTIVE', child: Text('Inactive')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() => selectedStatus = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Last Service Date Datepicker
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedServiceDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: MunicipalColors.secondaryGreen,
                                    onPrimary: Colors.white,
                                    onSurface: MunicipalColors.primaryText,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setModalState(() => selectedServiceDate = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Last Serviced: ${selectedServiceDate.toLocal().toString().split(' ')[0]}',
                                style: const TextStyle(fontSize: 16, color: MunicipalColors.primaryText),
                              ),
                              const Icon(Icons.calendar_today_outlined, color: MunicipalColors.secondaryGreen),
                            ],
                          ),
                        ),
                      ),

                      if (isEditing) ...[
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Active Fleet Resource'),
                          subtitle: const Text('Deactivation marks vehicle as inactive'),
                          value: isActive,
                          activeColor: MunicipalColors.secondaryGreen,
                          onChanged: (value) {
                            setModalState(() => isActive = value);
                          },
                        ),
                      ],

                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MunicipalColors.secondaryGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final updatedVehicle = Vehicle(
                                id: vehicle?.id,
                                registrationNumber: regNumberController.text.trim().toUpperCase(),
                                vehicleType: selectedType,
                                capacity: double.parse(capacityController.text),
                                status: selectedStatus,
                                lastServiceDate: selectedServiceDate,
                                active: isActive,
                              );

                              Navigator.pop(context);

                              setState(() => _isLoading = true);
                              try {
                                if (isEditing) {
                                  await _apiService.updateVehicle(vehicle.id!, updatedVehicle);
                                  _showSnackBar('Vehicle details updated!', Colors.green);
                                } else {
                                  await _apiService.createVehicle(updatedVehicle);
                                  _showSnackBar('Vehicle registered successfully!', Colors.green);
                                }
                                _loadVehicles();
                              } catch (e) {
                                setState(() => _isLoading = false);
                                _showErrorDialog(e.toString().replaceAll('Exception:', '').trim());
                              }
                            }
                          },
                          child: Text(isEditing ? 'Save Details' : 'Register Vehicle'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline_rounded, color: MunicipalColors.error),
            SizedBox(width: 8),
            Text('Action Failed'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: MunicipalColors.secondaryGreen)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _toggleVehicleStatus(Vehicle vehicle) async {
    setState(() => _isLoading = true);
    try {
      if (vehicle.active) {
        await _apiService.deactivateVehicle(vehicle.id!);
        _showSnackBar('${vehicle.registrationNumber} deactivated.', Colors.orange);
      } else {
        final reactivated = Vehicle(
          id: vehicle.id,
          registrationNumber: vehicle.registrationNumber,
          vehicleType: vehicle.vehicleType,
          capacity: vehicle.capacity,
          status: 'AVAILABLE',
          lastServiceDate: vehicle.lastServiceDate,
          active: true,
        );
        await _apiService.updateVehicle(vehicle.id!, reactivated);
        _showSnackBar('${vehicle.registrationNumber} reactivated.', Colors.green);
      }
      _loadVehicles();
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog(e.toString().replaceAll('Exception:', '').trim());
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'AVAILABLE':
        return MunicipalColors.success;
      case 'ON_DUTY':
        return MunicipalColors.info;
      case 'MAINTENANCE':
        return MunicipalColors.warning;
      case 'INACTIVE':
        return MunicipalColors.error;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: MunicipalColors.secondaryGreen),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: MunicipalColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: const TextStyle(fontSize: 16, color: MunicipalColors.primaryText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: MunicipalColors.secondaryGreen),
              onPressed: _loadVehicles,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('Try Again', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (_vehicles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_shipping_outlined, color: MunicipalColors.secondaryText, size: 64),
            const SizedBox(height: 16),
            const Text(
              'No vehicles in fleet.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MunicipalColors.primaryText),
            ),
            const SizedBox(height: 8),
            const Text('Click button below to register your first waste collection vehicle.', style: TextStyle(color: MunicipalColors.secondaryText)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: MunicipalColors.secondaryGreen),
              onPressed: () => _showVehicleForm(),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Register Vehicle', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: _loadVehicles,
        color: MunicipalColors.secondaryGreen,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = _vehicles[index];
            final statusColor = _getStatusColor(vehicle.status);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: vehicle.active ? Colors.white : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: vehicle.active ? MunicipalColors.border : Colors.grey.shade300,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x05000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      // Active Indicator Color bar
                      Container(
                        width: 6,
                        color: vehicle.active ? MunicipalColors.secondaryGreen : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    vehicle.registrationNumber,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: vehicle.active ? MunicipalColors.primaryText : MunicipalColors.secondaryText,
                                      decoration: vehicle.active ? null : TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: vehicle.active ? MunicipalColors.secondaryGreen.withOpacity(0.1) : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      vehicle.vehicleType,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: vehicle.active ? MunicipalColors.secondaryGreen : Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  // Status Indicator
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: statusColor.withOpacity(0.5)),
                                    ),
                                    child: Text(
                                      vehicle.status.replaceFirst('_', ' ').toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.line_weight_rounded, size: 14, color: MunicipalColors.secondaryText),
                                  const SizedBox(width: 4),
                                  Text('Capacity: ${vehicle.capacity} Tons', style: const TextStyle(fontSize: 13, color: MunicipalColors.secondaryText)),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.build_outlined, size: 14, color: MunicipalColors.secondaryText),
                                  const SizedBox(width: 4),
                                  Text(
                                    vehicle.lastServiceDate != null
                                      ? 'Serviced: ${vehicle.lastServiceDate!.toLocal().toString().split(' ')[0]}'
                                      : 'No Service Records',
                                    style: const TextStyle(fontSize: 13, color: MunicipalColors.secondaryText),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Actions
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: MunicipalColors.secondaryText),
                            onPressed: () => _showVehicleForm(vehicle),
                          ),
                          IconButton(
                            icon: Icon(
                              vehicle.active ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
                              color: vehicle.active ? MunicipalColors.secondaryGreen : Colors.grey,
                              size: 28,
                            ),
                            onPressed: () => _toggleVehicleStatus(vehicle),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MunicipalColors.secondaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showVehicleForm(),
      ),
    );
  }
}
