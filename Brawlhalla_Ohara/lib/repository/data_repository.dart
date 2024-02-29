import '../models/data.dart';
import '../services/api_service.dart';

class DataRepository {
  final ApiService apiService;

  DataRepository(this.apiService);

  Future<List<Ranking>> fetchRanked1v1Data(String region, int page) async {
    return await apiService.getRanked1v1Data(region, page);
  }

  Future<List<Ranking2v2>> fetchRanked2v2Data(String region, int page) async {
    return await apiService.getRanked2v2Data(region, page);
  }


}
