import 'package:equatable/equatable.dart';

import '../../models/player.dart';

// player_state.dart
abstract class PlayerState {}

class PlayerInitial extends PlayerState {}

class PlayerLoading extends PlayerState {}

class PlayerLoaded extends PlayerState {
  final Player playerData;
  final Player rankingData;

  PlayerLoaded(this.playerData, this.rankingData);
}

class PlayerError extends PlayerState {
  final String message;

  PlayerError(this.message);
}
