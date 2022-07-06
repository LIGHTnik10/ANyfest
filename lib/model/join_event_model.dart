class Join {
  String? name;
  String? uid;
  String? email;
  String? age;
  String? eventId;
  String? eventTitle;
  String? date;
  String? time;
  String? description;
  String? eventImage;
  String? docId;
  String? joiners;
  String? eventaddress;
  String? latitude;
  String? longitude;
  String? creatorName;
  String? creatorEmail;
  Join(
      {this.name,
      this.age,
      this.email,
      this.uid,
      this.eventId,
      this.date,
      this.description,
      this.eventImage,
      this.eventTitle,
      this.time,
      this.docId,
      this.joiners,
      this.eventaddress,
      this.latitude,
      this.longitude,
      this.creatorName,
      this.creatorEmail});
  //recieve data from server
  factory Join.fromMap(map) {
    return Join(
        name: map['name'],
        uid: map['uid'],
        email: map['email'],
        age: map['age'],
        eventId: map['eventId'],
        eventImage: map['eventImage'],
        eventTitle: map['eventTitle'],
        time: map['map'],
        description: map['description'],
        date: map['date'],
        docId: map['docId'],
        joiners: map['joiners'],
        eventaddress: map['eventaddress'],
        latitude: map['latitude'],
        longitude: map['longitude'],
        creatorName: map['creatorName'],
        creatorEmail: map['creatorEmail']);
  }
  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'age': age,
      'eventId': eventId,
      'eventImage': eventImage,
      'eventTitle': eventTitle,
      'time': time,
      'description': description,
      'date': date,
      'docId': docId,
      'joiners': joiners,
      'eventaddress': eventaddress,
      'latitude': latitude,
      'longitude': longitude,
      'creatorName': creatorName,
      'creatorEmail': creatorEmail,
    };
  }
}
