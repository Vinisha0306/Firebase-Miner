import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/chat_model.dart';
import '../model/userModel.dart';
import 'auth_model.dart';

class FireDatabase {
  FireDatabase._() {
    getUser();
  }
  static final FireDatabase fireDatabase = FireDatabase._();
  String userCollectionPath = 'User';
  String friendsCollectionPath = 'friends';
  String chatCollectionPath = 'chats';
  late UserModel currentUser;

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<UserModel> getSingleUser({required UserModel userModel}) async {
    UserModel user = UserModel(
        '101',
        'demo Name',
        'demoEmail.com',
        'https://i.pinimg.com/564x/d2/86/11/d2861141a4a75eb863d91518da04b13f.jpg',
        '1297858798',
        'offline');

    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await fireStore.collection(userCollectionPath).doc(userModel.uid).get();
    user = UserModel.froMap(snapshot.data() as Map);

    return user;
  }

  Future<void> addUser({required User user}) async {
    Map<String, dynamic> data = {
      'uid': user.uid,
      'displayName': user.displayName ?? "${(user.email?.split('@'))?[0]}",
      'email': user.email ?? "demo@gmail.com",
      'phoneNumber': user.phoneNumber ?? "0000000000",
      'photoURL': user.photoURL ??
          "https://i.pinimg.com/564x/d2/86/11/d2861141a4a75eb863d91518da04b13f.jpg",
    };

    await fireStore.collection(userCollectionPath).doc(user.uid).set(data);
  }

  Future<void> getUser() async {
    DocumentSnapshot snapshot = await fireStore
        .collection(userCollectionPath)
        .doc(AuthHelper.authHelper.auth.currentUser?.uid)
        .get();
    currentUser = UserModel.froMap(snapshot.data() as Map);
  }

  Future<void> updateUser({required UserModel userModel}) async {
    await fireStore.collection(userCollectionPath).doc(currentUser.uid).update({
      'displayName': userModel.displayName,
      'email': userModel.email,
      'phoneNumber': userModel.phoneNumber,
    }).then((value) => getUser());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return fireStore.collection(userCollectionPath).snapshots();
  }

  /// friends

  Future<void> addFriends({required UserModel user}) async {
    Map<String, dynamic> data = {
      'uid': user.uid,
      'displayName': user.displayName,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'photoURL': user.photoURL,
    };

    await fireStore
        .collection(userCollectionPath)
        .doc(currentUser.uid)
        .collection(friendsCollectionPath)
        .doc(user.uid)
        .set(data);
    await fireStore
        .collection(userCollectionPath)
        .doc(user.uid)
        .collection(friendsCollectionPath)
        .doc(currentUser.uid)
        .set(currentUser.toMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFriends() {
    return fireStore
        .collection(userCollectionPath)
        .doc(currentUser.uid)
        .collection(friendsCollectionPath)
        .snapshots();
  }

  ///chat

  Future<void> sendChat(
      {required UserModel user, required ChatModel chat}) async {
    await fireStore
        .collection(userCollectionPath)
        .doc(currentUser.uid)
        .collection(friendsCollectionPath)
        .doc(user.uid)
        .collection(chatCollectionPath)
        .doc(chat.time.millisecondsSinceEpoch.toString())
        .set(chat.toMap);

    Map<String, dynamic> data = chat.toMap;
    data['type'] = 'received';

    await fireStore
        .collection(userCollectionPath)
        .doc(user.uid)
        .collection(friendsCollectionPath)
        .doc(currentUser.uid)
        .collection(chatCollectionPath)
        .doc(chat.time.millisecondsSinceEpoch.toString())
        .set(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChats(
      {required UserModel userModel}) {
    return fireStore
        .collection(userCollectionPath)
        .doc(currentUser.uid)
        .collection(friendsCollectionPath)
        .doc(userModel.uid)
        .collection(chatCollectionPath)
        .snapshots();
  }

  Future<ChatModel> getLastChat({required UserModel user}) async {
    QuerySnapshot<Map<String, dynamic>> data = await fireStore
        .collection(userCollectionPath)
        .doc(currentUser.uid)
        .collection(friendsCollectionPath)
        .doc(user.uid)
        .collection(chatCollectionPath)
        .get();

    List<QueryDocumentSnapshot> docs = data.docs;
    int length = docs.length;
    ChatModel lastChat = ChatModel.fromMap(docs[length - 1] as Map);
    print("lasChat : $lastChat");

    return length != 0
        ? lastChat
        : ChatModel(DateTime.now(), 'msg', 'type', 'status');
  }

  Future<void> seenMsg(
      {required UserModel user, required ChatModel chat}) async {
    await fireStore
        .collection(userCollectionPath)
        .doc(currentUser.uid.toString())
        .collection(friendsCollectionPath)
        .doc(user.uid.toString())
        .collection(chatCollectionPath)
        .doc(chat.time.millisecondsSinceEpoch.toString())
        .update(
      {'status': "seen"},
    );

    await fireStore
        .collection(userCollectionPath)
        .doc(user.uid.toString())
        .collection(friendsCollectionPath)
        .doc(currentUser.uid.toString())
        .collection(chatCollectionPath)
        .doc(chat.time.millisecondsSinceEpoch.toString())
        .update(
      {'status': "seen"},
    );
  }

  Future<void> updateChat(
      {required UserModel userModel,
      required ChatModel chat,
      required String msg}) async {
    await fireStore
        .collection(userCollectionPath)
        .doc(currentUser.uid)
        .collection(friendsCollectionPath)
        .doc(userModel.uid)
        .collection(chatCollectionPath)
        .doc(chat.time.millisecondsSinceEpoch.toString())
        .update(
      {'msg': msg},
    );
    await fireStore
        .collection(userCollectionPath)
        .doc(userModel.uid)
        .collection(friendsCollectionPath)
        .doc(currentUser.uid)
        .collection(chatCollectionPath)
        .doc(chat.time.millisecondsSinceEpoch.toString())
        .update(
      {'msg': chat.msg},
    );
  }
}
