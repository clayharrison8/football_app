// import 'dart:convert';
// import '../../models/game/event.dart';
// import 'package:collection/collection.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:intl/intl.dart';
// import '../../models/game/game.dart';
// import '../../../../main.dart';
// import 'package:http/http.dart' as http;
//
// class Standings {
//   static getStandings(String league, String season) async {
//     List<Game> liveGamesList = [];
//     var url = 'https://api-football-v1.p.rapidapi.com/v3/standings?league=39&season=2019';
//     var response = await http.get(Uri.parse(url), headers: headers);
//
//     var games = json.decode(response.body)['response'];
//
//     for(var i = 0; i < games.length; i++){
//       try {
//         var short = games[i]['fixture']['status']['short'] ?? "";
//
//         var time = games[i]['fixture']['status']['elapsed'] ?? 0;
//         var kickOffTime = DateFormat.Hm().format(DateTime.parse(games[i]['fixture']['date']));
//         String kickOff = DateFormat('dd.MM.yyyy ' + kickOffTime).format(DateTime.parse(games[i]['fixture']['date']));
//
//         var homeTeam = games[i]['teams']['home']['name'] ?? "";
//         var awayTeam = games[i]['teams']['away']['name'] ?? "";
//         var fixture = games[i]['teams']['home']['name'] + ' v ' + games[i]['teams']['away']['name'] ?? "";
//         var country = games[i]['league']['country'] ?? "" ;
//         var league = games[i]['league']['name'] ?? "";
//
//         var countryLogo = games[i]['league']['flag'] ?? "";
//         var leagueLogo = games[i]['league']['logo'] ?? "";
//         var homeLogo = games[i]['teams']['home']['logo'] ?? "";
//         var awayLogo = games[i]['teams']['away']['logo'] ?? "";
//
//         var leagueId = games[i]['league']['id'] ?? "";
//
//         var homeId = games[i]['teams']['home']['id'].toString();
//         var awayId = games[i]['teams']['away']['id'].toString();
//         var fixtureId = games[i]['fixture']['id'].toString();
//         var season = games[i]['league']['season'] ?? "";
//
//         var totalHomeGoals = games[i]['goals']['home'] ?? 0;
//         var totalAwayGoals = games[i]['goals']['away'] ?? 0;
//         var totalGoals = totalHomeGoals + totalAwayGoals;
//
//         var htHomeGoals = games[i]['score']['halftime']['home'] ?? "";
//         var htAwayGoals = games[i]['score']['halftime']['away'] ?? "";
//         var htTotalGoals = htHomeGoals + htAwayGoals;
//         var redCards = 0;
//
//         List <GameEvent> eventsList = [];
//
//         var events = games[i]['events'];
//
//         if (events != null){
//           for (var e = 0; e < events.length; e++){
//             var time = events[e]['time']['elapsed'];
//             var homeOrAway = events[e]['team']['id'] == homeId ? "home" : "away";
//             var type = events[e]['type'];
//             var detail = events[e]['detail'];
//             var player = events[e]['player']['name'];
//             var assister = events[e]['assist']['name'];
//
//             var gameEvent = GameEvent(player, type, detail, assister, homeOrAway, time);
//
//             eventsList.add(gameEvent);
//           }
//
//           for (var a = 0; a < games[i]['events'].length; a++){
//             if (games[i]['events'][a]['detail'] == 'Red Card'){
//               redCards++;
//             }
//           }
//         }
//
//
//         // var homeForm = getForm(homeId, leagueId, season);
//         // var awayForm = getForm(awayId, leagueId, season);
//
//         // List<double> odds = await getOdds(fixtureId);
//         List<double> odds = [0.0, 0.0];
//
//         if (odds.isNotEmpty){
//
//           var game = Game(fixtureId, country, league, homeTeam, homeId, awayTeam, awayId, totalHomeGoals, totalAwayGoals, countryLogo, leagueLogo, homeLogo, awayLogo, time, short, kickOff, kickOffTime, eventsList);
//           liveGamesList.add(game);
//           // }
//         }
//
//
//       }
//       catch (e, stacktrace){
//         print(e);
//         print('Stacktrace: ' + stacktrace.toString());
//         // print('');
//
//       }
//     }
//     liveGamesList.sort((b, a) => a.time.compareTo(b.time));
//
//     return liveGamesList;
//   }
// }
