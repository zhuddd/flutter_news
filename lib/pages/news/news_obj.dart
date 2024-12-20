class MediaBase {
  int id;
  String documentId;
  String url;

  MediaBase({required this.id, required this.documentId, required this.url});

  /// 手动实现从 JSON 构造
  /// 手动实现从 JSON 构造
  factory MediaBase.fromJson(Map<String, dynamic> json) {
    return MediaBase(
      id: json['id'],
      documentId: json['documentId'],
      url: json['url'],
    );
  }

  /// 手动实现转换为 JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'documentId': documentId,
        'url': url,
      };
}

class Author {
  int id;
  String documentId;
  String username;

  Author({required this.id, required this.documentId, required this.username});

  /// 手动实现从 JSON 构造
  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      documentId: json['documentId'],
      username: json['username'],
    );
  }

  /// 手动实现转换为 JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'documentId': documentId,
        'username': username,
      };
}

class Article {
  int id;
  String documentId;
  String title;
  String introduction;
  MediaBase? poster;
  MediaBase? video;
  Author? author;
  String? info;
  String? createdAt;
  String? updatedAt;
  String? publishedAt;

  Article({
    required this.id,
    required this.documentId,
    required this.title,
    required this.introduction,
    this.poster,
    this.video,
    required this.author,
    this.info,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  /// 手动实现从 JSON 构造
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? 0,
      documentId: json['documentId'] ?? '',
      title: json['title'] ?? '',
      introduction: json['introduction'] ?? '',
      poster: json['poster'] != null ? MediaBase.fromJson(json['poster']) : null,
      video: json['video'] != null ? MediaBase.fromJson(json['video']) : null,
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
      info: json['info'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      publishedAt: json['publishedAt'],
    );
  }

  /// 手动实现转换为 JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'documentId': documentId,
    'title': title,
    'introduction': introduction,
    'poster': poster?.toJson(),
    'video': video?.toJson(),
    'author': author?.toJson(),
    'info': info,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'publishedAt': publishedAt,
  };
}
