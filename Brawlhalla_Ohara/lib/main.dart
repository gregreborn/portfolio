import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/player_bloc/player_bloc.dart';
import 'repository/player_repository.dart';
import 'services/api_service.dart';
import 'utils/bloc_observer.dart';
import 'utils/theme.dart';
import 'views/HomeScreen.dart';
//import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

  // Assuming ApiService requires no initial configuration
  ApiService apiService = ApiService();
  PlayerRepository playerRepository = PlayerRepository(apiService);

  Bloc.observer = SimpleBlocObserver();

  runApp(MyApp(playerRepository: playerRepository));
}

class MyApp extends StatelessWidget {
  final PlayerRepository playerRepository;

  const MyApp({Key? key, required this.playerRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: playerRepository,
      child: BlocProvider(
        create: (context) => PlayerBloc(playerRepository),
        child: MaterialApp(
          title: 'Brawlhalla Ohara',
          theme: AppTheme.darkTheme,
          home: HomeScreen(),
        ),
      ),
    );
  }
}

