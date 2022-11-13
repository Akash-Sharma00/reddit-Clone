import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_it/features/auth/controller/auth_controller.dart';
import 'package:red_it/features/user_profile/controller/user_profile_controller.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constant.dart';
import '../../../core/utils.dart';
import '../../../theme/pallete.dart';

class EditUserScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditUserScreen({required this.uid, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends ConsumerState<EditUserScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

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

  void save() {
    ref.read(userProfileControllerProvider.notifier).editCommunity(
        name: nameController.text,
        bannerFile: bannerFile,
        profileFile: profileFile,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifiereProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
        data: (data) => Scaffold(
              backgroundColor: currentTheme.backgroundColor,
              appBar: AppBar(
                title: const Text("Edit Profile"),
                actions: [
                  TextButton(
                    onPressed: () {
                      save();
                    },
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
                              color: currentTheme.textTheme.bodyText2!.color!,
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
                                                Constants.bannerDefault
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
                                          NetworkImage(data.profilePic),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: "Name",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        error: (error, trace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
