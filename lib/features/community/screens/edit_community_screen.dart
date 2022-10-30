import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_it/core/common/error_text.dart';
import 'package:red_it/core/common/loader.dart';
import 'package:red_it/core/constants/constant.dart';
import 'package:red_it/features/community/controller/community_controller.dart';
import 'package:red_it/models/community_model.dart';
import 'package:red_it/theme/pallete.dart';

import '../../../core/utils.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;
  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
        community: community,
        bannerFile: bannerFile,
        profileFile: profileFile,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (data) => Scaffold(
              backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
              appBar: AppBar(
                title: const Text("Edit Community"),
                actions: [
                  TextButton(
                    onPressed: () =>save(data),
                    child: const Text("Save"),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () => selectBannerImage(),
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              color: Pallete
                                  .darkModeAppTheme.textTheme.bodyText2!.color!,
                              strokeCap: StrokeCap.round,
                              dashPattern: const [10, 4],
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: bannerFile != null
                                    ? Image.file(bannerFile!)
                                    : data.banner.isEmpty ||
                                            data.banner ==
                                                Contstant.bannerDefault
                                        ? const Center(
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              size: 40,
                                            ),
                                          )
                                        : Image.network(data.banner),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            bottom: 20,
                            child: GestureDetector(
                              onTap: selectProfileImage,
                              child: profileFile != null
                                  ? CircleAvatar(
                                      radius: 30,
                                      backgroundImage: FileImage(profileFile!),
                                    )
                                  : CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          NetworkImage(data.avatar),
                                    ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        error: (error, trace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
