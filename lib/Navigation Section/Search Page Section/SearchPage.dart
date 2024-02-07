import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../Components Section/Colour Component/UIColours.dart';
import '../../Components Section/Custom Card Component/SearchCard.dart';
import '../../Components Section/Shimmer Loading Component/User_Loader.dart';
import '../../User Section/Authenticate User Section/Get_User_Unique_name.dart';

class SearchPage extends StatefulWidget {
  final String Userid;
  const SearchPage({super.key, required this.Userid});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<String> UserList = [];
  late String altername = '';

  bool isTextFocused = false;
  bool allowNavigation = false;
  bool UserLoading = true;

  @override
  void initState() {
    super.initState();
    getname();
    GetUserLists();
    _focusNode.addListener(() {
      setState(() {
        isTextFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    SearchController.dispose();
    UserList.clear();
  }

  Future<void> getname() async {
    altername = await getUsernameByUserId(widget.Userid);
  }

  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('Users');

  Future<void> GetUserLists() async {
    setState(() {
      UserLoading = true;
    });

    DataSnapshot UserSnapshot = (await _database.once()).snapshot;
    DataSnapshot followingSnapshot =
        (await _database.child(widget.Userid).child('Following').once())
            .snapshot;

    List<String> tempUsernames = [];
    List<String> tempFollowing = [];

    dynamic UsersData = UserSnapshot.value;
    dynamic followingData = followingSnapshot.value;

    if (followingData != null && followingData is Map) {
      for (String key in followingData.keys) {
        tempFollowing.add(await getUsernameByUserId(key));
      }
    }

    if (UsersData != null) {
      UsersData.forEach(
        (key, value) {
          if (key is String) {
            String username = value['Username'];
            if (!tempFollowing.contains(username)) {
              setState(() {
                tempUsernames.add(username);
              });
            }
          }
        },
      );
    }

    setState(() {
      UserList = tempFollowing + tempUsernames;
      UserLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: kPrimaryLightColor,
      child: WillPopScope(
        onWillPop: () async {
          // Prevent navigation when allowNavigation is false (during the login process)
          if (!allowNavigation) {
            return false;
          }
          return true; // Allow navigation for other screens
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04, vertical: size.height * 0.02),
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 0,
                    blurRadius: 9,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: Colors.white,
                border: Border.all(
                  color: isTextFocused ? kPrimaryColor : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                controller: SearchController,
                onChanged: (text) {
                  setState(() {});
                },
                focusNode: _focusNode,
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 13,
                  ),
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    color: isTextFocused ? kPrimaryColor : Colors.grey,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 10, 3),
                  border: InputBorder.none,
                  hintText: 'Search Username :',
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: GetUserLists, // Function to call when refreshing
                child: UserLoading
                    ? ListView(
                        children: List.generate(
                          // Generate loading skeleton cards based on the length of the list
                          UserList.length,
                          (index) => UserDataLoading(size: size),
                        ),
                      )
                    : ListView.builder(
                        itemCount: UserList.length,
                        itemBuilder: (context, index) {
                          String item = UserList[index];

                          if (item != altername) {
                            if (SearchController.text.isEmpty ||
                                item.toLowerCase().contains(
                                    SearchController.text.toLowerCase())) {
                              return UserlistCard(
                                Username: item,
                                LoginAuthorId: widget.Userid,
                              );
                            }
                          }

                          return Container();
                        },
                      ),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            )
          ],
        ),
      ),
    );
  }
}
