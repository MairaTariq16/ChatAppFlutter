import 'package:firebase_auth/firebase_auth.dart';

class HelperFunctions {
  getCurrentUser() {
    User currentUser = FirebaseAuth.instance.currentUser!;
    String? currentUserEmail = currentUser.email;
    return currentUserEmail;
  }

  createChatRoomID(String? user1, String user2) {
    int? x = user1?.substring(0, 1).codeUnitAt(0);
    if (x! > user2.substring(0, 1).codeUnitAt(0)) {
      return "$user2-$user1";
    } else {
      return "$user1-$user2";
    }
  }
}
