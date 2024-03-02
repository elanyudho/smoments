import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:smoments/domain/provider/post_provider.dart';
import 'package:smoments/domain/provider/stories_provider.dart';
import 'package:smoments/routes/router.dart';
import 'package:smoments/utils/error_post.dart';

import '../res/colors.dart';

class PostStoryScreen extends StatefulWidget {
  const PostStoryScreen({super.key});

  @override
  State<PostStoryScreen> createState() => _PostStoryScreenState();
}

class _PostStoryScreenState extends State<PostStoryScreen> {
  final captionController = TextEditingController();
  var isReachMaxLength = false;
  var isCaptionEmpty = false;
  late GoogleMapController mapPostController;
  late GoogleMapController mapBottomSheetController;

  @override
  void dispose() {
    captionController.dispose();
    mapPostController.dispose();
    mapBottomSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeColors.whiteColor,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: ThemeColors.whiteColor,
          shape:
              const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Provider.of<PostProvider>(context, listen: false).clearState();
              context.pop();
            },
          ),
          actions: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: ElevatedButton(
                onPressed: () async {
                  var state = await _onUpload();
                  switch (state) {
                    case ErrorPostState.noError:
                      Provider.of<StoriesProvider>(context, listen: false)
                          .clearList();
                      Provider.of<StoriesProvider>(context, listen: false)
                          .getStories(StoriesProvider.initPage);
                      context.go(pathHome);
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Success upload'),
                        ),
                      );
                      break;
                    case ErrorPostState.errorNetwork:
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Failed to upload'),
                        ),
                      );
                      break;
                    case ErrorPostState.errorField:
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Fill caption and upload an image'),
                        ),
                      );
                      break;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  // Change button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  // Adjust padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(24), // Round button corners
                  ),
                ),
                child: context.watch<PostProvider>().isLoadingUpload
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: ThemeColors.whiteColor,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Change text color
                        ),
                      ),
              ),
            )
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: ThemeColors.primaryColor,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(children: [
                      TextField(
                        textInputAction: TextInputAction.newline,
                        controller: captionController,
                        maxLength: 300,
                        onChanged: (value) {
                          setState(() {
                            isReachMaxLength = value.length >= 300;
                            isCaptionEmpty = value.isEmpty;
                          });
                        },
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          hintText: 'What is Happening?',
                          border: InputBorder.none,
                        ),
                        cursorColor: ThemeColors.primaryColor,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        maxLines: null,
                      ),
                      const SizedBox(height: 16),
                      context.watch<PostProvider>().imagePath == null
                          ? Container()
                          : _showImage(),
                      const SizedBox(height: 16),
                      context.watch<PostProvider>().long == 0.0
                          ? Container()
                          : _showMap(context.watch<PostProvider>().lat,
                              context.watch<PostProvider>().long),
                      const SizedBox(height: 8),
                      context.watch<PostProvider>().long == 0.0
                          ? Container()
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  size: 18,
                                  Icons.location_on,
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(width: 8),
                                Consumer<PostProvider>(
                                  builder: (context, postProvider, child) {
                                    return Flexible(
                                      child: Text(
                                        postProvider.address,
                                        softWrap: true,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.125,
                      )
                    ]),
                  )),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                ),
                height: MediaQuery.of(context).size.width * 0.125,
                child: Row(children: [
                  IconButton(
                      onPressed: () {
                        _onGalleryView();
                      },
                      icon: const Icon(Icons.image_outlined,
                          color: ThemeColors.primaryColor)),
                  IconButton(
                      onPressed: () {
                        _onCameraView();
                      },
                      icon: const Icon(Icons.camera_alt_outlined,
                          color: ThemeColors.primaryColor)),
                  IconButton(
                      onPressed: () {
                        _showChooseLocationDialog(context);
                      },
                      icon: const Icon(Icons.location_on_outlined,
                          color: ThemeColors.primaryColor)),
                  isReachMaxLength
                      ? const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Reach Max Caption Length',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        )
                      : Container()
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<ErrorPostState> _onUpload() async {
    final provider = context.read<PostProvider>();
    final imagePath = provider.imagePath;
    final imageFile = provider.imageFile;
    if (imagePath == null || imageFile == null || isCaptionEmpty) {
      return ErrorPostState.errorField;
    }

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();
    await provider.postStory(captionController.text, context.read<PostProvider>().lat.toString(), context.read<PostProvider>().long.toString(), bytes, fileName);
    var isErrorNetwork =
        Provider.of<PostProvider>(context, listen: false).isErrorUpload;
    return isErrorNetwork
        ? ErrorPostState.errorNetwork
        : ErrorPostState.noError;
  }

  _onGalleryView() async {
    final provider = context.read<PostProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<PostProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<PostProvider>().imagePath;
    return kIsWeb
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imagePath.toString(),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(imagePath.toString()),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          );
  }

  void _showChooseLocationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Choose Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              content: SizedBox(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  GestureDetector(
                    onTap: () {
                      context.pop();
                      _initLocation(() {});
                    },
                    child: const Row(
                      children: [
                        Icon(
                          size: 20,
                          Icons.add_location_alt_outlined,
                          color: ThemeColors.primaryColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Your current location',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      final BuildContext context = this.context;

                      context.pop();
                      _initLocation(() {
                        var provider =
                            Provider.of<PostProvider>(context, listen: false);

                        _showPickLocationBottomSheet(
                            context, provider.long, provider.lat);
                      });
                    },
                    child: const Row(
                      children: [
                        Icon(
                          size: 20,
                          Icons.map_outlined,
                          color: ThemeColors.primaryColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Choose location from maps',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  )
                ]),
              ),
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none));
        });
  }

  //show map widget. Will show after init location
  Widget _showMap(double lat, double long) {
    final LatLng position = LatLng(lat, long);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: GoogleMap(
          markers: context.watch<PostProvider>().markers,
          initialCameraPosition: CameraPosition(
            zoom: 15,
            target: position,
          ),
          onMapCreated: (controller) {
            setState(() {
              mapPostController = controller;
            });
          },
        ),
      ),
    );
  }

  //get current location
  void _initLocation(Function callback) async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);
    _setAddress(locationData.longitude!, locationData.latitude!);
    Provider.of<PostProvider>(context, listen: false).setLatLong(locationData.latitude!, locationData.longitude!);
    setMarker(latLng);
    callback();
  }

  // set address by long lat
  void _setAddress(double long, double lat) async {
    final info = await geo.placemarkFromCoordinates(lat, long);
    final place = info[0];
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      Provider.of<PostProvider>(context, listen: false).setAddress(address);
    });
  }

  // create marker
  void setMarker(LatLng latLng) {
    setState(() {
      final marker = Marker(
        markerId: const MarkerId("positionStory"),
        position: latLng,
        infoWindow: const InfoWindow(title: 'Your Location'),
      );
      context.read<PostProvider>().addOneMarker(marker);
    });
  }

  //pick location when on long press
  void onLongPressGoogleMap(LatLng latLng) async {
    _setAddress(latLng.longitude, latLng.latitude);

    context.read<PostProvider>().setLatLong(latLng.latitude, latLng.longitude);
    mapBottomSheetController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
    mapPostController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  // show maps from bottom sheet to pick location
  void _showPickLocationBottomSheet(
      BuildContext context, double long, double lat) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        useSafeArea: true,
        builder: (context) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GoogleMap(
                          markers: context.watch<PostProvider>().markers,
                          initialCameraPosition: CameraPosition(
                              zoom: 15, target: LatLng(lat, long)),
                          onMapCreated: (controller) {
                            setState(() {
                              mapBottomSheetController = controller;
                            });
                          },
                          onLongPress: (LatLng latLng) {
                            onLongPressGoogleMap(latLng);
                            setMarker(latLng);
                          }),
                    )
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    height: MediaQuery.of(context).size.width * 0.125,
                    child: Row(children: [
                      IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: const Icon(Icons.close, color: Colors.black)),
                      SizedBox(width: 16),
                      Consumer<PostProvider>(
                        builder: (context, postProvider, child) {
                          return Expanded(
                            child: Text(
                              postProvider.address,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.location_on_outlined, color: ThemeColors.primaryColor),
                      const SizedBox(width: 16),
                    ]),
                  ),
                )
              ],
            ),
          );
        });
  }
}
