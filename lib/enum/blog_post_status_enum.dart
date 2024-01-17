enum BlogPostStatusEnum {
  draft('Rascunho', 'DRAFT'),
  archived('Arquivado', 'ARCHIVED'),
  published('Publicado', 'PUBLISHED');

  final String label;
  final String value;

  const BlogPostStatusEnum(this.label, this.value);
}
