import 'package:betting_app/src/business_logic/models/date.dart';
import 'package:intl/intl.dart';

class Helper {
  // Getting dates week before and week after to create all games list
  static List <FixtureDate> getDates() {
    DateTime now = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(now);

    DateTime start = now.subtract(const Duration(days: 7));
    DateTime end = now.add(const Duration(days: 7));

    List <FixtureDate> days = [];

    for (int i = 0; i <= end.difference(start).inDays; i++) {
      DateTime date = start.add(Duration(days: i));

      String url = DateFormat('yyyy-MM-dd').format(date);
      String formattedDate = DateFormat('dd.MM.').format(date);
      String day = DateFormat('EEEE').format(date);

      if (url == today) {
        day = "Today";
      }
      days.add(FixtureDate(url, formattedDate, day));
    }

    return days;
  }

}