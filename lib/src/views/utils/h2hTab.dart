import 'package:flutter/material.dart';

import '../../business_logic/models/fixture/game.dart';
import '../../business_logic/services/api_services/assistant.dart';
import '../ui/game_details.dart';
import 'fixture.dart';

Widget h2hTab(Game game) {
  return FutureBuilder(
    future: Assistant.getH2H(game),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      var h2h = snapshot.data;
      return snapshot.hasData
          ? h2h.isEmpty
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Text('No information available')],
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                header('Last matches: ${game.home.name}'),
                ListView.separated(
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return Fixture(
                        team: game.home.name,
                        showResult: true,
                        showFavourite: false,
                        gameInfo: h2h[0][index],
                      );
                    },
                    separatorBuilder:
                        (BuildContext context, int index) =>
                    const Divider(
                      color: Colors.grey,
                      height: 0,
                    ),
                    itemCount: h2h[0].length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true)
              ],
            ),
            Column(
              children: [
                header('Last matches: ${game.away.name}'),
                ListView.separated(
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return Fixture(
                        team: game.away.name,
                        showResult: true,
                        showFavourite: false,
                        gameInfo: h2h[1][index],
                      );
                    },
                    separatorBuilder:
                        (BuildContext context, int index) =>
                    const Divider(
                      color: Colors.grey,
                      height: 0,
                    ),
                    itemCount: h2h[1].length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true)
              ],
            ),
            if (h2h[2].isNotEmpty)
              Column(
                children: [
                  header('Head-to-head matches'),
                  ListView.separated(
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        return Fixture(
                          showFavourite: false,
                          gameInfo: h2h[2][index],
                        );
                      },
                      separatorBuilder:
                          (BuildContext context, int index) =>
                      const Divider(
                        color: Colors.grey,
                        height: 0,
                      ),
                      itemCount: h2h[2].length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true)
                ],
              )
          ],
        ),
      )
          : const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    },
  );
}
