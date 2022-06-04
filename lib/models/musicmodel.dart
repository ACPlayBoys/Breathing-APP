import 'dart:convert';

class MusicModel {
  final String duration;
  final String name;
  final String image;
  final String link;
  MusicModel({
    required this.duration,
    required this.name,
    required this.image,
    required this.link,
  });

  MusicModel copyWith({
    String? duration,
    String? name,
    String? image,
    String? link,
  }) {
    return MusicModel(
      duration: duration ?? this.duration,
      name: name ?? this.name,
      image: image ?? this.image,
      link: link ?? this.link,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'duration': duration,
      'name': name,
      'image': image,
      'link': link,
    };
  }

  factory MusicModel.fromMap(Map<String, dynamic> map) {
    return MusicModel(
      duration: map['duration'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
      link: map['link'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MusicModel.fromJson(String source) => MusicModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MusicModel(duration: $duration, name: $name, image: $image, link: $link)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MusicModel &&
      other.duration == duration &&
      other.name == name &&
      other.image == image &&
      other.link == link;
  }

  @override
  int get hashCode {
    return duration.hashCode ^
      name.hashCode ^
      image.hashCode ^
      link.hashCode;
  }
}