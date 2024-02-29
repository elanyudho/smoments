import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smoments/data/remote/api/api_service.dart';

import '../../data/remote/response/default_response.dart';
import '../../utils/helper/preference_helper.dart';

class PostProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;

  ApiService apiService;
  PreferencesHelper preferenceHelper;

  PostProvider ({required this.apiService, required this.preferenceHelper});

  bool isLoadingUpload = false;
  bool isErrorUpload = false;

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  Future<dynamic> postStory(String description, List<int> photo, String fileName) async {
    isLoadingUpload = true;
    notifyListeners();
    try {
      final result = await apiService.postStory(description, photo, fileName, (await preferenceHelper.user)?.token ?? '');
      isLoadingUpload = false;
      isErrorUpload = false;
      _clearImageState();
      notifyListeners();
      return result;
    } catch(e) {
      isLoadingUpload = false;
      isErrorUpload = true;
      notifyListeners();
      return DefaultResponse(error: true, message: e.toString());
    }
  }

  void _clearImageState() {
    imagePath = null;
    imageFile = null;
  }
}