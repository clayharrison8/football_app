import 'dart:async';

import 'package:betting_app/src/business_logic/models/date.dart';
import 'package:betting_app/src/views/utils/all_games_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../business_logic/services/api_services/assistant.dart';
import '../../../business_logic/services/helper.dart';
import '../../utils/live_game.dart';

DateTime now = DateTime.now();
String today = DateFormat('yyyy-MM-dd').format(now);

List test = ['1'];

class AllGames extends StatefulWidget {
  const AllGames({Key? key}) : super(key: key);

  @override
  _AllGamesState createState() => _AllGamesState();
}

class _AllGamesState extends State<AllGames> {
  String dated = today;

  Future<List> gamesList = Assistant.getAllGames(today);

  @override
  void initState() {
    super.initState();

    // defines a timer
    Timer.periodic(const Duration(minutes: 1), (Timer t) {
      setState(() {
        gamesList = Assistant.getAllGames(dated);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<FixtureDate> dates = Helper.getDates();
    List<Widget> dateTabs = [];
    List<Widget> datePages = [];
    for (var date in dates) {
      dateTabs.add(
        Tab(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                date.day == 'Today' ? 'TODAY' : date.day.substring(0, 3).toUpperCase(),
                style: TextStyle(fontSize: 12),
              ),
              Text(
                date.date,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      );
      datePages.add(games(date.url));
    }

    return DefaultTabController(
      length: dates.length,
      initialIndex: 7,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            height: 40,
            child: TabBar(
              labelPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              indicatorColor: Colors.red,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.red,
              isScrollable: true,
              tabs: [...dateTabs],
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
          ),
          Expanded(
            child: TabBarView(
              children: [...datePages],
            ),
          ),
        ],
      ),
    );
  }

  Widget games(date) {
    return FutureBuilder(
      future: gamesList,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        var games = snapshot.data;

        // print(games);

        // int liveGames = games != null && games.isNotEmpty
        //     ? games.where((o) => o['liveGames'] > 0).toList().length
        //     : 0;

        // print(liveGames);

        return snapshot.connectionState != ConnectionState.waiting
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.list,
                                  size: 25,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "All Games",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.grey[30],
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                if (true) liveGame('0'),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  games.length.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.grey[30],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 1,
                      thickness: 1,
                    ),
                    Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              color: Colors.white,
                              child: Container(
                                color: Colors.grey[200],
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 5, 0, 5),
                                          child: Text(
                                            "COMPETITIONS (A-Z)",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey[30],
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ListView.separated(
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          return AllGamesInfo(
                            gameInfo: games[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                              color: Colors.grey,
                              height: 0,
                            ),
                        itemCount: games.length,
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
