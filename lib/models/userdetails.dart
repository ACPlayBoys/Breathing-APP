// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserDetails {
  final String name;
  final String age;
  final String gender;
  final String country;
  final String uid;
  final String time;
  UserDetails({
    required this.name,
    required this.age,
    required this.gender,
    required this.country,
    required this.uid,
    required this.time,
  });

  UserDetails copyWith({
    String? name,
    String? age,
    String? gender,
    String? country,
    String? uid,
    String? time,
  }) {
    return UserDetails(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      uid: uid ?? this.uid,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'age': age,
      'gender': gender,
      'country': country,
      'uid': uid,
      'time': time,
    };
  }

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      name: map['name'] as String,
      age: map['age'] as String,
      gender: map['gender'] as String,
      country: map['country'] as String,
      uid: map['uid'] as String,
      time: map['time'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDetails.fromJson(String source) => UserDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserDetails(name: $name, age: $age, gender: $gender, country: $country, uid: $uid, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserDetails &&
      other.name == name &&
      other.age == age &&
      other.gender == gender &&
      other.country == country &&
      other.uid == uid &&
      other.time == time;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      age.hashCode ^
      gender.hashCode ^
      country.hashCode ^
      uid.hashCode ^
      time.hashCode;
  }
}
