import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/player_bloc/player_bloc.dart';
import '../bloc/player_bloc/player_event.dart';
import '../bloc/player_bloc/player_state.dart';
import '../widgets/CustomAppBar.dart';
import '../widgets/CustomButton.dart';
import '../utils/routes.dart'; // Import your routes utilities

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _brawlhallaIdController = TextEditingController();
  final _steamIdController = TextEditingController();
  final _steamUrlController = TextEditingController();

  void _submitCredentials() {
    if (_brawlhallaIdController.text.isNotEmpty) {
      context.read<PlayerBloc>().add(FetchPlayerById(int.parse(_brawlhallaIdController.text)));
    } else if (_steamIdController.text.isNotEmpty) {
      context.read<PlayerBloc>().add(FetchPlayerBySteamId(_steamIdController.text));
    } else if (_steamUrlController.text.isNotEmpty) {
      context.read<PlayerBloc>().add(FetchPlayerBySteamUrl(_steamUrlController.text));
    } else {
      // Consider showing a Snackbar or dialog to inform the user to fill in the fields
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill at least one of the fields: Brawlhalla ID, Steam ID, or Steam URL.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayerBloc, PlayerState>(
      listener: (context, state) {
        if (state is PlayerLoaded) {
          Navigator.of(context).pushNamed(
            RouteNames.playerProfile,
            arguments: state.player.brawlhallaId,
          );
        }
        // Handle error state if necessary
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'Enter Your Details'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _brawlhallaIdController,
                decoration: InputDecoration(
                  labelText: 'Brawlhalla ID',
                  hintText: 'Enter your Brawlhalla ID',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _steamIdController,
                decoration: InputDecoration(
                  labelText: 'Steam ID',
                  hintText: 'Enter your Steam ID',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _steamUrlController,
                decoration: InputDecoration(
                  labelText: 'Steam URL',
                  hintText: 'Enter your Steam Profile URL',
                ),
              ),
              SizedBox(height: 20),
              CustomButton(
                label: 'Submit',
                onPressed: _submitCredentials,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
