import 'package:betting_app/src/views/utils/line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../business_logic/models/fixture/league.dart';
import '../../business_logic/services/api_services/assistant.dart';
import '../utils/fixture.dart';
import '../utils/standingsTab.dart';
import '../../business_logic/models/fixture/game.dart';

class LeagueDetails extends StatefulWidget {
  final League league;
  final standings;
  final Game game;

  const LeagueDetails(this.league, this.game, this.standings, {Key? key})
      : super(key: key);

  @override
  State<LeagueDetails> createState() => _LeagueDetailsState();
}

class _LeagueDetailsState extends State<LeagueDetails> {
  @override
  Widget build(BuildContext context) {
    List tabs = ['STANDINGS', 'RESULTS', 'FIXTURES'];

    List<Tab> tabsList = [];

    List<Widget> tabViews = [
      standingsTab(widget.game, widget.standings),
      games(widget.game.league, true),
      games(widget.game.league, false),
    ];

    for (var i in tabs) {
      tabsList.add(
        Tab(
          child: Text(
            i,
            style: TextStyle(fontSize: 12),
          ),
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
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          SvgPicture.network(
                            widget.league.flag,
                            width: 15,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.league.country.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 10,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.white),
                            padding: EdgeInsets.all(8),
                            child: Image.network(
                              widget.league.logo,
                              width: 50,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.league.name,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(widget.league.season)
                            ],
                          )
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
              line(),
              Expanded(
                child: TabBarView(
                  children: [...tabViews],
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

Widget games(League league, bool results) {
  return FutureBuilder(
    future: Assistant.getLeagueGames(league),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      var games = snapshot.data;
      return snapshot.hasData
          ? games.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.sports_soccer,
                      size: 70,
                      color: Colors.grey,
                    ),
                    Text('No match is being played right now.')
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      GroupedListView<dynamic, String>(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        elements:
                            results ? games.where((o) => o.status.short == 'FT').toList() : games.where((o) => o.status.short != 'FT' && o.status.short != 'PST').toList(),
                        groupBy: (element) => element.league.round,
                        // useStickyGroupSeparators: true,
                        groupSeparatorBuilder: (String value) => Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    value,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                            line()
                          ],
                        ),
                        itemBuilder: (c, element) {
                          return Column(
                            children: [
                              Fixture(
                                showFavourite: false,
                                gameInfo: element,
                                showLeague: false,
                              ),
                              line()
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                )
          : const Center(
              child: CircularProgressIndicator(),
            );
    },
  );
}
