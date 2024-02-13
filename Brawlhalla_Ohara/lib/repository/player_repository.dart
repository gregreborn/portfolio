import 'package:flutter/foundation.dart';

import '../models/player.dart';
import '../services/api_service.dart';

class PlayerRepository {
  final ApiService _apiService;

  PlayerRepository(this._apiService);

  Future<Player> getPlayerStats(int brawlhallaId) async {
    try {
      return await _apiService.getStatsById(brawlhallaId);
    } catch (e) {
      // Handle or rethrow the exception
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
