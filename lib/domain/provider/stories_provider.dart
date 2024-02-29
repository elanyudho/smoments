
import 'package:flutter/cupertino.dart';
import 'package:smoments/data/remote/api/api_service.dart';
import 'package:smoments/data/remote/response/detail_story_response.dart';
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

  var _hasMore = true;
  final List<ListStory> _listStory = [];
  final List<ListStory> _listStoryPage = [];
  late StoriesResponse _storiesResponse;
  late DetailStoryResponse _detailStoryResponse;
  late DefaultResponse _errorResponse;
  ResultState _stateHome = ResultState.noData;
  ResultState _stateDetail = ResultState.noData;

  StoriesResponse get storiesResponse  => _storiesResponse;
  DefaultResponse get errorResponse  => _errorResponse;
  DetailStoryResponse get detailStoryResponse => _detailStoryResponse;
  ResultState get stateHome => _stateHome;
  ResultState get stateDetail => _stateDetail;
  List<ListStory> get listStory => _listStory;
  bool get hasMore => _hasMore;

  Future <dynamic> getStories(String page) async {
    try {
      if(listStory.isEmpty) {
        _stateHome = ResultState.loading;
        notifyListeners();
      }
      final stories = await apiService.getStories(page, (await preferencesHelper.user)?.token ?? '');

      if (stories.error && listStory.isEmpty) {
        _hasMore = false;
        _stateHome = ResultState.error;
        _storiesResponse = stories;
        _errorResponse = DefaultResponse(error: true, message: stories.message);
        notifyListeners();
        return errorResponse;
      }

      if (stories.listStory.isEmpty && _listStory.isEmpty) {
        _stateHome = ResultState.noData;
        _storiesResponse = stories;
        _hasMore = false;
        notifyListeners();
        return storiesResponse;
      }

      _hasMore = true;
      _stateHome = ResultState.hasData;
      _storiesResponse = stories;
      _listStoryPage.clear();
      _listStoryPage.addAll(_storiesResponse.listStory);
      _listStory.addAll(_storiesResponse.listStory);
      if (_listStoryPage.length < 10) _hasMore = false;
      notifyListeners();
      return listStory;

    } catch(e) {
      _hasMore = false;
      _errorResponse = DefaultResponse(error: true, message: e.toString());
      if(listStory.isEmpty) {
        _stateHome = ResultState.error;
      }
      notifyListeners();
      return errorResponse;

    }
  }

  Future <dynamic> getDetailStory(String id) async {
    try {
      _stateDetail = ResultState.loading;
      notifyListeners();

      final story = await apiService.getDetailStory(id, (await preferencesHelper.user)?.token ?? '');

      if (story.error) {
        _stateDetail = ResultState.error;
        _detailStoryResponse = story;
        _errorResponse = DefaultResponse(error: true, message: _detailStoryResponse.message);
        notifyListeners();
        return errorResponse;
      }

      _stateDetail = ResultState.hasData;
      _detailStoryResponse = story;
      notifyListeners();
      return detailStoryResponse;

    } catch(e) {
      _stateDetail = ResultState.error;
      _errorResponse = DefaultResponse(error: true, message: e.toString());
      notifyListeners();
      return errorResponse;
    }
  }

  void clearList() {
    _listStory.clear();
    _listStoryPage.clear();
  }

}