import 'package:flutter/material.dart';
import 'package:leve_sabor_admin_hub/components/custom_list_tag.dart';
import 'package:leve_sabor_admin_hub/model/blog_post.dart';
import 'package:leve_sabor_admin_hub/utils/custom_colors.dart';

class PostCategoriesList extends StatelessWidget {
  final BlogPost post;

  const PostCategoriesList({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.0,
      child: ListView.builder(
        itemCount: post.categories!.length,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = post.categories![index];

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomListTag(
                label: category.name,
                color: CustomColors.randomColors[index % CustomColors.randomColors.length].withOpacity(0.3),
              ),
              if (index < post.categories!.length - 1) const SizedBox(width: 8.0),
            ],
          );
        },
      ),
    );
  }
}
