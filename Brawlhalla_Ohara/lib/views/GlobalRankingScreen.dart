import 'package:brawlhalla_ohara/widgets/LoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/data_bloc/data_bloc.dart';
import '../bloc/data_bloc/data_event.dart';
import '../bloc/data_bloc/data_state.dart';
import '../models/data.dart';
import '../utils/routes.dart';
import '../widgets/CustomNavBar.dart';
import '../widgets/RankListItem.dart';

class GlobalRankingScreen extends StatefulWidget {
  const GlobalRankingScreen({Key? key}) : super(key: key);

  @override
  _GlobalRankingScreenState createState() => _GlobalRankingScreenState();
}

class _GlobalRankingScreenState extends State<GlobalRankingScreen> {
  bool is1v1Selected = true;
  String currentRegion = 'us-e';

  @override
  void initState() {
    super.initState();
    context.read<DataBloc>().add(Fetch1v1DataEvent('us-e'));
  }


  void _toggleRankingType() {
    setState(() {
      is1v1Selected = !is1v1Selected;
    });
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
        title: const Text('Rankings'),
    actions: [
      Text(is1v1Selected ? '1v1' : '2v2'),
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
        return const Center(child: LoadingIndicator());
      } else if (state is Data1v1Loaded) {
        // Display 1v1 ranking data
        return ListView.builder(
          itemCount: state.rankings1v1.length,
          itemBuilder: (context, index) {
            final ranking = state.rankings1v1[index];
            String winLoss = "${ranking.wins}";
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
            String winLoss = "${ranking.wins}";
            return RankListItem(
              rank: ranking.rank,
              playerName: ranking.teamName,
              winLoss: winLoss,
              seasonRating: ranking.rating,
              onTap: () => _showTeamPlayersOptions(context, ranking),
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

  void _showTeamPlayersOptions(BuildContext context, Ranking2v2 ranking) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('Player One: ${ranking.brawlhallaIdOne}'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  RouteNames.home,
                  arguments: ranking.brawlhallaIdOne.toString(),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('Player Two: ${ranking.brawlhallaIdTwo}'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  RouteNames.home,
                  arguments: ranking.brawlhallaIdTwo.toString(),
                );
              },
            ),
          ],
        );
      },
    );
  }


}
