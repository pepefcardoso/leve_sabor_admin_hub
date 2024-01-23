class BlogPostImage {
  final int? id;
  final String? name;
  final String? path;
  final int? blogPostId;
  final String? url;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BlogPostImage({
    this.id,
    this.name,
    this.path,
    this.blogPostId,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  BlogPostImage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        path = json['path'],
        blogPostId = json['blog_post_id'],
        url = json['url'],
        createdAt = json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        updatedAt = json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null;
}
