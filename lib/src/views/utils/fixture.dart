import 'package:betting_app/src/views/ui/game_details.dart';
import 'package:betting_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../business_logic/models/fixture/game.dart';

class Fixture extends StatefulWidget {
  final Game gameInfo;
  final bool showLeague;
  final bool showFavourite;
  final bool showResult;
  final String team;
  const Fixture(
      {Key? key,
      this.showResult = false,
      required this.gameInfo,
      this.showLeague = false,
      this.team = '',
      this.showFavourite = true})
      : super(key: key);

  @override
  State<Fixture> createState() => _FixtureState();
}

class _FixtureState extends State<Fixture> {
  bool inFavourites = false;
  @override
  Widget build(BuildContext context) {
    doesExist(widget.gameInfo.fixtureId);

    var gameLive = widget.gameInfo.status.short == '1H' ||
        widget.gameInfo.status.short == 'HT' ||
        widget.gameInfo.status.short == '2H';

    Color textColours = gameLive ? Colors.red : Colors.black;

    Color resultColour = Colors.black;
    String resultText = '';

    var homeWon = widget.gameInfo.home.winner;
    var awayWon = widget.gameInfo.away.winner;
    var homeName = widget.gameInfo.home.name;
    var awayName = widget.gameInfo.away.name;

    if ((homeWon == true && widget.team == homeName) ||
        (awayWon == true && widget.team == awayName)) {
      resultColour = Colors.green;
      resultText = 'W';
    } else if ((homeWon == false && widget.team == homeName) ||
        (awayWon == false && widget.team == awayName)) {
      resultColour = Colors.red;
      resultText = 'L';
    } else {
      resultColour = Colors.yellow;
      resultText = 'D';
    }

    return Column(
      children: [
        Column(
          children: [
            if (widget.showLeague)
              Container(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          widget.gameInfo.league.logo,
                          width: 20,
                          height: 20,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.gameInfo.league.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey[30],
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              SvgPicture.network(
                                widget.gameInfo.league.flag,
                                width: 20,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.gameInfo.league.country.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey[30], fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      widget.showFavourite
                          ? GestureDetector(
                              onTap: () {
                                favRef
                                    .child(widget.gameInfo.fixtureId)
                                    .set(true);
                                setState(() {
                                  inFavourites = true;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: inFavourites
                                    ? const Icon(
                                        Icons.star,
                                        size: 25,
                                        color: Colors.yellow,
                                      )
                                    : const Icon(
                                        Icons.star_border,
                                        size: 25,
                                      ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: date(widget.gameInfo),
                            ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GameDetails(widget.gameInfo),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  widget.gameInfo.home.logo,
                                  width: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  widget.gameInfo.home.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.grey[30],
                                      fontWeight: widget.gameInfo.home.winner ==
                                                  true &&
                                              widget.gameInfo.status.short ==
                                                  'FT'
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Image.network(
                                  widget.gameInfo.away.logo,
                                  width: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  widget.gameInfo.away.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.grey[30],
                                      fontWeight: widget.gameInfo.away.winner ==
                                                  true &&
                                              widget.gameInfo.status.short ==
                                                  'FT'
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (gameLive)
                        Text(
                          widget.gameInfo.status.short == 'HT'
                              ? widget.gameInfo.status.short
                              : widget.gameInfo.status.elapsed.toString() + "'",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      const SizedBox(
                        width: 30,
                      ),
                      widget.gameInfo.status.short == 'NS'
                          ? Text(
                              widget.gameInfo.date.time,
                            )
                          : Column(
                              children: [
                                Text(
                                  widget.gameInfo.totalHomeGoals.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: textColours,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.gameInfo.totalAwayGoals.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: textColours,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                      if (widget.showResult)
                        Row(
                          children: [
                            const SizedBox(width: 15),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: resultColour),
                              child: Center(
                                child: Text(
                                  resultText,
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            )
                          ],
                        )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget date(Game game) {
  int currentYear = int.parse(DateFormat('yyyy').format(DateTime.now()));

  if (game.date.year >= currentYear) {
    return Text(
        '${game.date.day.toString().padLeft(2, '0')}.${game.date.month.toString().padLeft(2, '0')}.');
  } else {
    return Text(game.date.year.toString());
  }
}

Future<bool> doesExist(fav) async {
  final snapshot =
      await favRef.child(fav).get(); // you should use await on async methods
  if (snapshot.value != null) {
    return true;
  } else {
    return false;
  }
}
