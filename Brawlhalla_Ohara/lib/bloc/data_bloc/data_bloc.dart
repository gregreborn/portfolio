import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/data_repository.dart';
import 'data_event.dart';
import 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final DataRepository dataRepository;

  DataBloc(this.dataRepository) : super(DataInitial()) {
    on<Fetch1v1DataEvent>((event, emit) async {
      print('Fetching 1v1 Data...');
      emit(DataLoading());
      try {
        final rankings1v1 = await dataRepository.fetchRanked1v1Data("us-e", 1); // Adjust parameters as needed
        if (kDebugMode) {
          print('1v1 Data Fetched: ${rankings1v1.length} items');
        }
        emit(Data1v1Loaded(rankings1v1));
      } catch (e) {
        if (kDebugMode) {
          print('Error Fetching 1v1 Data: $e');
        }
        emit(DataError(e.toString()));
      }
    });

    on<Fetch2v2DataEvent>((event, emit) async {
      if (kDebugMode) {
        print('Fetching 2v2 Data...');
      }
      emit(DataLoading());
      try {
        final rankings2v2 = await dataRepository.fetchRanked2v2Data("us-e", 1); // Adjust parameters as needed
        if (kDebugMode) {
          print('2v2 Data Fetched: ${rankings2v2.length} items');
        }
        emit(Data2v2Loaded(rankings2v2));
      } catch (e) {
        print('Error Fetching 2v2 Data: $e');
        emit(DataError(e.toString()));
      }
    });
  }
}
