import 'package:flutter/foundation.dart';

import '../models/legends.dart';
import '../services/api_service.dart';

class LegendRepository {
  final ApiService _apiService;

  LegendRepository(this._apiService);

  Future<List<Legend>> fetchAllLegends() async {
    try {
      return await _apiService.getAllLegends();
    } catch (e) {
      // Handle or rethrow the exception
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<Legend> fetchLegendById(int legendId) async {
    try {
      return await _apiService.getLegendById(legendId);
    } catch (e) {
      // Handle or rethrow the exception
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

// Add methods for other legend-related operations
}
