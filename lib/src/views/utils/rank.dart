import 'package:flutter/material.dart';
import '../../business_logic/models/standings/rank.dart';
import '../../business_logic/models/fixture/game.dart';

class RankWidget extends StatefulWidget {
  final Rank rank;
  final Game game;
  const RankWidget({
    Key? key,
    required this.rank,
    required this.game,
  }) : super(key: key);

  @override
  State<RankWidget> createState() => _RankWidgetState();
}

class _RankWidgetState extends State<RankWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: widget.rank.team.name == widget.game.home.name ||
                  widget.rank.team.name == widget.game.away.name
              ? Colors.blue[50]
              : Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Text(
                            '${widget.rank.position.toString()}.',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey[30],
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Image.network(
                          widget.rank.team.logo,
                          width: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.rank.team.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey[30],
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // set your alignment
                    children: [
                      Text(
                        widget.rank.all.played.toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${widget.rank.all.goals.goalsFor.toString()}:${widget.rank.all.goals.goalsAgainst.toString()}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.rank.points.toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
