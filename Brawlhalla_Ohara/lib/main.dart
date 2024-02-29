import 'package:brawlhalla_ohara/repository/data_repository.dart';
import 'package:brawlhalla_ohara/repository/player_repository.dart';
import 'package:brawlhalla_ohara/services/api_service.dart';
import 'package:brawlhalla_ohara/utils/bloc_observer.dart';
import 'package:brawlhalla_ohara/utils/routes.dart';
import 'package:brawlhalla_ohara/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/data_bloc/data_bloc.dart';
import 'bloc/data_bloc/data_event.dart';
import 'bloc/player_bloc/player_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  ApiService apiService = ApiService();
  PlayerRepository playerRepository = PlayerRepository(apiService);
  DataRepository dataRepository = DataRepository(apiService);

  Bloc.observer = SimpleBlocObserver();

  const defaultRegion = 'us-e';

  runApp(MyApp(playerRepository: playerRepository, dataRepository: dataRepository, defaultRegion: defaultRegion));
}

class MyApp extends StatelessWidget {
  final PlayerRepository playerRepository;
  final DataRepository dataRepository;
  final String defaultRegion;

  const MyApp({
    Key? key,
    required this.playerRepository,
    required this.dataRepository,
    required this.defaultRegion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: playerRepository),
        RepositoryProvider.value(value: dataRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => PlayerBloc(playerRepository)),
          BlocProvider(
            create: (context) => DataBloc(dataRepository)
              ..add(Fetch1v1DataEvent(defaultRegion)),
          ),
        ],
        child: MaterialApp(
          title: 'Brawlhalla Ohara',
          theme: AppTheme.darkTheme,
          initialRoute: RouteNames.home,
          onGenerateRoute: AppRoutes.generateRoute,
        ),
      ),
    );
  }
}
