import 'package:betting_app/src/views/utils/live_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../ui/all_games/league_games.dart';

class AllGamesInfo extends StatefulWidget {
  final gameInfo;
  const AllGamesInfo({Key? key, required this.gameInfo}) : super(key: key);

  @override
  State<AllGamesInfo> createState() => _AllGamesInfoState();
}

class _AllGamesInfoState extends State<AllGamesInfo> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LeagueGameDetails(widget.gameInfo),
          ),
        );
      },
      child: Column(
        children: [
          Column(
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.network(
                              widget.gameInfo['countryLogo'],
                              width: 20,
                              height: 20,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.gameInfo['country'].toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey[30], fontSize: 12),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    widget.gameInfo['league'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey[30],
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (widget.gameInfo['liveGames'] > 0)
                            liveGame(widget.gameInfo['liveGames'].toString()),
                          const SizedBox(width: 10),
                          Text(
                            widget.gameInfo['games'].length.toString(),
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
            ],
          ),
        ],
      ),
    );
  }
}
