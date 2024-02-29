import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/player_bloc/player_bloc.dart';
import '../bloc/player_bloc/player_event.dart';
import '../bloc/player_bloc/player_state.dart';
import '../widgets/CustomAppBar.dart';
import '../widgets/CustomButton.dart';
import '../utils/routes.dart';
import 'package:video_player/video_player.dart';
import '../widgets/CustomNavBar.dart';
import '../widgets/LoadingIndicator.dart';


class HomeScreen extends StatefulWidget {
  final String? initialBrawlhallaId;

  const HomeScreen({Key? key, this.initialBrawlhallaId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final _brawlhallaIdController = TextEditingController();
  final _steamIdController = TextEditingController();
  final _steamUrlController = TextEditingController();
  late VideoPlayerController _controller;
  bool _isLoading = false; // Step 1: Add a loading state variable



  void _submitCredentials() {
    setState(() {
      _isLoading = true; // Step 2: Set loading to true when submitting
    });
    if (_brawlhallaIdController.text.isNotEmpty) {
      final id = int.tryParse(_brawlhallaIdController.text);
      if (id != null) {
        if (kDebugMode) {
          print('Submitting Brawlhalla ID: $id');
        }
        context.read<PlayerBloc>().add(FetchPlayerById(id));
      } else {
        _showSnackBar('Invalid Brawlhalla ID');
      }
    } else if (_steamIdController.text.isNotEmpty) {
      if (kDebugMode) {
        print('Submitting Steam ID: ${_steamIdController.text}');
      }
      context.read<PlayerBloc>().add(FetchPlayerBySteamId(_steamIdController.text));
    } else if (_steamUrlController.text.isNotEmpty) {
      if (kDebugMode) {
        print('Submitting Steam URL: ${_steamUrlController.text}');
      }
      context.read<PlayerBloc>().add(FetchPlayerBySteamUrl(_steamUrlController.text));
    } else {
      _showSnackBar('Please fill at least one of the fields: Brawlhalla ID, Steam ID, or Steam URL.');
      setState(() => _isLoading = false); // Reset loading state if input is invalid
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialBrawlhallaId != null) {
      _brawlhallaIdController.text = widget.initialBrawlhallaId!;
    }
    _controller = VideoPlayerController.asset('assets/video/homeVideo.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {}); // Update the UI when the video is initialized
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayerBloc, PlayerState>(
      listener: (context, state) {
        if (state is PlayerLoading) {
          setState(() => _isLoading = true);
        } else if (state is PlayerLoaded) {
          Navigator.of(context).pushNamed(RouteNames.playerProfile, arguments: state.playerData.brawlhallaId.toString());
          setState(() => _isLoading = false);
        } else if (state is PlayerError) {
          _showSnackBar('Error fetching player: ${state.message}');
          setState(() => _isLoading = false);
        }
      },
      child: Stack(
        children: [
          Scaffold(
            body: Column(
              children: [
                if (_controller.value.isInitialized)
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25.0),
                        bottomRight: Radius.circular(25.0),
                      ),
                      child: VideoPlayer(_controller),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Enter Your Details',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 8.0),
                        TextField(
                          controller: _brawlhallaIdController,
                          decoration: const InputDecoration(
                            labelText: 'Brawlhalla ID',
                            hintText: 'Enter your Brawlhalla ID',
                          ),
                          onChanged: (_) => _handleInput(_brawlhallaIdController),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _steamIdController,
                          decoration: const InputDecoration(
                            labelText: 'Steam ID',
                            hintText: 'Enter your Steam ID',
                          ),
                          onChanged: (_) => _handleInput(_steamIdController),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _steamUrlController,
                          decoration: const InputDecoration(
                            labelText: 'Steam URL',
                            hintText: 'Enter your Steam Profile URL',
                          ),
                          onChanged: (_) => _handleInput(_steamUrlController),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          label: 'Confirm',
                          onPressed: _submitCredentials,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: const CustomNavBar(),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const LoadingIndicator(),
              ),
            ),
        ],
      ),
    );
  }


  void _handleInput(TextEditingController controller) {
    // Disable other text fields when one starts being edited
    setState(() {
      if (controller == _brawlhallaIdController) {
        _steamIdController.clear();
        _steamUrlController.clear();
      } else if (controller == _steamIdController) {
        _brawlhallaIdController.clear();
        _steamUrlController.clear();
      } else if (controller == _steamUrlController) {
        _brawlhallaIdController.clear();
        _steamIdController.clear();
      }
    });
  }
}
