// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GifData {
  final String name;
  final String link;
  final double frames;
  GifData({
    required this.name,
    required this.link,
    required this.frames,
  });

  GifData copyWith({
    String? name,
    String? link,
    double? frames,
  }) {
    return GifData(
      name: name ?? this.name,
      link: link ?? this.link,
      frames: frames ?? this.frames,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'link': link,
      'frames': frames,
    };
  }

  factory GifData.fromMap(Map<String, dynamic> map) {
    return GifData(
      name: map['name'] as String,
      link: map['link'] as String,
      frames: map['frames'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory GifData.fromJson(String source) => GifData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GifData(name: $name, link: $link, frames: $frames)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GifData &&
      other.name == name &&
      other.link == link &&
      other.frames == frames;
  }

  @override
  int get hashCode => name.hashCode ^ link.hashCode ^ frames.hashCode;
}
