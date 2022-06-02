import 'dart:convert';

class GifData {
  final String name;
  final String link;
  GifData({
    required this.name,
    required this.link,
  });

  GifData copyWith({
    String? name,
    String? link,
  }) {
    return GifData(
      name: name ?? this.name,
      link: link ?? this.link,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'link': link,
    };
  }

  factory GifData.fromMap(Map<String, dynamic> map) {
    return GifData(
      name: map['name'] as String,
      link: map['link'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GifData.fromJson(String source) => GifData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GifData(name: $name, link: $link)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GifData &&
      other.name == name &&
      other.link == link;
  }

  @override
  int get hashCode => name.hashCode ^ link.hashCode;
}