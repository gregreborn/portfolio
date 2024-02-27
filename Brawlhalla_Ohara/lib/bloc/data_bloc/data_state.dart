import 'package:equatable/equatable.dart';
import '../../models/data.dart';

abstract class DataState extends Equatable {
  @override
  List<Object> get props => [];
}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class Data1v1Loaded extends DataState {
  final List<Ranking> rankings1v1;
  Data1v1Loaded(this.rankings1v1);

  @override
  List<Object> get props => [rankings1v1];
}

class Data2v2Loaded extends DataState {
  final List<Ranking2v2> rankings2v2;
  Data2v2Loaded(this.rankings2v2);

  @override
  List<Object> get props => [rankings2v2];
}

class DataError extends DataState {
  final String message;
  DataError(this.message);

  @override
  List<Object> get props => [message];
}
