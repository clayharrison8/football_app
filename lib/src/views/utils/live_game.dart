import 'package:flutter/material.dart';

Widget liveGame(String value) {
  return Container(
    height: 20,
    width: 25,
    decoration: const BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    child: Center(
      child: Text(
        value,
        overflow: TextOverflow.ellipsis,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    ),
  );
}
