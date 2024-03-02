import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  double _lat = 0.0;
  double _long = 0.0;
  String _address = '';

  double get lat => _lat;
  double get long => _long;
  String get address => _address;

  final Set<Marker> markers = {};

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  Future<dynamic> postStory(String description, String lat, String lon, List<int> photo, String fileName) async {
    isLoadingUpload = true;
    notifyListeners();
    try {
      final result = await apiService.postStory(description, photo, fileName, lat, lon, (await preferenceHelper.user)?.token ?? '');
      isLoadingUpload = false;
      isErrorUpload = false;
      clearState();
      notifyListeners();
      return result;
    } catch(e) {
      isLoadingUpload = false;
      isErrorUpload = true;
      notifyListeners();
      return DefaultResponse(error: true, message: e.toString());
    }
  }

  void setLatLong(double lat, double long) {
    _lat = lat;
    _long = long;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void clearState() {
    imagePath = null;
    imageFile = null;
    _lat = 0.0;
    _long = 0.0;
  }

  void addOneMarker (Marker marker) {
      markers.clear();
      markers.add(marker);
      notifyListeners();
  }
}