import 'package:betting_app/src/views/ui/all_games/all_games.dart';
import 'package:betting_app/src/views/ui/favourites.dart';
import 'package:betting_app/src/views/ui/simulator.dart';
import 'package:flutter/material.dart';
import 'live_games.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int selectedIndex = 0;

  void itemClicked(int index) {
    // Update UI to reflect new changes
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  // Called when widget created
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  // Called when widget removed from tree
  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Navigation Drawer',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text('Simulator'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Simulator(),
                  ),
                );
              },
              // Navigator.pop(context);
            ),
            ListTile(
              title: const Text('League Stats'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          AllGames(),
          LiveGames(),
          Favourites(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer), label: "All Games"),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer), label: "Live"),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_border), label: "Favourites"),
        ],
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        showSelectedLabels: true,
        currentIndex: selectedIndex,
        onTap: itemClicked,
      ),
    );
  }
}
