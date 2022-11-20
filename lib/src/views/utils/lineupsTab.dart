import 'package:flutter/material.dart';
import '../../business_logic/models/fixture/game.dart';
import '../../business_logic/models/fixture/player.dart';
import '../../business_logic/services/api_services/assistant.dart';
import '../../views/utils/line.dart';

Widget lineupsTab(Game game) {
  return game.status.short == 'NS'
      ? const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
              "No live score information available now, the match has not started yet."),
        )
      : FutureBuilder(
          future: Assistant.getLineups(game.fixtureId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var lineups = snapshot.data;
            return snapshot.hasData
                ? lineups.isEmpty
                    ? const Text('No information available')
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            lineup(lineups[0].startXI, lineups[1].startXI,
                                'Starting Lineups'),
                            lineup(lineups[0].subs, lineups[1].subs,
                                'Substitutes'),
                            header('Coaches'),
                            line(),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(lineups[0].coach.name),
                                  Text(lineups[1].coach.name)
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        );
}

Widget lineup(
    List<Player> homeLineup, List<Player> awayLineup, String heading) {
  return Column(
    children: [
      header(heading),
      line(),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          playerList(homeLineup, false),
          playerList(awayLineup, true),
        ],
      ),
      line()
    ],
  );
}

Widget playerList(List<Player> players, bool reverse) {
  return Flexible(
    child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          List<Widget> player = [
            SizedBox(
              width: 20,
              child: Text(
                players[index].number,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              players[index].name,
              style: const TextStyle(fontSize: 13),
            ),
          ];
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: !reverse ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                if (!reverse)
                  ...player
                else
                  ...player.reversed
              ],
            ),
          );
        },
        itemCount: players.length,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true),
  );
}

Widget header(String heading) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          heading,
          textAlign: TextAlign.start,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    ),
  );
}
