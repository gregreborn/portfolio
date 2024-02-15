import 'package:equatable/equatable.dart';

import '../../models/player.dart';

// player_state.dart
abstract class PlayerState {}

class PlayerLoading extends PlayerState {}

class PlayerLoaded extends PlayerState {
  final Player player;

  PlayerLoaded(this.player);
}

class PlayerError extends PlayerState {
  final String message;

  PlayerError(this.message);
}