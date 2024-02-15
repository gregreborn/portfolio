import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/player_bloc/player_bloc.dart';
import '../bloc/player_bloc/player_state.dart';
import '../widgets/LoadingIndicator.dart';

class PlayerProfileScreen extends StatelessWidget {
  final String? playerIdentifier; // Can be brawlhallaId, steamId, or steamUrl

  const PlayerProfileScreen({Key? key, this.playerIdentifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assuming the necessary fetching logic is handled prior to navigation
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Profile'),
      ),
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is PlayerLoading) {
            return LoadingIndicator();
          } else if (state is PlayerLoaded) {
            return ListView(
              children: <Widget>[
                ListTile(
                  title: const Text('Name'),
                  subtitle: Text(state.player.name),
                ),
                // Add more ListTiles for other player attributes
              ],
            );
          } else if (state is PlayerError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }
          return const Center(child: Text('Enter a valid ID to view profile.')); // For uninitialized or invalid state
        },
      ),
    );
  }
}
