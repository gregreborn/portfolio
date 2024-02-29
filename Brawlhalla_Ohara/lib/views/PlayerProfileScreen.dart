import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/player_bloc/player_bloc.dart';
import '../bloc/player_bloc/player_state.dart';
import '../models/player.dart';
import '../widgets/CustomNavBar.dart';
import '../widgets/LoadingIndicator.dart';
import '../services/firebase_service.dart';
import '../widgets/PlayerStatTile.dart';
import 'PlayerRankingsScreen.dart';

class PlayerProfileScreen extends StatefulWidget {
  final String? playerIdentifier;

  const PlayerProfileScreen({super.key, this.playerIdentifier});

  @override
  _PlayerProfileScreenState createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Profile'),
      ),
      drawer: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is PlayerLoaded) {
            return RankingsScreen(rankedData: state.rankingData);
          }
          return Drawer(child: Container());
        },
      ),
      body: BlocConsumer<PlayerBloc, PlayerState>(
        listener: (context, state) {
          if (state is PlayerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is PlayerLoading) {
            return const LoadingIndicator();
          } else if (state is PlayerLoaded) {
            return _buildPlayerProfile(state.playerData);
          } else {
            return const Center(child: Text('Enter a valid ID to view profile.'));
          }
        },
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }

  Widget _buildPlayerProfile(Player player) {
    LegendStat? highestLevelLegend;
    if (player.legends.isNotEmpty) {
      final nonNullLevelLegends = player.legends.where((legend) => legend.level != null).toList();
      if (nonNullLevelLegends.isNotEmpty) {
        highestLevelLegend = nonNullLevelLegends.reduce((current, next) => (current.level ?? 0) > (next.level ?? 0) ? current : next);
      }
    }

    return FutureBuilder<String>(
      future: firebaseService.getImageUrl('${highestLevelLegend?.legendNameKey}.png'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
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
              const SizedBox(height: 16.0),
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
                    PlayerStatTile(statLabel: highestLevelLegend!.legendNameKey, statValue: 'Level ${highestLevelLegend.level}'),
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
          return const LoadingIndicator();
        } else {
          return const Center(child: Text('Failed to load legend image'));
        }
      },
    );
  }

}

