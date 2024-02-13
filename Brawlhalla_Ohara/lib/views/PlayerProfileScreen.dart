import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brawlhalla_ohara/bloc/player_bloc/player_bloc.dart';
import 'package:brawlhalla_ohara/bloc/player_bloc/player_event.dart';
import 'package:brawlhalla_ohara/bloc/player_bloc/player_state.dart';

class PlayerProfileScreen extends StatelessWidget {
  final int brawlhallaId;

  const PlayerProfileScreen({Key? key, required this.brawlhallaId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayerBloc()..add(PlayerFetchRequested(brawlhallaId)),
      child: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is PlayerLoadInProgress) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PlayerLoadSuccess) {
            return Text('Player Name: ${state.player.name}');
            // Customize with actual player details
          } else if (state is PlayerLoadFailure) {
            return Center(child: Text('Failed to load player data'));
          } else {
            return Container(); // Fallback for unhandled states
          }
        },
      ),
    );
  }
}
