import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test_app/helper/helperfunctions.dart';
import 'package:firebase_test_app/screens/conversation_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart' as Constants;
import '../services/database.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchFieldController = TextEditingController();
  Database database = Database();
  QuerySnapshot<Map<String, dynamic>>? searchSnapshot;
  bool haveSearched = false;

  Widget searchList() {
    if (haveSearched) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: searchSnapshot!.docs.length,
          itemBuilder: (context, index) {
            return SearchResult(searchSnapshot!.docs[index].data()["username"],
                searchSnapshot!.docs[index].data()["email"]);
          });
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Search for User to Chat"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: searchFieldController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: Constants.EMAIL_TEXT,
                ),
              ),
            ),
            ElevatedButton(
                child: const Text(Constants.SEARCH_BTN_TEXT),
                onPressed: () async {
                  String email = searchFieldController.text;
                  await database.getUserByEmail(email).then((snapshot) {
                    haveSearched = true;
                    setState(() {
                      searchSnapshot = snapshot;
                    });
                  });
                }),
            searchList()
          ],
        ));
  }
}

class SearchResult extends StatelessWidget {
  late String username;
  late String
      email; //email of searched user: the user which current user wishes to start chat with
  SearchResult(this.username, this.email, {Key? key}) : super(key: key);
  Database database = Database();
  HelperFunctions helper = HelperFunctions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(username),
                Text(email),
              ],
            ),
          ),
          ElevatedButton(
              child: const Text("Message"),
              onPressed: () async {
                //get email of current user logged in in order to create a chat room
                String? currentUserEmail = helper.getCurrentUser();
                String chatroomID =
                    helper.createChatRoomID(currentUserEmail, email);
                database.createChatRoom(currentUserEmail, email, chatroomID);
                //navigate to conversation
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ConversationScreen(chatroomID, currentUserEmail!),
                    ));
                //create Map of both users' emails: to be added to database of chatrooms

                //save data to database in collection of chatrooms
              }),
        ],
      ),
    );
  }
}
