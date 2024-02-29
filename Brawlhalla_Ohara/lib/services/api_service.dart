import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/data.dart';
import '../models/player.dart';
import '../models/legends.dart';

class ApiService {
  final String _baseUrl = "https://brawlhalla.fly.dev/v1";

  Future<dynamic> _get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));

    if (response.statusCode == 200 &&
        response.headers[HttpHeaders.contentTypeHeader]?.contains(
            'application/json') == true) {
      if (kDebugMode) {
        print("Raw JSON response: ${response.body}");
      }
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found: The requested resource was not found.');
    } else if (response.statusCode == 500) {
      throw Exception('Server Error: Please try again later.');
    } else {
      throw Exception('Failed to load data from API with status code: ${response
          .statusCode}');
    }
  }

  Future<dynamic> getRankedById(int brawlhallaId) async {
    final jsonResponse = await _get('ranked/id?brawlhalla_id=$brawlhallaId');
    return Player.fromJson(jsonResponse);
  }

  Future<dynamic> getRankedBySteamId(String steamId) async {
    final jsonResponse = await _get('ranked/steamid?steam_id=$steamId');
    return Player.fromJson(jsonResponse);
  }

  Future<dynamic> getRankedBySteamUrl(String steamUrl) async {
    final jsonResponse = await _get('ranked/steamurl?steam_url=$steamUrl');
    return Player.fromJson(jsonResponse);
  }

  Future<dynamic> getStatsById(int brawlhallaId) async {
    final jsonResponse = await _get('stats/id?brawlhalla_id=$brawlhallaId');
    return Player.fromJson(jsonResponse);
  }


  Future<dynamic> getStatsBySteamId(String steamId) async {
    final jsonResponse = await _get('stats/steamid?steam_id=$steamId');
    return Player.fromJson(jsonResponse);
  }

  Future<dynamic> getStatsBySteamUrl(String steamUrl) async {
    final jsonResponse = await _get('stats/steamurl?steam_url=$steamUrl');
    return Player.fromJson(jsonResponse);
  }

  Future<List<Legend>> getAllLegends() async {
    final jsonResponse = await _get('legends/all');
    List<dynamic> legendsData = jsonResponse['data'];
    return legendsData.map((legendData) => Legend.fromJson(legendData))
        .toList();
  }

  Future<Legend> getLegendById(int legendId) async {
    final jsonResponse = await _get('legends/id?legend_id=$legendId');
    return Legend.fromJson(jsonResponse['data']);
  }

  Future<Legend> getLegendByName(String legendName) async {
    final jsonResponse = await _get('legends/name?legend_name=$legendName');
    return Legend.fromJson(jsonResponse['data']);
  }


  Future<List<Ranking>> getRanked1v1Data(String region, int page) async {
    final jsonResponse = await _get(
        'utils/rankedseasonal?region=$region&page=$page');
    if (jsonResponse is Map<String, dynamic> && jsonResponse['data'] is List) {
      List<dynamic> data = jsonResponse['data'];
      List<Ranking> rankings = data.map((data) => Ranking.fromJson(data))
          .toList();
      return rankings;
    } else {
      throw Exception("Invalid response format");
    }
  }


  Future<List<Ranking2v2>> getRanked2v2Data(String region, int page) async {
    final jsonResponse = await _get(
        'utils/ranked2v2?region=$region&page=$page');
    if (jsonResponse is Map<String, dynamic> && jsonResponse['data'] is List) {
      List<dynamic> data = jsonResponse['data'];
      List<Ranking2v2> rankings = data.map((data) => Ranking2v2.fromJson(data))
          .toList();
      return rankings;
    } else {
      throw Exception("Invalid response format");
    }
  }

}
