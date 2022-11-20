import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import '../utils/events.dart';
import '../../business_logic/models/fixture/game.dart';
import '../../business_logic/services/api_services/assistant.dart';

Widget eventsTab(Game game) {
  return game.status.short == 'NS'
      ? const Padding(
    padding: EdgeInsets.all(15),
    child: Text(
        "No live score information available now, the match has not started yet."),
  )
      : FutureBuilder(
    future: Assistant.getEvents(game),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      var events = snapshot.data;
      return snapshot.hasData
          ? events.isEmpty
          ? Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                '${game.totalHomeGoals} - ${game.totalAwayGoals}',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[30],
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            GroupedListView<dynamic, String>(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              elements: events,
              groupBy: (element) => element.half,
              // useStickyGroupSeparators: true,
              groupSeparatorBuilder: (String value) =>
                  Container(
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Padding(
                      padding:
                      const EdgeInsets.fromLTRB(8, 5, 0, 5),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            value,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[30],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "0 - 0",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[30],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
              itemBuilder: (c, element) {
                return Events(
                  event: element,
                );
              },
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 0, 5),
                child: Text(
                  "MATCH INFORMATION",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[30],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  if (game.referee.isNotEmpty)
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.person),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Referee',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Text(
                          game.referee,
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.stadium_outlined),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Venue',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        game.venue.name +
                            ' (${game.venue.city})',
                        overflow: TextOverflow.clip,
                        style: const TextStyle(fontSize: 12),
                      )
                    ],
                  )
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
