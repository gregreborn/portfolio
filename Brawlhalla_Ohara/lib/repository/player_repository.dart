import 'package:flutter/foundation.dart';

import '../models/player.dart';
import '../services/api_service.dart';

class PlayerRepository {
  final ApiService _apiService;

  PlayerRepository(this._apiService);

  Future<Player> fetchPlayerById(int brawlhallaId) async {
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

  Future<Player> fetchPlayerBySteamId(String steamId) async {
    try {
      return await _apiService.getStatsBySteamId(steamId);
    } catch (e) {
      // Handle or rethrow the exception
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<Player> fetchPlayerBySteamUrl(String steamUrl) async {
    try {
      return await _apiService.getStatsBySteamUrl(steamUrl);
    } catch (e) {
      // Handle or rethrow the exception
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<Player> fetchRankedById(int brawlhallaId) async {
    try {
      final response = await _apiService.getRankedById(brawlhallaId);
      return Player.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<Player> fetchRankedBySteamId(String steamId) async {
    try{
      return await _apiService.getRankedBySteamId(steamId);
    }catch (e){
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<Player> fetchRankedBySteamUrl(String steamUrl) async {
    try{
      return await _apiService.getRankedBySteamUrl(steamUrl);
    }catch (e){
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

}
