import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/data_repository.dart';
import 'data_event.dart';
import 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final DataRepository dataRepository;

  DataBloc(this.dataRepository) : super(DataInitial()) {
    // Inside DataBloc
    on<Fetch1v1DataEvent>((event, emit) async {
      if (kDebugMode) {
        print('Fetching 1v1 Data for region: ${event.region}');
      }
      emit(DataLoading());
      try {
        final rankings1v1 = await dataRepository.fetchRanked1v1Data(event.region, 1);
        emit(Data1v1Loaded(rankings1v1));
      } catch (e) {
        emit(DataError(e.toString()));
      }
    });

    on<Fetch2v2DataEvent>((event, emit) async {
      if (kDebugMode) {
        print('Fetching 2v2 Data for region: ${event.region}');
      }
      emit(DataLoading());
      try {
        final rankings2v2 = await dataRepository.fetchRanked2v2Data(event.region, 1);
        emit(Data2v2Loaded(rankings2v2));
      } catch (e) {
        emit(DataError(e.toString()));
      }
    });

  }
}
