import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_it/core/common/error_text.dart';
import 'package:red_it/core/common/loader.dart';
import 'package:red_it/features/community/controller/community_controller.dart';
import 'package:red_it/features/post/controller/add_post_controller.dart';
import 'package:red_it/models/community_model.dart';

import '../../../core/utils.dart';
import '../../../theme/pallete.dart';

class AddPostType extends ConsumerStatefulWidget {
  final String type;
  const AddPostType({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostTypeState();
}

class _AddPostTypeState extends ConsumerState<AddPostType> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController discriptioncontroller = TextEditingController();
  TextEditingController linkcontroller = TextEditingController();
  List<Community> communities = [];
  File? bannerFile;
  Community? selectedCommunity;

  @override
  void dispose() {
    super.dispose();
    titlecontroller.dispose();
    discriptioncontroller.dispose();
    linkcontroller.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titlecontroller.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
          context: context,
          title: titlecontroller.text,
          selectedCommunity: selectedCommunity ?? communities[0],
          file: bannerFile,
          webFile: null);
    } else if (widget.type == 'text' && titlecontroller.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
          context: context,
          title: titlecontroller.text,
          selectedCommunity: selectedCommunity ?? communities[0],
          description: discriptioncontroller.text);
    } else if (widget.type == 'link' && linkcontroller.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titlecontroller.text,
            selectedCommunity: selectedCommunity ?? communities[0],
            link: linkcontroller.text.trim(),
          );
    } else {
      showSnackBar(context, "Enter All Data Correctly");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isImage = widget.type == 'image';
    final isText = widget.type == 'text';
    final isLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifiereProvider);

    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text("Post ${widget.type}"),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text("Share"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titlecontroller,
              maxLength: 30,
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
            const SizedBox(
              height: 10,
            ),
            if (isImage)
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
                          : const Center(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 40,
                              ),
                            )),
                ),
              ),
            if (isText)
              TextField(
                controller: discriptioncontroller,
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Description",
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(18),
                ),
                maxLines: 5,
              ),
            if (isLink)
              TextField(
                controller: linkcontroller,
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Enter Link",
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(18),
                ),
                maxLines: 5,
              ),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text("Select Community"),
            ),
            ref.watch(userCommunitiesProvider).when(
                  data: (data) {
                    communities = data;

                    if (data.isEmpty) {
                      return const SizedBox();
                    }

                    return DropdownButton(
                      value: selectedCommunity ?? data[0],
                      items: data
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedCommunity = val;
                        });
                      },
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          ],
        ),
      ),
    );
  }
}
