class UserModel {
  String? uid;
  String? email;
  String? firstName;

  String? photoUrl;
  // ignore: non_constant_identifier_names
  String? Bio;

  UserModel(
      {this.uid,
      this.email,
      this.firstName,

      this.photoUrl,
      // ignore: non_constant_identifier_names
      this.Bio});

  // receive data from the server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
     
        photoUrl: map['photoUrl'],
        Bio: map['bio']);
  }
  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      
      'photoUrl': photoUrl,
      'bio': Bio,
    };
  }
}
