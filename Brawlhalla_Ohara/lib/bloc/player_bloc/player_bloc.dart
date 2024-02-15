import 'package:brawlhalla_ohara/bloc/player_bloc/player_event.dart';
import 'package:brawlhalla_ohara/bloc/player_bloc/player_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/player.dart';
import '../../repository/player_repository.dart';

// player_bloc.dart
class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final PlayerRepository playerRepository;

  PlayerBloc(this.playerRepository) : super(PlayerLoading()) {
    on<FetchPlayerById>((event, emit) async {
      emit(PlayerLoading());
      try {
        final Player player = await playerRepository.fetchPlayerById(event.brawlhallaId);
        emit(PlayerLoaded(player));
      } catch (error) {
        emit(PlayerError(error.toString()));
      }
    });

    on<FetchPlayerBySteamId>((event, emit) async {
      emit(PlayerLoading());
      try {
        //  repository has a method to fetch by Steam ID
        final Player player = await playerRepository.fetchPlayerBySteamId(event.steamId);
        emit(PlayerLoaded(player));
      } catch (error) {
        emit(PlayerError(error.toString()));
      }
    });

    on<FetchPlayerBySteamUrl>((event, emit) async {
      emit(PlayerLoading());
      try {
        //  repository has a method to fetch by Steam URL
        final Player player = await playerRepository.fetchPlayerBySteamUrl(event.steamUrl);
        emit(PlayerLoaded(player));
      } catch (error) {
        emit(PlayerError(error.toString()));
      }
    });

    // Additional handlers for other events
  }
}