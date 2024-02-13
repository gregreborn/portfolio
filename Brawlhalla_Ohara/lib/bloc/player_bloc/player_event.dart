import 'package:equatable/equatable.dart';

abstract class PlayerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlayerLoad extends PlayerEvent {
  final int? brawlhallaId;
  final String? steamId;
  final String? steamUrl;

  PlayerLoad({this.brawlhallaId, this.steamId, this.steamUrl});

  @override
  List<Object?> get props => [brawlhallaId, steamId ?? '', steamUrl ?? ''];
}
