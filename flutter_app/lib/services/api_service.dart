import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/supplier.dart';

class ApiService {
  // Use 10.0.2.2 for Android emulator (maps to host localhost)
  static const String baseUrl = 'http://10.0.2.2:8080/api/suppliers';

  static Future<List<Supplier>> getSuppliers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Supplier.fromJson(e)).toList();
    }
    throw Exception('Failed to load suppliers');
  }

  static Future<Supplier> createSupplier(Supplier supplier) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(supplier.toJson()),
    );
    if (response.statusCode == 200) {
      return Supplier.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create supplier');
  }
}
