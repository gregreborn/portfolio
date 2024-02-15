import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/player_bloc/player_bloc.dart';
import '../bloc/player_bloc/player_state.dart';
import '../models/player.dart';
import '../widgets/LoadingIndicator.dart';
import '../services/firebase_service.dart';
import '../widgets/PlayerStatTile.dart';
import '../widgets/CustomAppBar.dart'; // Import CustomAppBar widget

class PlayerProfileScreen extends StatelessWidget {
  final String? playerIdentifier;
  final FirebaseService firebaseService = FirebaseService();

  PlayerProfileScreen({Key? key, this.playerIdentifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Player Profile', // Title for the custom app bar
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
                      Container(
                        margin: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(snapshot.data!),
                        ),
                      ),
                      PlayerStatTile(statLabel: 'Name', statValue: player.name),
                      PlayerStatTile(statLabel: 'Level', statValue: '${player.level}'),
                      PlayerStatTile(statLabel: 'Games', statValue: '${player.games}'),
                      PlayerStatTile(statLabel: 'Wins', statValue: '${player.wins}'),
                      const SizedBox(height: 16.0), // Add space between stats and highest level legend
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Highest Level Legend',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                            PlayerStatTile(statLabel: highestLevelLegend.legendNameKey, statValue: 'Level ${highestLevelLegend.level}'),
                            PlayerStatTile(statLabel: 'Legend XP', statValue: '${highestLevelLegend.xp}'),
                            PlayerStatTile(statLabel: 'Match Time', statValue: '${highestLevelLegend.matchTime} seconds'),
                            PlayerStatTile(statLabel: 'Games', statValue: '${highestLevelLegend.games}'),
                            PlayerStatTile(statLabel: 'Wins', statValue: '${highestLevelLegend.wins}'),
                          ],
                        ),
                      ),
                    ],
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
