import 'dart:convert';
import 'package:betting_app/src/business_logic/models/fixture/date.dart';
import 'package:betting_app/src/business_logic/models/standings/goals.dart';
import 'package:betting_app/src/business_logic/services/http_request.dart';

import '../../models/coverage.dart';
import '../../models/fixture/coach.dart';
import '../../models/fixture/event.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import '../../models/fixture/game.dart';
import '../../models/fixture/lineup.dart';
import '../../models/fixture/player.dart';
import '../../models/standings/rank.dart';
import '../../models/standings/standings.dart';

import '../../../../main.dart';
import 'package:http/http.dart' as http;
import '../../models/fixture/league.dart';
import '../../models/fixture/status.dart';
import '../../models/fixture/team.dart';
import '../../models/fixture/venue.dart';
import '../../models/standings/stats.dart';

class Assistant {
  static Future<List<Game>> getGames(String url) async {
    List<Game> gamesList = [];

    var games = await HttpRequest.getData(url);

    for (var game in games) {
      try {
        var short = game['fixture']['status']['short'] ?? "";

        // if (short != 'PST' && short != 'CANC') {
          var long = game['fixture']['status']['long'] ?? "";
          var time = game['fixture']['status']['elapsed'] ?? 0;
          var referee = game['fixture']['referee'] ?? "";

          var kickOffTime =
              DateFormat.Hm().format(DateTime.parse(game['fixture']['date']));

          String kickOff = DateFormat('dd.MM.yyyy ' + kickOffTime)
              .format(DateTime.parse(game['fixture']['date']));

          DateTime date = DateTime.parse(game['fixture']['date']);

          var year = int.parse(DateFormat('yyyy')
              .format(DateTime.parse(game['fixture']['date'])));
          var month = int.parse(
              DateFormat('MM').format(DateTime.parse(game['fixture']['date'])));
          var day = int.parse(
              DateFormat('dd').format(DateTime.parse(game['fixture']['date'])));

          var fixtureDate = Date(date, year, month, day, kickOffTime);

          var homeTeam = game['teams']['home']['name'] ?? "";
          var awayTeam = game['teams']['away']['name'] ?? "";
          var leagueCountry = game['league']['country'] ?? "";
          var leagueName = game['league']['name'] ?? "";
          var htHomeGoals = game['score']['halftime']['home'] ?? "";
          var htAwayGoals = game['score']['halftime']['away'] ?? "";
          var htTotalGoals = htHomeGoals + htAwayGoals;
          var redCards = 0;
          var homeId = game['teams']['home']['id'].toString();
          var awayId = game['teams']['away']['id'].toString();
          var fixtureId = game['fixture']['id'].toString();
          var totalHomeGoals = game['goals']['home'] ?? 0;
          var totalAwayGoals = game['goals']['away'] ?? 0;

          var venueName = game['fixture']['venue']['name'];
          var venueCity = game['fixture']['venue']['city'];
          Venue venue = Venue(venueName, venueCity);

          var round = game['league']['round'];

          var countryLogo = game['league']['flag'] ?? "";
          var leagueLogo = game['league']['logo'] ?? "";
          var homeLogo = game['teams']['home']['logo'] ?? "";
          var awayLogo = game['teams']['away']['logo'] ?? "";
          var homeWinner = game['teams']['home']['winner'];
          var awayWinner = game['teams']['away']['winner'];

          var home = Team(homeId, homeTeam, homeLogo, homeWinner);
          var away = Team(awayId, awayTeam, awayLogo, awayWinner);

          var leagueId = game['league']['id'].toString();
          var season = game['league']['season'].toString();

          var status = Status(long, short, time);

          var league = League(
            leagueId,
            leagueName,
            leagueCountry,
            leagueLogo,
            countryLogo,
            season,
            round,
          );

          var fixture = Game(fixtureId, referee, totalHomeGoals, totalAwayGoals,
              home, away, fixtureDate, venue, league, status);

          gamesList.add(fixture);
        // }
      } catch (e, stacktrace) {
        print(e);
        print('Stacktrace: ' + stacktrace.toString());
      }
    }

    return gamesList;
  }

  static Future<List> getAllGames(String date) async {
    var games = await getGames('fixtures?date=$date');
    games.sort((a, b) => a.league.country.compareTo(b.league.country));

    return groupGames(games);
  }

  static Future<List<Game>> getLiveGames() async {
    var liveGamesList = await getGames('fixtures?live=all');
    liveGamesList.sort((b, a) => a.status.elapsed.compareTo(b.status.elapsed));

    return liveGamesList;
  }

  static Future<List<Event>> getEvents(Game game) async {
    List events =
        await HttpRequest.getData('fixtures/events?fixture=${game.fixtureId}');

    try {
      List<Event> eventsList = [];

      for (var event in events) {
        var time = event['time']['elapsed'];

        var homeOrAway =
            event['team']['id'].toString() == game.home.id ? "home" : "away";

        var half =
            time <= 45 ? '1ST HALF' : (time <= 90 ? '2ND HALF' : 'EXTRA TIME');

        var type = event['type'];
        var detail = event['detail'];
        var player = event['player']['name'];
        var assister = event['assist']['name'];
        var extra = event['time']['extra'];

        if (player != null || type == 'Goal') {
          eventsList.add(Event(
              half, player, type, detail, assister, homeOrAway, time, extra));
        }
      }

      return eventsList;
    } catch (e, stacktrace) {
      print(e);
      print('Stacktrace: ' + stacktrace.toString());
    }

    return [];
  }

  static Future<List<double>> getOdds(String fixtureId) async {
    try {
      var response = await HttpRequest.getData('odds?fixture=$fixtureId&bet=1');

      var oddsResponse = response[0]['bookmakers'][0]['bets'][0]['values'];

      print(oddsResponse);

      var homeOdds = double.parse(oddsResponse[0]['odd']);
      var awayOdds = double.parse(oddsResponse[2]['odd']);

      return [homeOdds, awayOdds];
    } catch (e, stacktrace) {
      print('Exception: ' + e.toString());
      print('Stacktrace: ' + stacktrace.toString());
      return [];
    }
  }

  Future<List<double>> getForm(
      String teamId, String leagueId, String season) async {
    try {
      var url =
          'https://api-football-v1.p.rapidapi.com/v3/fixtures?league=$leagueId&team=$teamId&season=$season&last=6';
      var response = await http.get(Uri.parse(url), headers: headers);
      var formResponse = json.decode(response.body)['response'];
      formResponse.removeAt(0);

      var goalsFor = 0;
      var goalsAgainst = 0;

      for (var i = 0; i < formResponse.length; i++) {
        var homeId = formResponse[i]['teams']['home']['id'];
        var awayId = formResponse[i]['teams']['away']['id'];
        var homeGoals = int.parse(formResponse[i]['goals']['home']);
        var awayGoals = int.parse(formResponse[i]['goals']['away']);

        if (homeId == teamId) {
          goalsFor += homeGoals;
          goalsAgainst += awayGoals;
        }

        if (awayId == teamId) {
          goalsFor += awayGoals;
          goalsAgainst += homeGoals;
        }
      }

      var avgGoals = (goalsFor + goalsAgainst) / formResponse.length;
      return [
        double.parse(goalsFor.toStringAsFixed(2)),
        double.parse(goalsAgainst.toStringAsFixed(2)),
        double.parse(avgGoals.toStringAsFixed(2))
      ];
    } catch (e, stacktrace) {
      print('Exception: ' + e.toString());
      print('Stacktrace: ' + stacktrace.toString());
      return [];
    }
  }

  static List groupGames(List<Game> games) {
    final groups = groupBy(games, (Game g) {
      return ('${g.league.country},${g.league.name}(${g.league.flag})${g.league.logo}');
    });

    var games2 = [];

    groups.forEach((key, value) {
      var country = key.substring(0, key.indexOf(','));
      var league = key.substring(country.length + 1, key.indexOf('('));
      var countryLogo = key.substring(key.indexOf('(') + 1, key.indexOf(')'));
      var leagueLogo = key.substring(key.indexOf(')') + 1, key.length);
      var liveGames = value
          .where((o) =>
              o.status.short == '1H' ||
              o.status.short == 'HT' ||
              o.status.short == '2H')
          .toList()
          .length;

      value.sort((a, b) => a.date.time.compareTo(b.date.time));

      games2.add({
        "country": country,
        "league": league,
        "countryLogo": countryLogo,
        "leagueLogo": leagueLogo,
        "games": value,
        "liveGames": liveGames
      });
    });

    return games2;
  }

  static Future<List<dynamic>> getH2H(Game game) async {
    List h2hGames = [];

    List urls = [
      "fixtures?status=FT&team=${game.home.id}&last=5",
      "fixtures?status=FT&team=${game.away.id}&last=5",
      'fixtures/headtohead?h2h=${game.home.id}-${game.away.id}&status=FT'
    ];

    for (var url in urls) {
      List<Game> teamGames = await getGames(url);
      teamGames.sort((b, a) => a.date.date.compareTo(b.date.date));

      h2hGames.add(teamGames);
    }

    return h2hGames;
  }

  static Future<Standings?> getStandings(Game game) async {
    List<Rank> leagueStandings = [];

    var response = await HttpRequest.getData(
        'standings?league=${game.league.id}&season=${game.league.season}');
    // var response = await HttpRequest.getData('standings?league=39&season=2019');

    if ((response as List).isEmpty) {
      return null;
    }

    var response2 = response[0]['league'];
    var leagueId = response2['id'].toString();
    var leagueName = response2['name'];
    var leagueCountry = response2['country'];
    var leagueLogo = response2['logo'];
    var leagueFlag = response2['flag'];
    var leagueSeason = response2['season'].toString();

    League league = League(leagueId, leagueName, leagueCountry, leagueLogo,
        leagueFlag, leagueSeason, '');

    for (var i in response2['standings'][0]) {
      try {
        var rankName = i['rank'];

        var teamId = i['team']['id'].toString();
        var teamName = i['team']['name'];
        var teamLogo = i['team']['logo'];

        var points = i['points'];
        var goalsDiff = i['goalsDiff'];
        var group = i['group'];
        var form = i['form'];
        var status = i['status'];
        var description = i['description'];

        var allPlayed = i['all']['played'];
        var allWin = i['all']['win'];
        var allDraw = i['all']['draw'];
        var allLose = i['all']['lose'];
        var allGoalsFor = i['all']['goals']['for'];
        var allGoalsAgainst = i['all']['goals']['against'];

        var homePlayed = i['home']['played'];
        var homeWin = i['home']['win'];
        var homeDraw = i['home']['draw'];
        var homeLose = i['home']['lose'];
        var homeGoalsFor = i['home']['goals']['for'];
        var homeGoalsAgainst = i['home']['goals']['against'];

        var awayPlayed = i['away']['played'];
        var awayWin = i['away']['win'];
        var awayDraw = i['away']['draw'];
        var awayLose = i['away']['lose'];
        var awayGoalsFor = i['away']['goals']['for'];
        var awayGoalsAgainst = i['away']['goals']['against'];

        Goals allGoals = Goals(allGoalsFor, allGoalsAgainst);
        Goals homeGoals = Goals(homeGoalsFor, homeGoalsAgainst);
        Goals awayGoals = Goals(awayGoalsFor, awayGoalsAgainst);

        Team team = Team(teamId, teamName, teamLogo, false);
        Stats all = Stats(allPlayed, allWin, allDraw, allLose, allGoals);
        Stats home = Stats(homePlayed, homeWin, homeDraw, homeLose, homeGoals);
        Stats away = Stats(awayPlayed, awayWin, awayDraw, awayLose, awayGoals);

        Rank rank = Rank(rankName, group, form, status, description, points,
            goalsDiff, team, all, home, away);

        leagueStandings.add(rank);
      } catch (e, stacktrace) {
        print(e);
        print('Stacktrace: ' + stacktrace.toString());
      }
    }

    return Standings(league, leagueStandings);
  }

  // static getLeagueStats() {
  //   print('here');
  //   FirebaseDatabase.instance.ref().once().then((event) {
  //     final dataSnapshot = event.snapshot;
  //
  //     if (dataSnapshot.value != null) {
  //       //update total number of trip counts to provider
  //       var keys = dataSnapshot.value;
  //       print(keys);
  //       // int tripCounter = keys.length;
  //
  //       //update trip keys to provider
  //       // List<String> tripHistoryKeys = [];
  //       // keys.forEach((key, value) {
  //       //   tripHistoryKeys.add(key);
  //       // });
  //     }
  //   });
  // }

  static Future<Coverage> getCoverage(Game game) async {
    var response = (await HttpRequest.getData(
            'leagues?id=${game.league.id}&season=${game.league.season}'))[0]
        ['seasons'][0]['coverage'];

    bool events = response['fixtures']['events'];
    bool lineups = response['fixtures']['lineups'];
    bool standings = response['standings'];
    bool odds = response['odds'];
    bool topScorers = response['top_scorers'];
    bool topAssists = response['top_assist'];

    return Coverage(events, lineups, standings, odds, topScorers, topAssists);
  }

  static Future<List<Lineup>> getLineups(String fixtureId) async {
    List<Lineup> lineUps = [];
    var response =
        await HttpRequest.getData('fixtures/lineups?fixture=$fixtureId');

    for (var i in response) {
      List<Player> startXI = [];
      List<Player> subs = [];

      var coach = Coach(i['coach']['id'].toString(), i['coach']['name']);

      var team = Team(i['team']['id'].toString(), i['team']['name'],
          i['team']['logo'], false);

      for (var a in i['startXI']) {
        Player player = Player(
            a['player']['id'].toString(),
            a['player']['name'],
            a['player']['number'].toString(),
            a['player']['pos']);
        startXI.add(player);
      }
      for (var a in i['substitutes']) {
        Player player = Player(
            a['player']['id'].toString(),
            a['player']['name'],
            a['player']['number'].toString(),
            a['player']['pos']);
        subs.add(player);
      }

      lineUps.add(Lineup(team, startXI, subs, coach));
    }

    return lineUps;
  }


  static Future<List<Game>> getLeagueGames(League league) async {
    var games = await getGames('fixtures?league=${league.id}&season=${league.season}');

    return games;
  }

}
