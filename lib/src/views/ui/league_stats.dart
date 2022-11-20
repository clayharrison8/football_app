// import 'package:flutter/material.dart';
// import '../../business_logic/services/api_services/assistant.dart';
// import 'game_info.dart';
//
//
// class LeagueStats extends StatefulWidget {
//   const LeagueStats({Key? key}) : super(key: key);
//
//   @override
//   _LeagueStatsState createState() => _LeagueStatsState();
// }
//
// class _LeagueStatsState extends State<LeagueStats> {
//   bool _value = false;
//   List liveGamesList = [];
//
//   // Assistant.getLiveGames();
// var stats = Assistant.getLeagueStats();
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Assistant.getLiveGames(),
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         liveGamesList = snapshot.data;
//         return snapshot.hasData
//             ? liveGamesList.isEmpty
//             ? Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Icon(
//               Icons.sports_soccer,
//               size: 70,
//               color: Colors.grey,
//             ),
//             Text('No match is being played right now.')
//           ],
//         )
//             : SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//                 child: Container(
//                   color: Colors.white,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Filtered",
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                             color: Colors.grey[30],
//                             fontWeight: FontWeight.bold),
//                       ),
//                       Switch(
//                         value: _value,
//                         onChanged: (value) {
//                           setState(() {
//                             _value = value;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               ListView.separated(
//                   padding: const EdgeInsets.all(0),
//                   itemBuilder: (context, index) {
//                     return GameInfo(
//                       gameInfo: liveGamesList[index],
//                     );
//                   },
//                   separatorBuilder: (BuildContext context, int index) =>
//                   const Divider(
//                     color: Colors.grey,
//                     height: 0,
//                   ),
//                   itemCount: liveGamesList.length,
//                   physics: const ClampingScrollPhysics(),
//                   shrinkWrap: true),
//             ],
//           ),
//         )
//             : const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }
// }
//
//
