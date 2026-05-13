import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/book_tag.dart';
import '../theme/colors.dart';
import '../widgets/common.dart';
import '../widgets/tag_card.dart';
import '../../providers.dart';

class GroceryList extends ConsumerStatefulWidget {
  const GroceryList({super.key});

  @override
  ConsumerState<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends ConsumerState<GroceryList> {
  final checkBoxValues = <int, bool>{};
  late TextEditingController searchTextController;
  bool showAll = true;

  bool searching = false;
  List<BookTag> searchTags = [];
  final ScrollController _scrollController = ScrollController();
  List<BookTag> currentTags = [];
  final searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchTextController = TextEditingController(text: '');
    final repository = ref.read(repositoryProvider.notifier);
    final tagStream = repository.watchAllTags();
    tagStream.listen(
      (tags) {
        if (mounted) {
          setState(() {
            currentTags = tags;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    searchTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          buildSearchRow(),
          showAll ? buildTagList() : buildNeedHaveList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 160.0,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: background1Color,
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/background1.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNeedHaveList() {
    final needListIndexes = <int, bool>{};
    final haveListIndexes = <int, bool>{};

    for (var index = 0; index < currentTags.length; index++) {
      if (!checkBoxValues.containsKey(index)) {
        needListIndexes[index] = true;
      } else {
        haveListIndexes[index] = true;
      }
    }
    final needList = <BookTag>[];
    final haveList = <BookTag>[];
    for (var index = 0; index < currentTags.length; index++) {
      if (needListIndexes.containsKey(index)) {
        needList.add(currentTags[index]);
      }
      if (haveListIndexes.containsKey(index)) {
        haveList.add(currentTags[index]);
      }
    }
    final columnList = <Widget>[];
    if (needList.isNotEmpty) {
      columnList.add(const Text('Need'));
      columnList.add(tagList(needList, null, false));
    }
    if (haveList.isNotEmpty) {
      columnList.add(const Text('Have'));
      columnList.add(tagList(haveList, null, false));
    }
    return Expanded(
      child: Column(
        children: columnList,
      ),
    );
  }

  Widget buildTagList() {
      if (searching) {
        startSearch(searchTextController.text);
        return tagList(searchTags, checkBoxValues, true);
      } else {
        return tagList(currentTags, checkBoxValues, true);
      }
  }

  Widget tagList(List<BookTag> tags,
      Map<int, bool>? checkBoxValues, bool showCheckbox) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: tags.length,
        itemBuilder: (BuildContext context, int index) {
          final checked = checkBoxValues?[index] ?? false;
          return createTagCard(
              tags[index], checkBoxValues, checked, index, showCheckbox);
        },
      ),
    );
  }

  Widget createTagCard(
      BookTag tag,
      Map<int, bool>? checkBoxValues,
      bool checked,
      int index,
      bool showCheckbox) {
    final even = index % 2 == 0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TagCard(
          name: tag.name ?? '',
          initiallyChecked: checked,
          evenRow: even,
          showCheckbox: showCheckbox,
          onChecked: (newValue) {
            checkBoxValues?[index] = newValue;
          }),
    );
  }

  Widget buildSearchRow() {
    return Row(
      children: [
        sizedW8,
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            startSearch(searchTextController.text);
          },
        ),
        sizedW8,
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search...',
                ),
                focusNode: searchFocusNode,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  startSearch(searchTextController.text);
                },
                controller: searchTextController,
              )),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              searching = false;
              searchTextController.text = '';
            });
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.filter_list,
          ),
          onSelected: (String value) {
            setState(() {
              showAll = value == 'All';
            });
          },
          itemBuilder: (BuildContext context) {
            return [
              CheckedPopupMenuItem(
                value: 'All',
                checked: showAll,
                child: const Text('All'),
              ),
              CheckedPopupMenuItem(
                value: 'Need',
                checked: !showAll,
                child: const Text('Need/Have'),
              ),
            ];
          },
        ),
        sizedW8,
      ],
    );
  }

  void startSearch(String searchString) {
    searching = searchString.isNotEmpty;
    searchTags = currentTags
        .where((element) => element.name?.toLowerCase().contains(searchString.toLowerCase()) ?? false)
        .toList();
    setState(() {});
  }
}
