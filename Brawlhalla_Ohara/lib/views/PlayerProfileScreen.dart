import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/player_bloc/player_bloc.dart';
import '../bloc/player_bloc/player_state.dart';
import '../models/player.dart';
import '../widgets/LoadingIndicator.dart';
import '../services/firebase_service.dart';

class PlayerProfileScreen extends StatelessWidget {
  final String? playerIdentifier;
  final FirebaseService firebaseService = FirebaseService();

  PlayerProfileScreen({Key? key, this.playerIdentifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Profile'),
      ),
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is PlayerLoading) {
            return LoadingIndicator();
          } else if (state is PlayerLoaded) {
            final player = state.player;
            final highestLevelLegend = player.legends.reduce((current, next) => current.level > next.level ? current : next);

            return FutureBuilder<String>(
              future: firebaseService.getImageUrl('${highestLevelLegend.legendNameKey}.png'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return ListView(
                    children: [
                      Image.network(snapshot.data!),
                      ListTile(
                        title: const Text('Name'),
                        subtitle: Text(player.name),
                      ),
                      ListTile(
                        title: const Text('Level'),
                        subtitle: Text('${player.level}'),
                      ),
                      ListTile(
                        title: const Text('Games'),
                        subtitle: Text('${player.games}'),
                      ),
                      ListTile(
                        title: const Text('Wins'),
                        subtitle: Text('${player.wins}'),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Highest Level Legend'),
                        subtitle: Text('${highestLevelLegend.legendNameKey} (Level ${highestLevelLegend.level})'),
                      ),
                      ListTile(
                        title: const Text('Legend XP'),
                        subtitle: Text('${highestLevelLegend.xp}'),
                      ),
                      ListTile(
                        title: const Text('Match Time'),
                        subtitle: Text('${highestLevelLegend.matchTime} seconds'),
                      ),
                      ListTile(
                        title: const Text('Games'),
                        subtitle: Text('${highestLevelLegend.games}'),
                      ),
                      ListTile(
                        title: const Text('Wins'),
                        subtitle: Text('${highestLevelLegend.wins}'),
                      ),                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingIndicator();
                } else {
                  return const Center(child: Text('Failed to load legend image'));
                }
              },
            );
          } else if (state is PlayerError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Enter a valid ID to view profile.'));
        },
      ),
    );
  }
}
