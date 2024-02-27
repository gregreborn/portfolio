import 'package:equatable/equatable.dart';

abstract class DataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Fetch1v1DataEvent extends DataEvent {}

class Fetch2v2DataEvent extends DataEvent {}
