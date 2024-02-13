import 'package:brawlhalla_ohara/bloc/player_bloc/player_event.dart';
import 'package:brawlhalla_ohara/bloc/player_bloc/player_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/player.dart';
import '../../services/api_service.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final ApiService apiService;

  PlayerBloc({required this.apiService}) : super(PlayerInitial()) {
    on<PlayerLoad>((event, emit) async {
      emit(PlayerLoadInProgress());
      try {
        Player? player;
        if (event.brawlhallaId != null) {
          player = await apiService.getStatsById(event.brawlhallaId!);
        } else if (event.steamId != null) {
          player = await apiService.getStatsBySteamId(event.steamId!);
        } else if (event.steamUrl != null) {
          player = await apiService.getStatsBySteamUrl(event.steamUrl!);
        } else {
          throw Exception("No valid identifier provided");
        }
        if (player != null) {
          emit(PlayerLoadSuccess(player));
        } else {
          emit(PlayerLoadFailure("Player not found"));
        }
      } catch (error) {
        emit(PlayerLoadFailure(error.toString()));
      }
    });

  }
}
