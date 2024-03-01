import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smoments/domain/provider/stories_provider.dart';
import 'package:smoments/routes/router.dart';
import 'package:smoments/utils/result_state.dart';
import 'package:smoments/utils/text_extension.dart';

import '../res/assets.dart';
import '../res/colors.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0.0,
              title: const Text(
                'Story',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              shape: const Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            body: Consumer<StoriesProvider>(builder: (context, state, _) {
              switch (state.stateDetail) {
                case ResultState.loading:
                  return const Center(
                      child: CircularProgressIndicator(
                    color: ThemeColors.primaryColor,
                  ));
                case ResultState.error:
                  return Material(child: Text(state.errorResponse.message));
                case ResultState.noData:
                  return Material(
                      child: Text(state.detailStoryResponse.message));
                case ResultState.hasData:
                  final data = state.detailStoryResponse.story;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
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
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          data.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Flexible(
                                            flex: 1,
                                            child: SvgPicture.asset(
                                                assetVerified)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              data.description,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(data.photoUrl,
                                width: double.infinity,
                                fit: BoxFit.cover, errorBuilder: (_, __, ___) {
                              return const Icon(Icons.error,
                                  color: ThemeColors.primaryColor);
                            }),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                '${formatTime(data.createdAt.toString())} · ${formatDate(data.createdAt.toString())}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                              if (data.lon > 0.0 || data.lat >= 0.0)
                                const Text(
                                ' · ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                              if (data.lon > 0.0 || data.lat >= 0.0)
                                GestureDetector(
                                onTap: () {
                                  context.goNamed(nameLocation, queryParameters: {'name': data.name, 'caption': data.description, 'long': data.lon.toString(), 'lat': data.lat.toString()});
                                },
                                child: const Row(
                                  children: [
                                    Icon(size:20, Icons.location_on_outlined, color: ThemeColors.primaryColor,),
                                    Text(
                                    'Location',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  )],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
              }
            })));
  }
}
