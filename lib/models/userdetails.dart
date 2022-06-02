import 'dart:convert';

class UserDetails {
  final String name;
  final String age;
  final String gender;
  final String country;
  UserDetails({
    required this.name,
    required this.age,
    required this.gender,
    required this.country,
  });

  UserDetails copyWith({
    String? name,
    String? age,
    String? gender,
    String? country,
  }) {
    return UserDetails(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'name': name});
    result.addAll({'age': age});
    result.addAll({'gender': gender});
    result.addAll({'country': country});
  
    return result;
  }

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      name: map['name'] ?? '',
      age: map['age'] ?? "0",
      gender: map['gender'] ?? '',
      country: map['country'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDetails.fromJson(String source) => UserDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserDetails(name: $name, age: $age, gender: $gender, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserDetails &&
      other.name == name &&
      other.age == age &&
      other.gender == gender &&
      other.country == country;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      age.hashCode ^
      gender.hashCode ^
      country.hashCode;
  }
}