import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/player.dart';
import '../../repository/player_repository.dart';

// player_event.dart
abstract class PlayerEvent {}

class FetchPlayerById extends PlayerEvent {
  final int brawlhallaId;
  FetchPlayerById(this.brawlhallaId);
}

class FetchPlayerBySteamId extends PlayerEvent {
  final String steamId;
  FetchPlayerBySteamId(this.steamId);
}

class FetchPlayerBySteamUrl extends PlayerEvent {
  final String steamUrl;
  FetchPlayerBySteamUrl(this.steamUrl);
}



