import 'package:flutter/material.dart';
import '../../theme/municipal_colors.dart';
import '../models/operations_models.dart';
import '../services/operations_service.dart';

class EmployeeManagementTab extends StatefulWidget {
  const EmployeeManagementTab({super.key});

  @override
  State<EmployeeManagementTab> createState() => _EmployeeManagementTabState();
}

class _EmployeeManagementTabState extends State<EmployeeManagementTab> {
  final OperationsService _apiService = OperationsService();
  List<Employee> _employees = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final employees = await _apiService.getAllEmployees();
      setState(() {
        _employees = employees;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
        _isLoading = false;
      });
    }
  }

  void _showEmployeeForm([Employee? employee]) {
    final isEditing = employee != null;
    final formKey = GlobalKey<FormState>();
    
    final employeeIdController = TextEditingController(text: employee?.employeeId ?? '');
    final nameController = TextEditingController(text: employee?.name ?? '');
    final phoneController = TextEditingController(text: employee?.phone ?? '');
    
    String selectedRole = employee?.role ?? 'DRIVER';
    String selectedZone = employee?.assignedZone ?? 'Zone A';
    String selectedShift = employee?.shift ?? 'Morning';
    String selectedStatus = employee?.status ?? 'AVAILABLE';
    bool isActive = employee?.active ?? true;

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
                            isEditing ? 'Edit Profile' : 'Add Driver/Collector',
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
                      
                      // Employee ID
                      TextFormField(
                        controller: employeeIdController,
                        enabled: !isEditing, // cannot edit ID
                        decoration: InputDecoration(
                          labelText: 'Employee ID',
                          prefixIcon: const Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: isEditing,
                          fillColor: isEditing ? MunicipalColors.primaryBg : null,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter Employee ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Name
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (!RegExp(r'^[0-9+\-\s]{7,15}$').hasMatch(value)) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Role and Shift Rows
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedRole,
                              decoration: InputDecoration(
                                labelText: 'Role',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'DRIVER', child: Text('Driver')),
                                DropdownMenuItem(value: 'COLLECTOR', child: Text('Collector')),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setModalState(() => selectedRole = value);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedShift,
                              decoration: InputDecoration(
                                labelText: 'Shift',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Morning', child: Text('Morning')),
                                DropdownMenuItem(value: 'Evening', child: Text('Evening')),
                                DropdownMenuItem(value: 'Night', child: Text('Night')),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setModalState(() => selectedShift = value);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Zone and Status Rows
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedZone,
                              decoration: InputDecoration(
                                labelText: 'Assigned Zone',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Zone A', child: Text('Zone A')),
                                DropdownMenuItem(value: 'Zone B', child: Text('Zone B')),
                                DropdownMenuItem(value: 'Zone C', child: Text('Zone C')),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setModalState(() => selectedZone = value);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedStatus,
                              decoration: InputDecoration(
                                labelText: 'Status',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'AVAILABLE', child: Text('Available')),
                                DropdownMenuItem(value: 'ON_DUTY', child: Text('On Duty')),
                                DropdownMenuItem(value: 'OFF_DUTY', child: Text('Off Duty')),
                                DropdownMenuItem(value: 'LEAVE', child: Text('Leave')),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setModalState(() => selectedStatus = value);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      if (isEditing) ...[
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Active Account'),
                          subtitle: const Text('Deactivating blocks resource assignments'),
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
                              final updatedEmp = Employee(
                                id: employee?.id,
                                employeeId: employeeIdController.text.trim(),
                                name: nameController.text.trim(),
                                phone: phoneController.text.trim(),
                                role: selectedRole,
                                assignedZone: selectedZone,
                                shift: selectedShift,
                                status: selectedStatus,
                                active: isActive,
                              );

                              Navigator.pop(context);
                              
                              setState(() => _isLoading = true);
                              try {
                                if (isEditing) {
                                  await _apiService.updateEmployee(employee.id!, updatedEmp);
                                  _showSnackBar('Profile updated successfully!', Colors.green);
                                } else {
                                  await _apiService.createEmployee(updatedEmp);
                                  _showSnackBar('Employee added successfully!', Colors.green);
                                }
                                _loadEmployees();
                              } catch (e) {
                                setState(() => _isLoading = false);
                                _showErrorDialog(e.toString().replaceAll('Exception:', '').trim());
                              }
                            }
                          },
                          child: Text(isEditing ? 'Save Changes' : 'Add Employee'),
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

  Future<void> _toggleEmployeeStatus(Employee emp) async {
    setState(() => _isLoading = true);
    try {
      if (emp.active) {
        await _apiService.deactivateEmployee(emp.id!);
        _showSnackBar('${emp.name} deactivated.', Colors.orange);
      } else {
        final reactivated = Employee(
          id: emp.id,
          employeeId: emp.employeeId,
          name: emp.name,
          phone: emp.phone,
          role: emp.role,
          assignedZone: emp.assignedZone,
          shift: emp.shift,
          status: 'AVAILABLE',
          active: true,
        );
        await _apiService.updateEmployee(emp.id!, reactivated);
        _showSnackBar('${emp.name} activated.', Colors.green);
      }
      _loadEmployees();
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
      case 'OFF_DUTY':
        return MunicipalColors.secondaryText;
      case 'LEAVE':
        return MunicipalColors.warning;
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
              onPressed: _loadEmployees,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('Try Again', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (_employees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline_rounded, color: MunicipalColors.secondaryText, size: 64),
            const SizedBox(height: 16),
            const Text(
              'No employees registered yet.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MunicipalColors.primaryText),
            ),
            const SizedBox(height: 8),
            const Text('Click button below to register a driver or collector.', style: TextStyle(color: MunicipalColors.secondaryText)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: MunicipalColors.secondaryGreen),
              onPressed: () => _showEmployeeForm(),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Register Employee', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: _loadEmployees,
        color: MunicipalColors.secondaryGreen,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _employees.length,
          itemBuilder: (context, index) {
            final emp = _employees[index];
            final statusColor = _getStatusColor(emp.status);
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: emp.active ? Colors.white : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: emp.active ? MunicipalColors.border : Colors.grey.shade300,
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
                      // Role Color bar
                      Container(
                        width: 6,
                        color: emp.active 
                          ? (emp.role == 'DRIVER' ? MunicipalColors.deepBlue : MunicipalColors.noticeGreen)
                          : Colors.grey,
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
                                    emp.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: emp.active ? MunicipalColors.primaryText : MunicipalColors.secondaryText,
                                      decoration: emp.active ? null : TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: emp.active 
                                        ? (emp.role == 'DRIVER' ? MunicipalColors.deepBlue.withOpacity(0.1) : MunicipalColors.noticeGreen.withOpacity(0.1))
                                        : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      emp.role == 'DRIVER' ? 'Driver' : 'Collector',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: emp.active 
                                          ? (emp.role == 'DRIVER' ? MunicipalColors.deepBlue : MunicipalColors.secondaryGreen)
                                          : Colors.grey,
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
                                      emp.status.replaceFirst('_', ' ').toUpperCase(),
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
                                  const Icon(Icons.badge_outlined, size: 14, color: MunicipalColors.secondaryText),
                                  const SizedBox(width: 4),
                                  Text('ID: ${emp.employeeId}', style: const TextStyle(fontSize: 13, color: MunicipalColors.secondaryText)),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.phone_outlined, size: 14, color: MunicipalColors.secondaryText),
                                  const SizedBox(width: 4),
                                  Text(emp.phone, style: const TextStyle(fontSize: 13, color: MunicipalColors.secondaryText)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.map_outlined, size: 14, color: MunicipalColors.secondaryText),
                                  const SizedBox(width: 4),
                                  Text(emp.assignedZone ?? 'No Zone', style: const TextStyle(fontSize: 13, color: MunicipalColors.secondaryText)),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.access_time_rounded, size: 14, color: MunicipalColors.secondaryText),
                                  const SizedBox(width: 4),
                                  Text(emp.shift ?? 'No Shift', style: const TextStyle(fontSize: 13, color: MunicipalColors.secondaryText)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Edit and Delete Actions
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: MunicipalColors.secondaryText),
                            onPressed: () => _showEmployeeForm(emp),
                          ),
                          IconButton(
                            icon: Icon(
                              emp.active ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
                              color: emp.active ? MunicipalColors.secondaryGreen : Colors.grey,
                              size: 28,
                            ),
                            onPressed: () => _toggleEmployeeStatus(emp),
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
        onPressed: () => _showEmployeeForm(),
      ),
    );
  }
}
