import 'package:equatable/equatable.dart';

abstract class DataEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Fetch1v1DataEvent extends DataEvent {
  final String region;

  Fetch1v1DataEvent(this.region);

  @override
  List<Object?> get props => [region];
}

class Fetch2v2DataEvent extends DataEvent {
  final String region;

  Fetch2v2DataEvent(this.region);

  @override
  List<Object?> get props => [region];
}
