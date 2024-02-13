import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = "https://brawlhalla.fly.dev/v1";

  Future<dynamic> _get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<dynamic> getRankedById(int brawlhallaId) async {
    return _get('ranked/id?brawlhalla_id=$brawlhallaId');
  }

  Future<dynamic> getRankedBySteamId(String steamId) async {
    return _get('ranked/steamid?steam_id=$steamId');
  }

  Future<dynamic> getRankedBySteamUrl(String steamUrl) async {
    return _get('ranked/steamurl?steam_url=$steamUrl');
  }

  Future<dynamic> getStatsById(int brawlhallaId) async {
    return _get('stats/id?brawlhalla_id=$brawlhallaId');
  }

  Future<dynamic> getStatsBySteamId(String steamId) async {
    return _get('stats/steamid?steam_id=$steamId');
  }

  Future<dynamic> getStatsBySteamUrl(String steamUrl) async {
    return _get('stats/steamurl?steam_url=$steamUrl');
  }

  Future<dynamic> getAllLegends() async {
    return _get('legends/all');
  }

  Future<dynamic> getLegendById(int legendId) async {
    return _get('legends/id?legend_id=$legendId');
  }

  Future<dynamic> getLegendByName(String legendName) async {
    return _get('legends/name?legend_name=$legendName');
  }

  Future<dynamic> getSteamDataById(String steamId) async {
    return _get('steamdata/id?steam_id=$steamId');
  }

  Future<dynamic> getSteamDataByUrl(String steamUrl) async {
    return _get('steamdata/url?steam_url=$steamUrl');
  }

  Future<dynamic> getRanked1v1Data(String region, int page) async {
    return _get('utils/ranked1v1?region=$region&page=$page');
  }

  Future<dynamic> getRanked2v2Data(String region, int page) async {
    return _get('utils/ranked2v2?region=$region&page=$page');
  }

  Future<dynamic> getRankedSeasonalData(String region, int page) async {
    return _get('utils/rankedseasonal?region=$region&page=$page');
  }

  Future<dynamic> getClanData(int clanId) async {
    return _get('utils/clan?clan_id=$clanId');
  }
}

