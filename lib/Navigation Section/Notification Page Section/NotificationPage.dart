import 'package:flutter/material.dart';

import '../../Components Section/Custom Card Component/RequestCard.dart';
import '../../Components Section/Shimmer Loading Component/User_Loader.dart';
import '../../User Section/Request Authentication Section/Fetch_User_Requested_List.dart';

const kPrimaryLightColor = Color(0xFFF1E6FF);

class NotificationPage extends StatefulWidget {
  final String Userid;
  const NotificationPage({
    super.key,
    required this.Userid,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<String> RequestList = [];

  bool UserLoading = false;
  bool allowNavigation = false;

  @override
  void initState() {
    super.initState();
    GetUserLists();
  }

  Future<void> GetUserLists() async {
    setState(() {
      UserLoading = true;
    });
    final awlist = await getRequestedList(widget.Userid);
    setState(() {
      RequestList = awlist;
      UserLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          // Prevent navigation when allowNavigation is false (during the login process)
          if (!allowNavigation) {
            return false;
          }
          return true; // Allow navigation for other screens
        },
        child: RequestList.isEmpty
            ? Container(
                child: const Center(
                  child: Text("No Notification !"),
                ),
              )
            : Container(
                color: kPrimaryLightColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh:
                            GetUserLists, // Function to call when refreshing
                        child: UserLoading
                            ? ListView(
                                children: List.generate(
                                  // Generate loading skeleton cards based on the length of the list
                                  RequestList.length,
                                  (index) => UserDataLoading(size: size),
                                ),
                              )
                            : ListView.builder(
                                itemCount: RequestList.length,
                                itemBuilder: (context, index) {
                                  String item = RequestList[index];

                                  return RequestCard(
                                      UserId: widget.Userid, RequesterId: item);
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
      ),
    );
  }
}
