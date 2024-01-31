import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leve_sabor_admin_hub/components/custom_image_card.dart';
import 'package:leve_sabor_admin_hub/components/custom_list_tag.dart';
import 'package:leve_sabor_admin_hub/components/post_categories_list.dart';
import 'package:leve_sabor_admin_hub/enum/blog_post_status_enum.dart';
import 'package:leve_sabor_admin_hub/model/blog_post.dart';
import 'package:leve_sabor_admin_hub/utils/custom_colors.dart';
import 'package:leve_sabor_admin_hub/utils/tipografia.dart';

class PostsItemList extends StatelessWidget {
  final BlogPost post;
  final Color color;
  final VoidCallback? refreshData;
  final VoidCallback? onConfirmDelete;

  const PostsItemList({
    super.key,
    required this.post,
    required this.color,
    this.refreshData,
    this.onConfirmDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230.0,
      child: Card(
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 4.0,
        child: Stack(
          children: [
            Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                  ),
                  color: color.withOpacity(0.4)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CustomImageCard(
                    url: post.image!.url!,
                    width: 226.0,
                  ),
                  const SizedBox(width: 24.0),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title ?? '',
                                style: Tipografia.titulo2,
                              ),
                              PostCategoriesList(post: post),
                              Text(
                                post.user?.name ?? '',
                                style: Tipografia.corpo2,
                              ),
                              Text(
                                post.formattedCreatedAt ?? '',
                                style: Tipografia.corpo2,
                              ),
                              SizedBox(
                                width: 120.0,
                                child: _statusTag,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () => GoRouter.of(context).go(
                                '/home/blog-posts/edit/${post.id}',
                                extra: () => refreshData?.call(),
                              ),
                              icon: const Icon(Icons.edit),
                              iconSize: 64.0,
                              color: CustomColors.verde1,
                            ),
                            const SizedBox(width: 8.0),
                            IconButton(
                              onPressed: () => _showDeleteDialog(context, () {
                                onConfirmDelete?.call();
                                refreshData?.call();
                                Navigator.of(context).pop();
                              }),
                              icon: const Icon(Icons.delete),
                              iconSize: 64.0,
                              color: CustomColors.verde1,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, VoidCallback onConfirm) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção'),
          content: const Text('Deseja deletar este post?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () => onConfirm(),
            ),
          ],
        );
      },
    );
  }

  CustomListTag get _statusTag {
    switch (post.status) {
      case BlogPostStatusEnum.published:
        return CustomListTag(
          color: CustomColors.verde1.withOpacity(0.4),
          label: post.status?.label ?? '',
        );
      case BlogPostStatusEnum.draft:
        return CustomListTag(
          color: Colors.yellow,
          label: post.status?.label ?? '',
        );
      case BlogPostStatusEnum.archived:
        return CustomListTag(
          color: Colors.red,
          label: post.status?.label ?? '',
        );
      default:
        return CustomListTag(
          color: CustomColors.verde1,
          label: post.status?.label ?? '',
        );
    }
  }
}
