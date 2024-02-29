import 'package:flutter/material.dart';
import 'package:brawlhalla_ohara/views/HomeScreen.dart';
import 'package:brawlhalla_ohara/views/PlayerProfileScreen.dart';
import 'package:brawlhalla_ohara/views/LegendDetailScreen.dart';
import 'package:brawlhalla_ohara/views/PlayerRankingsScreen.dart';
import 'package:brawlhalla_ohara/views/MetaAnalysisScreen.dart';
import 'package:brawlhalla_ohara/views/SettingsScreen.dart';

class RouteNames {
  static const String home = '/';
  static const String playerProfile = '/playerProfile';
  static const String legendDetail = '/legendDetail';
  static const String rankings = '/rankings';
  static const String metaAnalysis = '/metaAnalysis';
  static const String clanDetails = '/clanDetails';
}

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        final initialBrawlhallaId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => HomeScreen(initialBrawlhallaId: initialBrawlhallaId),
        );
      case RouteNames.playerProfile:
        final playerId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => PlayerProfileScreen(playerIdentifier: playerId),
        );
      case RouteNames.metaAnalysis:
    return MaterialPageRoute(builder: (_) => const MetaAnalysisScreen());
    /*case RouteNames.legendDetail:
        return MaterialPageRoute(builder: (_) => LegendDetailScreen(legendId: settings.arguments as int));
      case RouteNames.rankings:
        return MaterialPageRoute(builder: (_) => RankingsScreen());

      case RouteNames.clanDetails:
        return MaterialPageRoute(builder: (_) => SettingsScreen());*/
      default:
        return _errorRoute("Error");
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(message),
        ),
      );
    });
  }
}
