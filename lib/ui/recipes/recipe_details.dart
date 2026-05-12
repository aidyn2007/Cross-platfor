import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../data/models/recipe.dart';
import '../../network/model_response.dart';
import '../theme/colors.dart';
import '../widgets/common.dart';

class RecipeDetails extends ConsumerStatefulWidget {
  final Recipe recipe;

  const RecipeDetails({
    super.key,
    required this.recipe,
  });

  @override
  ConsumerState<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends ConsumerState<RecipeDetails> {
  Recipe? recipeDetail;

  @override
  void initState() {
    super.initState();
    loadRecipe();
  }

  void loadRecipe() async {
    if (widget.recipe.sourceId == null) {
      recipeDetail = widget.recipe;
      return;
    }

    final bookId = widget.recipe.sourceId ?? widget.recipe.id.toString();
    final response = await ref.read(serviceProvider).queryRecipe(bookId);
    final result = response.body;
    if (result is Success<Recipe>) {
      final body = result.value;
      if (mounted) {
        setState(() {
          recipeDetail = body;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.label ?? 'Details'),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          height: maxHeight,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                topImage(context),
                sizedW16,
                Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      children: [
                        titleRow(),
                        description(),
                        sizedW16,
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          width: size.width,
          height: 150,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.0, 0.5, 1.0],
                  colors: [lightGreen, Colors.white, lightGreen]),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Hero(
            tag: 'recipe-${widget.recipe.id}',
            child: _buildBookImage(),
          ),
        ),
      ],
    );
  }

  Widget _buildBookImage() {
    final image = widget.recipe.image ?? '';

    if (image.startsWith('assets/')) {
      return Image.asset(
        image,
        alignment: Alignment.topCenter,
        fit: BoxFit.contain,
        height: 150,
        width: 200,
      );
    }

    return CachedNetworkImage(
      imageUrl: image,
      alignment: Alignment.topCenter,
      fit: BoxFit.contain,
      placeholder: (context, url) => const CircularProgressIndicator(),
      height: 150,
      width: 200,
    );
  }

  Widget titleRow() {
    final repository = ref.read(repositoryProvider.notifier);
    final bookmarked = widget.recipe.bookmarked;
    const titleRowColor = Colors.black;
    return Container(
      decoration: const BoxDecoration(color: lightGreen),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          children: [
            Expanded(
              child: AutoSizeText(
                widget.recipe.label ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 24, color: titleRowColor),
              ),
            ),
            IconButton(
              icon: Icon(
                bookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: titleRowColor,
              ),
              onPressed: () {
                if (!bookmarked) {
                  if (recipeDetail != null) {
                    repository
                        .insertRecipe(recipeDetail!.copyWith(bookmarked: true));
                  }
                } else {
                  if (recipeDetail != null) {
                    repository.deleteRecipe(recipeDetail!);
                  }
                }
                Navigator.pop(context);
              },
            ),
            sizedW8,
          ],
        ),
      ),
    );
  }

  Widget description() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
      child: Html(data: recipeDetail?.description ?? 'Loading description...'),
    );
  }
}
