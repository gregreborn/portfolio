import 'package:flutter/material.dart';
import 'package:brawlhalla_ohara/views/HomeScreen.dart';
import 'package:brawlhalla_ohara/views/PlayerProfileScreen.dart';
import 'package:brawlhalla_ohara/views/LegendDetailScreen.dart';
import 'package:brawlhalla_ohara/views/RankingsScreen.dart';
import 'package:brawlhalla_ohara/views/MetaAnalysisScreen.dart';
import 'package:brawlhalla_ohara/views/ClanDetailsScreen.dart';
import 'package:brawlhalla_ohara/views/SettingsScreen.dart';

class RouteNames {
  static const String home = '/';
  static const String playerProfile = '/playerProfile';
  static const String legendDetail = '/legendDetail';
  static const String rankings = '/rankings';
  static const String metaAnalysis = '/metaAnalysis';
  static const String clanDetails = '/clanDetails';
  static const String settings = '/settings';
}

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RouteNames.playerProfile:
        return MaterialPageRoute(builder: (_) => PlayerProfileScreen(brawlhallaId: settings.arguments as int));
      case RouteNames.legendDetail:
        return MaterialPageRoute(builder: (_) => LegendDetailScreen(legendId: settings.arguments as int));
      case RouteNames.rankings:
        return MaterialPageRoute(builder: (_) => RankingsScreen());
      case RouteNames.metaAnalysis:
        return MaterialPageRoute(builder: (_) => MetaAnalysisScreen());
      case RouteNames.clanDetails:
        return MaterialPageRoute(builder: (_) => ClanDetailsScreen(clanId: settings.arguments as int));
      case RouteNames.settings:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      default:
        return _errorRoute("Error");
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text(message),
        ),
      );
    });
  }
}