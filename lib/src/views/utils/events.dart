import 'package:betting_app/src/business_logic/models/fixture/event.dart';
import 'package:flutter/material.dart';

class Events extends StatelessWidget {
  final Event event;
  const Events({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> eventDetails = [
      Text(
        event.time.toString() + "'",
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black, fontSize: 12),
      ),
      const SizedBox(
        width: 5,
      ),
      Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            color: Colors.white),
        padding: const EdgeInsets.all(1),
        child: eventIcon(event),
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        event.player,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black, fontSize: 12),
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        event.assister != null || event.detail == 'Own goal'
            ? "(${event.detail == 'Own Goal' ? 'Own Goal' : event.assister})"
            : "",
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black, fontSize: 12),
      ),
    ];

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: event.homeOrAway == "home"
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            if (event.homeOrAway == "home")
              ...eventDetails
            else
              ...eventDetails.reversed
          ],
        ),
      ),
    );
  }
}

Widget eventIcon(event) {
  if (event.detail == "Yellow Card") {
    return const RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.rectangle,
        color: Colors.yellow,
        size: 12,
      ),
    );
  } else {
    if (event.detail == "Red Card") {
      return const RotatedBox(
        quarterTurns: 1,
        child: Icon(
          Icons.rectangle,
          color: Colors.red,
          size: 12,
        ),
      );
    } else if (event.type == "Goal") {
      return Icon(
        Icons.sports_soccer,
        color: event.detail == 'Own Goal' ? Colors.red : Colors.black,
        size: 15,
      );
    } else if (event.type == "subst") {
      return const Icon(
        Icons.rotate_right,
        color: Colors.black,
        size: 10,
      );
    }
  }
  return const Text('');
}
