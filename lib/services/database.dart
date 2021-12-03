import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  setDeviceToken(String token) {
    Map<String, String> tokenInfo = {"token": token};
    FirebaseFirestore.instance.collection("DeviceTokens").add(tokenInfo);
  }

  getUserByEmail(String userEmail) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  setUserData(String email, String username) {
    Map<String, String> userData = {"email": email, "username": username};
    FirebaseFirestore.instance.collection("users").add(userData);
  }

  createChatRoom(String? user1, String user2, String chatRoomID) {
    List<String?> users = [user1, user2];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomID": chatRoomID
    };
    FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(chatRoomID)
        .set(chatRoomMap);
  }

  addConversation(String chatRoomID, String message, String sentBy) async {
    Map<String, String> messageMap = {"message": message, "sentBy": sentBy};
    FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(chatRoomID)
        .collection("chats")
        .add(messageMap);
  }

  getConversation(String chatRoomID) async {
    return await FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(chatRoomID)
        .collection("chats")
        .snapshots();
  }
}
