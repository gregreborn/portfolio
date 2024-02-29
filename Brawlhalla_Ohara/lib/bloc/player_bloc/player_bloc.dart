import 'package:brawlhalla_ohara/bloc/player_bloc/player_event.dart';
import 'package:brawlhalla_ohara/bloc/player_bloc/player_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/player.dart';
import '../../repository/player_repository.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final PlayerRepository playerRepository;

  PlayerBloc(this.playerRepository) : super(PlayerInitial()) {
    on<FetchPlayerById>((event, emit) async {
      try {
        emit(PlayerLoading());
        final Player playerData = await playerRepository.fetchPlayerById(event.brawlhallaId);
        final Player rankingData = await playerRepository.fetchRankedById(event.brawlhallaId);
        emit(PlayerLoaded(playerData, rankingData));
      } catch (error) {
        emit(PlayerError(error.toString()));
      }
    });

    on<FetchPlayerBySteamId>((event, emit) async {
      emit(PlayerLoading());
      try {
        final Player player = await playerRepository.fetchPlayerBySteamId(event.steamId);
        final Player ranking = await playerRepository.fetchRankedBySteamId(event.steamId);
        emit(PlayerLoaded(player, ranking));
      } catch (error) {
        emit(PlayerError(error.toString()));
      }
    });

    on<FetchPlayerBySteamUrl>((event, emit) async {
      emit(PlayerLoading());
      try {
        final Player player = await playerRepository.fetchPlayerBySteamUrl(event.steamUrl);
        final Player ranking = await playerRepository.fetchRankedBySteamUrl(event.steamUrl);
        emit(PlayerLoaded(player, ranking));
      } catch (error) {
        emit(PlayerError(error.toString()));
      }
    });

  }
}
