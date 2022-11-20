import 'package:betting_app/src/views/utils/rank.dart';
import 'package:flutter/material.dart';

import '../../business_logic/models/fixture/game.dart';

Widget standingsTab(Game game, standings) {
  return FutureBuilder(
    future: standings,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      var standings = snapshot.data;
      return snapshot.hasData
          ? standings.standings.isEmpty
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Text('No information available')],
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: Padding(
                      padding:
                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              SizedBox(
                                width: 20,
                                child: Text(
                                  '#',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'TEAM',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 120,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'MP',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'G',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'PTS',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                ListView.separated(
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return RankWidget(
                        game: game,
                        rank: standings.standings[index],
                      );
                    },
                    separatorBuilder:
                        (BuildContext context, int index) =>
                    const Divider(
                      color: Colors.grey,
                      height: 0,
                    ),
                    itemCount: standings.standings.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true)
              ],
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
