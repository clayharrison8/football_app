import 'package:betting_app/src/business_logic/models/fixture/player.dart';
import 'package:betting_app/src/business_logic/models/fixture/team.dart';

import 'coach.dart';

class Lineup {
  Team team;
  List<Player> startXI, subs;
  Coach coach;

  Lineup(this.team, this.startXI, this.subs, this.coach);
}
