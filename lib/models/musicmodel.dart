// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MusicModel {
  final String duration;
  final String name;
  final String image;
  final String link;
  final int price;
  MusicModel({
    required this.duration,
    required this.name,
    required this.image,
    required this.link,
    required this.price,
  });

  MusicModel copyWith({
    String? duration,
    String? name,
    String? image,
    String? link,
    int? price,
  }) {
    return MusicModel(
      duration: duration ?? this.duration,
      name: name ?? this.name,
      image: image ?? this.image,
      link: link ?? this.link,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'duration': duration,
      'name': name,
      'image': image,
      'link': link,
      'price': price,
    };
  }

  factory MusicModel.fromMap(Map<String, dynamic> map) {
    return MusicModel(
      duration: map['duration'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
      link: map['link'] as String,
      price: map['price'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MusicModel.fromJson(String source) => MusicModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MusicModel(duration: $duration, name: $name, image: $image, link: $link, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MusicModel &&
      other.duration == duration &&
      other.name == name &&
      other.image == image &&
      other.link == link &&
      other.price == price;
  }

  @override
  int get hashCode {
    return duration.hashCode ^
      name.hashCode ^
      image.hashCode ^
      link.hashCode ^
      price.hashCode;
  }
}
