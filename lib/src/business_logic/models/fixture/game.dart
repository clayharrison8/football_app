import 'package:betting_app/src/business_logic/models/fixture/status.dart';
import 'package:betting_app/src/business_logic/models/fixture/team.dart';
import 'package:betting_app/src/business_logic/models/fixture/venue.dart';
import 'league.dart';
import 'date.dart';

class Game {
  String fixtureId, referee;
  int totalHomeGoals, totalAwayGoals;
  Venue venue;
  League league;
  Status status;
  Team home, away;
  Date date;

  Game(
      this.fixtureId,
      this.referee,
      this.totalHomeGoals,
      this.totalAwayGoals,
      this.home,
      this.away,
      this.date,
      this.venue,
      this.league,
      this.status);
}
