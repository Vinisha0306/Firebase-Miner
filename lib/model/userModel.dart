class UserModel {
  String uid;
  String displayName;
  String email;
  String photoURL;
  String phoneNumber;
  String status;

  UserModel(this.uid, this.displayName, this.email, this.photoURL,
      this.phoneNumber, this.status);

  factory UserModel.froMap(Map data) => UserModel(
      data['uid'],
      data['displayName'] ?? "${(data['email'].split('@'))[0]}",
      data['email'] ?? "Demo@gmail.com",
      data['photoURL'] ??
          "https://i.pinimg.com/564x/d2/86/11/d2861141a4a75eb863d91518da04b13f.jpg",
      data['phoneNumber'] ?? "0000000000",
      data['status'] ?? "offline");

  Map<String, dynamic> get toMap => {
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'phoneNumber': phoneNumber,
        'photoURL': photoURL,
        'status': status,
      };
}
