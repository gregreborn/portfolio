import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/data_bloc/data_bloc.dart';
import '../bloc/data_bloc/data_event.dart';
import '../bloc/data_bloc/data_state.dart';
import '../widgets/CustomNavBar.dart';
import '../widgets/RankListItem.dart';

class MetaAnalysisScreen extends StatefulWidget {
  const MetaAnalysisScreen({Key? key}) : super(key: key);

  @override
  _MetaAnalysisScreenState createState() => _MetaAnalysisScreenState();
}

class _MetaAnalysisScreenState extends State<MetaAnalysisScreen> {
  bool is1v1Selected = true; // To track if 1v1 or 2v2 is selected

  @override
  void initState() {
    super.initState();
    // Automatically fetch 1v1 data when the screen is loaded
    context.read<DataBloc>().add(Fetch1v1DataEvent());
  }

  void _toggleRankingType() {
    setState(() {
      is1v1Selected = !is1v1Selected;
      if (is1v1Selected) {
        context.read<DataBloc>().add(Fetch1v1DataEvent());
      } else {
        context.read<DataBloc>().add(Fetch2v2DataEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meta Analysis'),
        actions: [
          IconButton(
            icon: Icon(is1v1Selected ? Icons.person : Icons.people),
            onPressed: _toggleRankingType,
          ),
        ],
      ),
      body: BlocBuilder<DataBloc, DataState>(
        builder: (context, state) {
          if (state is DataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Data1v1Loaded) {
            // Inside Data1v1Loaded state
            return // Inside MetaAnalysisScreen's BlocBuilder
              ListView.builder(
                itemCount: state.rankings1v1.length,
                itemBuilder: (context, index) {
                  final ranking = state.rankings1v1[index];
                  // Assuming you have wins and losses data available
                  String winLoss = "${ranking.wins}";
                  return RankListItem(
                    rank: ranking.rank,
                    playerName: ranking.name,
                    winLoss: winLoss,
                    seasonRating: ranking.rating,
                  );
                },
              );


          } else if (state is Data2v2Loaded) {
            // Display 2v2 ranking data
            // Inside Data2v2Loaded state
            return ListView.builder(
                itemCount: state.rankings2v2.length,
                itemBuilder: (context, index) {
                  final ranking = state.rankings2v2[index];
                  // Assuming you have wins and losses data available
                  String winLoss = "${ranking.wins}";
                  return RankListItem(
                    rank: ranking.rank,
                    playerName: ranking.teamName,
                    winLoss: winLoss,
                    seasonRating: ranking.rating,
                  );
                },
              );



          } else if (state is DataError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Select a ranking type.'));
        },
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }
}
