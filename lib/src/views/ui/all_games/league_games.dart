import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../business_logic/models/date.dart';
import '../../../business_logic/services/helper.dart';
import '../../utils/fixture.dart';

class LeagueGameDetails extends StatefulWidget {
  final gameInfo;
  const LeagueGameDetails(this.gameInfo, {Key? key}) : super(key: key);

  @override
  State<LeagueGameDetails> createState() => _LeagueGameDetailsState();
}

class _LeagueGameDetailsState extends State<LeagueGameDetails> {
  List<FixtureDate> dates = Helper.getDates();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(
              Icons.sports_soccer,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text('Football'),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey[30],
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10)), //this right here
                                child: SizedBox(
                                  height: 600,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Calendar',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Icon(Icons.close, size: 30,),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                          height: 1,
                                          thickness: 1,
                                        ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: dates.length,
                                              physics: const ClampingScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                  int index) {
                                                return Padding(
                                                  padding:
                                                  const EdgeInsets.all(12),
                                                  child: Text(dates[index]
                                                      .day ==
                                                      'Today'
                                                      ? 'TODAY'
                                                      : '${dates[index].date} ${dates[index].day}',),
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                  int index) =>
                                              const Divider(
                                                color: Colors.grey,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Icon(Icons.calendar_month_outlined),
                    )
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        widget.gameInfo['leagueLogo'],
                        width: 20,
                        height: 20,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.gameInfo['league'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey[30],
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            SvgPicture.network(
                              widget.gameInfo['countryLogo'],
                              width: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              widget.gameInfo['country'].toUpperCase(),
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
            ListView.separated(
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  return Fixture(
                    showFavourite: true,
                    showLeague: false,
                    gameInfo: widget.gameInfo['games'][index],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                      color: Colors.grey,
                      height: 0,
                    ),
                itemCount: widget.gameInfo['games'].length,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true),
          ],
        ),
      ),
    );
  }
}
