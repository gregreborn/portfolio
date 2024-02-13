import 'package:equatable/equatable.dart';

import '../../models/player.dart';

abstract class PlayerState extends Equatable {
  @override
  List<Object> get props => [];
}

class PlayerInitial extends PlayerState {}

class PlayerLoadInProgress extends PlayerState {}

class PlayerLoadSuccess extends PlayerState {
  final Player player;

  PlayerLoadSuccess(this.player);

  @override
  List<Object> get props => [player];
}

class PlayerLoadFailure extends PlayerState {
  final String error;

  PlayerLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
