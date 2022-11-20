import 'package:betting_app/src/business_logic/models/fixture/lineup.dart';
import 'package:betting_app/src/views/ui/league_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../business_logic/models/standings/standings.dart';
import '../../business_logic/services/api_services/assistant.dart';
import '../../business_logic/models/fixture/game.dart';
import '../../business_logic/models/fixture/event.dart';
import '../utils/eventsTab.dart';
import '../utils/h2hTab.dart';
import '../utils/lineupsTab.dart';
import '../utils/standingsTab.dart';

class GameDetails extends StatefulWidget {
  final Game gameInfo;

  const GameDetails(this.gameInfo, {Key? key}) : super(key: key);

  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {
  late Future<Standings?> standings;
  late List<Event> events;
  late Future<List<Lineup>> lineups;
  late List h2h;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    standings = Assistant.getStandings(widget.gameInfo);
    lineups = Assistant.getLineups(widget.gameInfo.fixtureId);

    lineups.then((value) => print(value.length));
    // Future.delayed(Duration.zero,() async {
    //   standings = await Assistant.getStandings(widget.gameInfo);
    //   events = await Assistant.getEvents(widget.gameInfo);
    //   lineups = await Assistant.getLineups(widget.gameInfo.fixtureId);
    //   h2h = await Assistant.getH2H(widget.gameInfo);
    // });


    // Assistant.getOdds(widget.gameInfo.fixtureId);
  }

  @override
  Widget build(BuildContext context) {
    var gameLive = widget.gameInfo.status.short == '1H' ||
        widget.gameInfo.status.short == 'HT' ||
        widget.gameInfo.status.short == '2H';
    Color textColours = gameLive ? Colors.red : Colors.black;
    var score = widget.gameInfo.status.short == 'NS'
        ? '-'
        : widget.gameInfo.totalHomeGoals.toString() +
            '-' +
            widget.gameInfo.totalAwayGoals.toString();
    var status = "";
    if (widget.gameInfo.status.short == '1H') {
      status = '1st Half';
    } else if (widget.gameInfo.status.short == 'HT') {
      status = 'Half Time';
    } else {
      status = '2nd Half';
    }

    List tabs = ['SUMMARY', 'LINEUPS', 'ODDS', 'H2H', 'STANDING'];

    List<Tab> tabsList = [];

    List<Widget> tabViews = [
      eventsTab(widget.gameInfo),
      lineupsTab(widget.gameInfo, lineups),
      const Text('Odds'),
      h2hTab(widget.gameInfo),
      standingsTab(widget.gameInfo, standings)
    ];

    //
    // print(standings)
    // standings.then((value) {
    //   print(value.standings);
    //   if (value.standings.length == 0) {
    //     print('standing empty');
    //
    //     int index = tabs.indexWhere((item) => item == 'STANDINGS');
    //     print(index);
    //
    //     tabs.removeAt(index);
    //     tabViews.removeAt(index);
    //   }
    //
    // });
    //
    // lineups.then((value) {
    //   print(value);
    //   if (value.isEmpty) {
    //     print('line empty');
    //     int index = tabs.indexWhere((item) => item == 'LINEUPS');
    //     print(index);
    //
    //     tabs.removeAt(index);
    //     tabViews.removeAt(index);
    //
    //     print(tabs);
    //   }
    //
    // });

    for (var i in tabs) {
      tabsList.add(
        Tab(
          child: Text(i, style: const TextStyle(fontSize: 12),),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(
              Icons.sports_soccer,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text('Football'),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: DefaultTabController(
        length: tabs.length,
        initialIndex: 0,
        child: Scaffold(
          body: Column(
            children: [
              Container(
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => LeagueDetails(widget.gameInfo.league,widget.gameInfo, standings),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.network(
                                  widget.gameInfo.league.flag,
                                  width: 15,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  widget.gameInfo.league.country.toUpperCase() +
                                      ': ',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ),
                                Text(
                                      widget.gameInfo.league.name.toUpperCase() +
                                      ' - ' +
                                      widget.gameInfo.league.round.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 20,)
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 10,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              teamLogo(widget.gameInfo.home.logo),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              children: [
                                Text(
                                  '${widget.gameInfo.date.day.toString()}.${widget.gameInfo.date.month.toString()}.${widget.gameInfo.date.year.toString()} ${widget.gameInfo.date.time}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  score,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: textColours,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                gameStatus(widget.gameInfo, gameLive, status,
                                    textColours),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              teamLogo(widget.gameInfo.away.logo),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.gameInfo.home.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                          Text(
                            widget.gameInfo.away.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TabBar(
                  indicatorColor: Colors.red,
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.red,
                  isScrollable: true,
                  tabs: [...tabsList],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                 ...tabViews
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget header(String header) {
  return Container(
    width: double.infinity,
    color: Colors.grey[300],
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8, 5, 0, 5),
      child: Text(
        header,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 15, color: Colors.grey[30], fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget teamLogo(String logo) {
  return Container(
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white),
    padding: const EdgeInsets.all(8),
    child: Image.network(
      logo,
      width: 50,
    ),
  );
}

Widget gameStatus(Game game, gameLive, status, textColours) {
  if (gameLive) {
    return Text(
      status +
          (game.status.short != 'HT'
              ? ' - ' + game.status.elapsed.toString() + "'"
              : ''),
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: textColours, fontSize: 12, fontWeight: FontWeight.bold),
    );
  } else {
    if (game.status.short == 'FT') {
      return const Text('Finished');
    } else {
      return const Text('');
    }
  }
}
