import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/supplier.dart';
import '../services/api_service.dart';

class SupplierFormScreen extends StatefulWidget {
  const SupplierFormScreen({super.key});

  @override
  State<SupplierFormScreen> createState() => _SupplierFormScreenState();
}

class _SupplierFormScreenState extends State<SupplierFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _addressFocus = FocusNode();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    final val = v?.trim() ?? '';
    if (val.isEmpty) return 'Vui lòng nhập tên nhà cung cấp';
    if (val.length < 2) return 'Tên phải có ít nhất 2 ký tự';
    if (val.length > 100) return 'Tên không được vượt quá 100 ký tự';
    return null;
  }

  String? _validatePhone(String? v) {
    final val = v?.trim() ?? '';
    if (val.isEmpty) return 'Vui lòng nhập số điện thoại';
    // Vietnamese phone: starts with 0, exactly 10 digits
    final phoneRegex = RegExp(r'^0[0-9]{9}$');
    if (!phoneRegex.hasMatch(val)) return 'Số điện thoại không hợp lệ (VD: 0901234567)';
    return null;
  }

  String? _validateAddress(String? v) {
    final val = v?.trim() ?? '';
    if (val.isEmpty) return 'Vui lòng nhập địa chỉ';
    if (val.length < 5) return 'Địa chỉ phải có ít nhất 5 ký tự';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final supplier = Supplier(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );
      await ApiService.createSupplier(supplier);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thêm nhà cung cấp thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm nhà cung cấp'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocus,
                textCapitalization: TextCapitalization.words,
                maxLength: 100,
                decoration: const InputDecoration(
                  labelText: 'Tên nhà cung cấp *',
                  hintText: 'VD: Công ty ABC',
                  prefixIcon: Icon(Icons.business),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                focusNode: _phoneFocus,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại *',
                  hintText: 'VD: 0901234567',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _addressFocus.requestFocus(),
                validator: _validatePhone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                focusNode: _addressFocus,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 255,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ *',
                  hintText: 'VD: 123 Nguyễn Huệ, Q.1, TP.HCM',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: _validateAddress,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loading ? null : _submit,
                icon: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_loading ? 'Đang lưu...' : 'Lưu'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
