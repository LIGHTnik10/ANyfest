class EventAdd {
  String? eventId;
  String? eventTitle;
  String? date;
  String? time;
  String? description;
  String? uid;
  String? email;
  String? eventImage;
  String? docId;
  String? mapAddress;
  String? latitude;
  String? longitude;
  String? creatorName;

  EventAdd(
      {this.eventId,
      this.eventTitle,
      this.date,
      this.time,
      this.description,
      this.uid,
      this.email,
      this.eventImage,
      this.docId,
      this.mapAddress,
      this.latitude,
      this.longitude,
      this.creatorName});

  // receive data from the server

  factory EventAdd.fromMap(map) {
    return EventAdd(
        eventId: map['eventId'],
        eventTitle: map['eventTitle'],
        date: map['date'],
        time: map['time'],
        description: map['description'],
        uid: map['uid'],
        email: map['email'],
        eventImage: map['eventImage'],
        docId: map['docId'],
        mapAddress: map['mapAddress'],
        latitude: map['latitude'],
        longitude: map['longitude'],
        creatorName: map['creatorName']);
  }

  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'eventTitle': eventTitle,
      'date': date,
      'time': time,
      'description': description,
      'uid': uid,
      'email': email,
      'eventImage': eventImage,
      'docId': docId,
      'mapAddress': mapAddress,
      'latitude': latitude,
      'longitude': longitude,
      'creatorName': creatorName,
    };
  }
}
