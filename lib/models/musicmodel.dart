// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MusicModel {
  String name;
  String duration;
  String image;
  MusicModel({
    required this.name,
    required this.duration,
    required this.image,
  });

  MusicModel copyWith({
    String? name,
    String? duration,
    String? image,
  }) {
    return MusicModel(
      name: name ?? this.name,
      duration: duration ?? this.duration,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'duration': duration,
      'image': image,
    };
  }

  factory MusicModel.fromMap(Map<String, dynamic> map) {
    return MusicModel(
      name: map['name'] as String,
      duration: map['duration'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MusicModel.fromJson(String source) => MusicModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MusicModel(name: $name, duration: $duration, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MusicModel &&
      other.name == name &&
      other.duration == duration &&
      other.image == image;
  }

  @override
  int get hashCode => name.hashCode ^ duration.hashCode ^ image.hashCode;
}
