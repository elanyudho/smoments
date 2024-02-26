import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:smoments/domain/provider/stories_provider.dart';
import 'package:smoments/res/colors.dart';
import 'package:smoments/widgets/item_story.dart';

import '../res/assets.dart';
import '../utils/result_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  var page = 2;
  var hasMore = true;
  var isLoadingPagination = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetchStories();
      }
    });
  }

  Future refresh() async {
    setState(() {
      isLoadingPagination = false;
      hasMore = true;
      page = 0;
      Provider.of<StoriesProvider>(context, listen: false).clearList();
    });

    fetchStories();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void fetchStories() {
    if (isLoadingPagination) return;
    isLoadingPagination = true;
    Provider.of<StoriesProvider>(context, listen: false)
        .getStories(page.toString());
    page++;
    isLoadingPagination = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeColors.whiteColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: AppBar(
            backgroundColor: ThemeColors.whiteColor,
            flexibleSpace: Column(
              children: [
                Expanded(flex: 1, child: Container()),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: SvgPicture.asset(assetLogoBlue),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Expanded(
                    flex: 1,
                    child: Text(
                      'For You',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                Container(
                    width: double.infinity, color: Colors.black26, height: 1)
              ],
            ),
          ),
        ),
        body: Consumer<StoriesProvider>(builder: (context, state, _) {
          switch (state.stateHome) {
            case ResultState.loading:
              return const Center(child: CircularProgressIndicator());
            case ResultState.noData:
              return Center(
                child: Material(
                  child: Text(state.storiesResponse.message),
                ),
              );
            case ResultState.error:
              return Center(
                child: Material(
                  child: Text(state.storiesResponse.message),
                ),
              );
            case ResultState.hasData:
              var allItem = state.listStory;

              return RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    controller: controller,
                    itemCount: allItem.length + 1,
                    itemBuilder: (context, index) {
                      if (index < allItem.length) {
                        return StoryItem(
                            username: allItem[index].name,
                            caption: allItem[index].description,
                            image: allItem[index].photoUrl,
                            date: allItem[index].createdAt.toString());
                      } else {
                        return context.watch<StoriesProvider>().hasMore
                            ? Center(child: CircularProgressIndicator())
                            : Container();
                      }
                    }),
              );
          }
        }),
      ),
    );
  }
}
