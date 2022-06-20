import 'dart:convert';

class UserDetails {
  final int endDate;
  final bool adminSubscription;
  final String age;
  final String audioType;
  final bool block;
  final int buyDate;
  final String buyMonth;
  final String country;
  final String email;
  final String expMonth;
  final String gender;
  final String name;
  final bool rewards;
  final int subMonths;
  final bool subscription;
  final String time;
  final String uid;
  UserDetails({
    required this.endDate,
    required this.adminSubscription,
    required this.age,
    required this.audioType,
    required this.block,
    required this.buyDate,
    required this.buyMonth,
    required this.country,
    required this.email,
    required this.expMonth,
    required this.gender,
    required this.name,
    required this.rewards,
    required this.subMonths,
    required this.subscription,
    required this.time,
    required this.uid,
  });

  UserDetails copyWith({
    int? endDate,
    bool? adminSubscription,
    String? age,
    String? audioType,
    bool? block,
    int? buyDate,
    String? buyMonth,
    String? country,
    String? email,
    String? expMonth,
    String? gender,
    String? name,
    bool? rewards,
    int? subMonths,
    bool? subscription,
    String? time,
    String? uid,
  }) {
    return UserDetails(
      endDate: endDate ?? this.endDate,
      adminSubscription: adminSubscription ?? this.adminSubscription,
      age: age ?? this.age,
      audioType: audioType ?? this.audioType,
      block: block ?? this.block,
      buyDate: buyDate ?? this.buyDate,
      buyMonth: buyMonth ?? this.buyMonth,
      country: country ?? this.country,
      email: email ?? this.email,
      expMonth: expMonth ?? this.expMonth,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      rewards: rewards ?? this.rewards,
      subMonths: subMonths ?? this.subMonths,
      subscription: subscription ?? this.subscription,
      time: time ?? this.time,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'endDate': endDate,
      'adminSubscription': adminSubscription,
      'age': age,
      'audioType': audioType,
      'block': block,
      'buyDate': buyDate,
      'buyMonth': buyMonth,
      'country': country,
      'email': email,
      'expMonth': expMonth,
      'gender': gender,
      'name': name,
      'rewards': rewards,
      'subMonths': subMonths,
      'subscription': subscription,
      'time': time,
      'uid': uid,
    };
  }

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      endDate: map['endDate'] as int,
      adminSubscription: map['adminSubscription'] as bool,
      age: map['age'] as String,
      audioType: map['audioType'] as String,
      block: map['block'] as bool,
      buyDate: map['buyDate'] as int,
      buyMonth: map['buyMonth'] as String,
      country: map['country'] as String,
      email: map['email'] as String,
      expMonth: map['expMonth'] as String,
      gender: map['gender'] as String,
      name: map['name'] as String,
      rewards: map['rewards'] as bool,
      subMonths: map['subMonths'].toInt() as int,
      subscription: map['subscription'] as bool,
      time: map['time'] as String,
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDetails.fromJson(String source) =>
      UserDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserDetails(endDate: $endDate, adminSubscription: $adminSubscription, age: $age, audioType: $audioType, block: $block, buyDate: $buyDate, buyMonth: $buyMonth, country: $country, email: $email, expMonth: $expMonth, gender: $gender, name: $name, rewards: $rewards, subMonths: $subMonths, subscription: $subscription, time: $time, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserDetails &&
        other.endDate == endDate &&
        other.adminSubscription == adminSubscription &&
        other.age == age &&
        other.audioType == audioType &&
        other.block == block &&
        other.buyDate == buyDate &&
        other.buyMonth == buyMonth &&
        other.country == country &&
        other.email == email &&
        other.expMonth == expMonth &&
        other.gender == gender &&
        other.name == name &&
        other.rewards == rewards &&
        other.subMonths == subMonths &&
        other.subscription == subscription &&
        other.time == time &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return endDate.hashCode ^
        adminSubscription.hashCode ^
        age.hashCode ^
        audioType.hashCode ^
        block.hashCode ^
        buyDate.hashCode ^
        buyMonth.hashCode ^
        country.hashCode ^
        email.hashCode ^
        expMonth.hashCode ^
        gender.hashCode ^
        name.hashCode ^
        rewards.hashCode ^
        subMonths.hashCode ^
        subscription.hashCode ^
        time.hashCode ^
        uid.hashCode;
  }
}
