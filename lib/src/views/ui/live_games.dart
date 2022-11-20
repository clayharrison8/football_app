import 'dart:async';

import 'package:betting_app/src/business_logic/models/fixture/game.dart';
import 'package:flutter/material.dart';
import '../../business_logic/services/api_services/assistant.dart';
import '../utils/fixture.dart';

class LiveGames extends StatefulWidget {
  const LiveGames({Key? key}) : super(key: key);

  @override
  _LiveGamesState createState() => _LiveGamesState();
}

class _LiveGamesState extends State<LiveGames> {
  Future<List<Game>> gamesList = Assistant.getLiveGames();

  @override
  void initState() {
    super.initState();

    // defines a timer
    Timer.periodic(const Duration(minutes: 1), (Timer t) {
      setState(() {
        gamesList = Assistant.getLiveGames();
      });
    });
  }

  bool loading = false;
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: gamesList,
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
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Filtered",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.grey[30],
                                      fontWeight: FontWeight.bold),
                                ),
                                Switch(
                                  value: _value,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        gamesListWidget(games),
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

Widget gamesListWidget(gamesList) {
  return ListView.separated(
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Fixture(
          showFavourite: true,
          gameInfo: gamesList[index], showLeague: true,
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
            color: Colors.grey,
            height: 0,
          ),
      itemCount: gamesList.length,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true);
}
