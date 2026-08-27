import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/waste_report_service.dart';

class ReportDetailsScreen extends StatefulWidget {
  const ReportDetailsScreen({super.key, required this.issueType});

  final String issueType;

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  static const darkGreen = Color(0xFF024B45);
  static const green = Color(0xFF028B6B);
  static const background = Color(0xFFF2FAF7);
  static const border = Color(0xFFD8EBE6);
  static const text = Color(0xFF0F172A);
  static const secondaryText = Color(0xFF64748B);

  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _service = WasteReportService();
  final _picker = ImagePicker();
  String _category = 'General Waste';
  Uint8List? _photoBytes;
  String? _photoData;
  bool _submitting = false;
  bool _reviewing = false;

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() {
      _photoBytes = bytes;
      _photoData = base64Encode(bytes);
    });
  }

  Future<void> _submit() async {
    if (_locationController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
      _showMessage('Add a location and description before submitting.');
      return;
    }
    setState(() => _submitting = true);
    try {
      final result = await _service.submitReport(
        issueType: widget.issueType,
        location: _locationController.text.trim(),
        category: _category,
        description: _descriptionController.text.trim(),
        photoData: _photoData,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Report submitted'),
          content: Text('Reference number: ${result['referenceNumber']}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (error) {
      if (mounted) _showMessage(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _openReview() {
    if (_locationController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
      _showMessage('Add a location and description before reviewing.');
      return;
    }
    setState(() => _reviewing = true);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: darkGreen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: darkGreen,
        elevation: 0,
        title: Text(_reviewing ? 'Review Report' : 'Report Details', style: const TextStyle(color: darkGreen, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          _ReportProgress(activeStep: _reviewing ? 3 : 2),
          _stepHeader(),
          if (_reviewing) _reviewSummary() else _detailsForm(),
        ],
      ),
    );
  }

  Widget _detailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          const SizedBox(height: 22),
          Text('Issue: ${widget.issueType}', style: const TextStyle(color: darkGreen, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _label('Incident location'),
          TextField(
            controller: _locationController,
            decoration: _decoration('Enter address or landmark', Icons.location_on_outlined),
          ),
          const SizedBox(height: 16),
          _label('Waste category'),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: _decoration('Select category', Icons.category_outlined),
            items: const ['General Waste', 'Organic Waste', 'Plastic', 'Glass', 'Metal', 'Other']
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) => setState(() => _category = value ?? _category),
          ),
          const SizedBox(height: 16),
          _label('What happened?'),
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            maxLength: 1200,
            decoration: _decoration('Describe the waste problem', Icons.notes_outlined),
          ),
          const SizedBox(height: 8),
          _label('Photo evidence (optional)'),
          InkWell(
            onTap: _pickPhoto,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 110,
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: border), borderRadius: BorderRadius.circular(10)),
              child: _photoBytes == null
                  ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_a_photo_outlined, color: green), SizedBox(height: 6), Text('Add photo')])
                  : ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.memory(_photoBytes!, fit: BoxFit.cover)),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _submitting ? null : _openReview,
              style: ElevatedButton.styleFrom(backgroundColor: darkGreen, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('Review Report', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
      ],
    );
  }

  Widget _reviewSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        _reviewRow('Issue type', widget.issueType),
        _reviewRow('Location', _locationController.text.trim()),
        _reviewRow('Category', _category),
        _reviewRow('Description', _descriptionController.text.trim()),
        _reviewRow('Evidence', _photoBytes == null ? 'No photo attached' : 'Photo attached'),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: () => setState(() => _reviewing = false), child: const Text('Edit'))),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(onPressed: _submitting ? null : _submit, style: ElevatedButton.styleFrom(backgroundColor: darkGreen, foregroundColor: Colors.white), child: _submitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Submit Report'))),
          ],
        ),
      ],
    );
  }

  Widget _reviewRow(String label, String value) => Padding(padding: const EdgeInsets.only(bottom: 14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: secondaryText, fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(value, style: const TextStyle(color: text, fontSize: 15))]));
  Widget _stepHeader() => Text(_reviewing ? 'Step 4 of 4  •  Confirm and submit' : 'Step 3 of 4  •  Details and evidence', style: const TextStyle(color: secondaryText, fontWeight: FontWeight.w600));
  Widget _label(String label) => Padding(padding: const EdgeInsets.only(bottom: 7), child: Text(label, style: const TextStyle(color: text, fontWeight: FontWeight.w700)));
  InputDecoration _decoration(String hint, IconData icon) => InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: green), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: border)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: border)));
}

class _ReportProgress extends StatelessWidget {
  const _ReportProgress({required this.activeStep});

  final int activeStep;

  @override
  Widget build(BuildContext context) {
    const labels = ['Type', 'Location', 'Details', 'Review'];
    return Row(
      children: List.generate(labels.length, (index) {
        final complete = index <= activeStep;
        return Expanded(
          child: Column(
            children: [
              Row(children: [
                if (index > 0) const Expanded(child: Divider(color: _ReportDetailsScreenState.border)),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: complete ? _ReportDetailsScreenState.darkGreen : const Color(0xFFE2E4E4),
                  child: Text('${index + 1}', style: TextStyle(color: complete ? Colors.white : _ReportDetailsScreenState.secondaryText, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
                if (index < labels.length - 1) const Expanded(child: Divider(color: _ReportDetailsScreenState.border)),
              ]),
              const SizedBox(height: 4),
              Text(labels[index], style: TextStyle(color: complete ? _ReportDetailsScreenState.darkGreen : _ReportDetailsScreenState.secondaryText, fontSize: 10)),
            ],
          ),
        );
      }),
    );
  }
}
