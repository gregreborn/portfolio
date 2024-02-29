import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/data_bloc/data_bloc.dart';
import '../bloc/data_bloc/data_event.dart';
import '../bloc/data_bloc/data_state.dart';
import '../utils/routes.dart';
import '../widgets/CustomNavBar.dart';
import '../widgets/RankListItem.dart';

class MetaAnalysisScreen extends StatefulWidget {
  const MetaAnalysisScreen({Key? key}) : super(key: key);

  @override
  _MetaAnalysisScreenState createState() => _MetaAnalysisScreenState();
}

class _MetaAnalysisScreenState extends State<MetaAnalysisScreen> {
  bool is1v1Selected = true;
  String currentRegion = 'us-e'; // Default region

  @override
  void initState() {
    super.initState();
    // Fetch initial data with default region
    context.read<DataBloc>().add(Fetch1v1DataEvent('us-e'));
  }


  void _toggleRankingType() {
    setState(() {
      is1v1Selected = !is1v1Selected;
    });
    // Fetch data for the current selection and region
    if (is1v1Selected) {
      context.read<DataBloc>().add(Fetch1v1DataEvent(currentRegion));
    } else {
      context.read<DataBloc>().add(Fetch2v2DataEvent(currentRegion));
    }
  }

  void _onRegionChanged(String? newRegion) {
    if (newRegion != null) {
      setState(() {
        currentRegion = newRegion;
      });
      // Fetch data for the new region
      if (is1v1Selected) {
        context.read<DataBloc>().add(Fetch1v1DataEvent(newRegion));
      } else {
        context.read<DataBloc>().add(Fetch2v2DataEvent(newRegion));
      }
    }
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
    DropdownButton<String>(
    value: currentRegion,
    onChanged: _onRegionChanged,
    items: <String>['us-e', 'us-w', 'eu', 'brz', 'aus', 'sea', 'jpn']
        .map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
    );
    }).toList(),
    ),
    ],
    ),
    body: BlocBuilder<DataBloc, DataState>(
    builder: (context, state) {
      if (state is DataLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is Data1v1Loaded) {
        // Display 1v1 ranking data
        return ListView.builder(
          itemCount: state.rankings1v1.length,
          itemBuilder: (context, index) {
            final ranking = state.rankings1v1[index];
            String winLoss = "${ranking.wins}"; // Example, adjust according to your data structure
            return RankListItem(
              rank: ranking.rank,
              playerName: ranking.name,
              winLoss: winLoss,
              seasonRating: ranking.rating,
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  RouteNames.home,
                  arguments: ranking.brawlhallaId.toString(),
                );
              },
            );
          },
        );
      } else if (state is Data2v2Loaded) {
        // Display 2v2 ranking data
        return ListView.builder(
          itemCount: state.rankings2v2.length,
          itemBuilder: (context, index) {
            final ranking = state.rankings2v2[index];
            String winLoss = "${ranking.wins}"; // Example, adjust according to your data structure
            return RankListItem(
              rank: ranking.rank,
              playerName: ranking.teamName, // Adjust if your model has a different field
              winLoss: winLoss,
              seasonRating: ranking.rating,
            );
          },
        );
      } else if (state is DataError) {
        return Center(child: Text('Error: ${state.message}'));
      }
      return const Center(child: Text('Select a ranking type and region.'));
    },
    ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }
}
