import 'package:betting_app/src/business_logic/models/fixture/team.dart';
import 'package:betting_app/src/business_logic/models/standings/stats.dart';

class Rank {
  String group, form, status, description;
  int position, points, goalsDiff;
  Team team;
  Stats all, home, away;

  Rank(this.position, this.group, this.form, this.status, this.description,
      this.points, this.goalsDiff, this.team, this.all, this.home, this.away);
}
