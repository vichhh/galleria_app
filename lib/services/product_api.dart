import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String? kApiHostOverride = '192.168.10.72';

class Product {
  final int id;
  final String name;
  final double price;
  final String detail;
  final String image;
  final String category; // 'hypercar' | 'sport' | ...

  // optional specs
  final int? year;
  final String? bodyType;
  final int? power;      // HP
  final int? cylinders;
  final int? topSpeed;   // km/h
  final String? fuelType;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.detail,
    required this.image,
    required this.category,
    this.year,
    this.bodyType,
    this.power,
    this.cylinders,
    this.topSpeed,
    this.fuelType,
  });

  static int _toInt(dynamic v) {
    if (v == null) return -1;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? -1;
    return -1;
  }

  static int? _toIntOrNull(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    if (v is String) {
      final cleaned = RegExp(r'[0-9.]+').allMatches(v).map((m) => m.group(0)!).join();
      return double.tryParse(cleaned.isEmpty ? v : cleaned) ?? 0.0;
    }
    return 0.0;
  }

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: _toInt(j['id']),
        name: (j['name']?.toString() ?? '').trim(),
        price: _toDouble(j['price']),
        detail: (j['detail']?.toString() ?? '').trim(),
        image: (j['image']?.toString() ?? '').trim(),
        category: (j['category']?.toString() ?? 'product').trim(),
        year: _toIntOrNull(j['year']),
        bodyType: j['bodyType']?.toString(),
        power: _toIntOrNull(j['power']),
        cylinders: _toIntOrNull(j['cylinders']),
        topSpeed: _toIntOrNull(j['topSpeed']),
        fuelType: j['fuelType']?.toString(),
      );
}

class ProductApi {
  static String get _host {
    if (kApiHostOverride != null && kApiHostOverride!.isNotEmpty) return kApiHostOverride!;
    if (!kIsWeb && Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static Uri _u(String path) => Uri.parse('http://$_host:3000$path');

  static Future<List<Product>> fetchAll() async {
    try {
      final res = await http.get(_u('/products')).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
      final body = json.decode(res.body);
      if (body is! List) throw Exception('Unexpected JSON shape');

      final List<Product> items = [];
      for (final e in body) {
        try {
          if (e is Map<String, dynamic>) {
            final p = Product.fromJson(e);
            if (p.id > 0 && p.name.isNotEmpty) items.add(p);
          }
        } catch (err) {
          debugPrint('Skip invalid item: $e -> $err');
        }
      }
      return items;
    } on TimeoutException {
      throw Exception('Request timed out. Is json-server running?');
    } on SocketException {
      throw Exception('Cannot reach API at $_host:3000');
    }
  }

  static Future<Product> fetchById(int id) async {
    try {
      final r1 = await http.get(_u('/products/$id')).timeout(const Duration(seconds: 8));
      if (r1.statusCode == 200) {
        final data = json.decode(r1.body);
        if (data is Map<String, dynamic>) return Product.fromJson(data);
      }
      final r2 = await http.get(_u('/products?id=$id')).timeout(const Duration(seconds: 8));
      if (r2.statusCode == 200) {
        final list = json.decode(r2.body);
        if (list is List && list.isNotEmpty && list.first is Map<String, dynamic>) {
          return Product.fromJson(list.first as Map<String, dynamic>);
        }
      }
      final all = await fetchAll();
      final found = all.firstWhere(
        (p) => p.id == id,
        orElse: () => all.firstWhere(
          (p) => p.id.toString() == id.toString(),
          orElse: () => throw Exception('Product $id not found'),
        ),
      );
      return found;
    } on TimeoutException {
      throw Exception('Timeout for product #$id');
    } on SocketException {
      throw Exception('Network error for product #$id');
    }
  }
}