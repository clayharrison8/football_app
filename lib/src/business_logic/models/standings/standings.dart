import 'package:betting_app/src/business_logic/models/standings/rank.dart';

import '../fixture/league.dart';

class Standings {
  League league;
  List<Rank> standings;

  Standings(
    this.league,
    this.standings,
  );
}
