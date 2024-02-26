import 'package:flutter/cupertino.dart';
import 'package:smoments/data/remote/api/api_service.dart';
import 'package:smoments/data/remote/response/stories_response.dart';

import '../../data/remote/response/default_response.dart';
import '../../utils/helper/preference_helper.dart';
import '../../utils/result_state.dart';

class StoriesProvider extends ChangeNotifier {

  ApiService apiService;
  PreferencesHelper preferencesHelper;
  static const initPage = '1';

  StoriesProvider ({required this.apiService, required this.preferencesHelper}) {
    getStories(initPage);
  }

  final List<ListStory> _listStory = [];
  final List<ListStory> _listStoryPage = [];
  late StoriesResponse _storiesResponse;
  var _hasMore = true;
  ResultState _stateHome = ResultState.noData;

  StoriesResponse get storiesResponse  => _storiesResponse;
  ResultState get stateHome => _stateHome;
  List<ListStory> get listStory => _listStory;
  bool get hasMore => _hasMore;


  Future <dynamic> getStories(String page) async {
    try {
      if(listStory.isEmpty) {
        _stateHome = ResultState.loading;
        notifyListeners();
      }
      final stories = await apiService.getStories(page, (await preferencesHelper.user)?.token ?? '');

      if (stories.error) {
        _stateHome = ResultState.error;
        _storiesResponse = stories;
        notifyListeners();
        return storiesResponse;
      }

      if (stories.listStory.isEmpty && _listStory.isEmpty) {
        _stateHome = ResultState.noData;
        _storiesResponse = stories;
        notifyListeners();
        return storiesResponse;
      }

      _stateHome = ResultState.hasData;
      _storiesResponse = stories;
      _listStoryPage.clear();
      _listStoryPage.addAll(_storiesResponse.listStory);
      _listStory.addAll(_storiesResponse.listStory);
      if (_listStoryPage.length < 10) _hasMore = false;
      notifyListeners();
      return listStory;

    } catch(e) {
      _stateHome = ResultState.error;
      notifyListeners();
      return DefaultResponse(error: true, message: e.toString());
    }
  }

  void clearList() {
    _listStory.clear();
    _listStoryPage.clear();
  }

}