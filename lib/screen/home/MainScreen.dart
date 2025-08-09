import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../collection/collectionUI.dart';
import 'homeCubit.dart';
import 'homeUI.dart';


class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<IconData> icons = [
    Icons.home_outlined,
    Icons.collections_bookmark_outlined,
    Icons.search,
    Icons.person_outline,
  ];

  final List<String> labels = [
    "Home",
    "Collections",
    "Search",
    "My Space",
  ];

  final List<Widget> pages = [
    BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(),
      child: HomePage(),
    ),
    CollectionPage(),
    emptyScreen(),
    emptyScreen(),
  ];

  static Widget emptyScreen() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text("No content available",style: TextStyle(color: Colors.white),),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex != 0) {
          setState(() => selectedIndex = 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          elevation: 8,
          shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (index) {
                bool isSelected = selectedIndex == index;
                Color iconColor = isSelected ? Colors.purpleAccent : Colors.white;
                Color textColor = isSelected ? Colors.purpleAccent : Colors.white;

                return GestureDetector(
                  onTap: () {
                    setState(() => selectedIndex = index);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[index],
                        color: iconColor,
                      ),
                      SizedBox(height: 4),
                      Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
