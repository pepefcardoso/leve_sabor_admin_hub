enum BlogPostStatusEnum {
  draft('Rascunho', 'DRAFT'),
  archived('Arquivado', 'ARCHIVED'),
  published('Publicado', 'PUBLISHED');

  final String label;
  final String value;

  const BlogPostStatusEnum(this.label, this.value);

  static Map<String, String> get toMap {
    return {
      for (var status in BlogPostStatusEnum.values) status.label: status.value,
    };
  }
}
