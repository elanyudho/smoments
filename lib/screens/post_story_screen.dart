import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Scaffold(
      backgroundColor: ThemeColors.whiteColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: ThemeColors.whiteColor,
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        actions: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: ElevatedButton(
              onPressed: () async {
                var state = await _onUpload();
                switch(state) {
                  case ErrorPostState.noError:
                    Provider.of<StoriesProvider>(context,
                        listen: false).clearList();
                    Provider.of<StoriesProvider>(context,
                        listen: false).getStories(StoriesProvider.initPage);
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        hintText: 'What is Happening?',
                        border: InputBorder.none,
                      ),
                      cursorColor: ThemeColors.primaryColor,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      maxLines: null,
                    ),
                    const SizedBox(height: 16),
                    context.watch<PostProvider>().imagePath == null
                        ? Container()
                        : _showImage(),
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
    );
  }

  Future<ErrorPostState> _onUpload() async {
    final provider = context.read<PostProvider>();
    final imagePath = provider.imagePath;
    final imageFile = provider.imageFile;
    if (imagePath == null || imageFile == null || isCaptionEmpty) return ErrorPostState.errorField;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();
    await provider.postStory(captionController.text, bytes, fileName);
    var isErrorNetwork =  Provider.of<PostProvider>(context,
        listen: false).isErrorUpload;
    print(isErrorNetwork.toString());
    return isErrorNetwork ? ErrorPostState.errorNetwork : ErrorPostState.noError;
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
}
