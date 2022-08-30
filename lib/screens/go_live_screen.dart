// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_live/resources/firestore_methods.dart';
import 'package:go_live/screens/broadcast_screen.dart';
import 'package:go_live/utils/colors.dart';
import 'package:go_live/utils/utils.dart';
import 'package:go_live/widgets/custom_butoon.dart';
import 'package:go_live/widgets/custom_text_field.dart';

class GoLiveScreen extends StatefulWidget {
  const GoLiveScreen({Key? key}) : super(key: key);

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  final TextEditingController _titleController = TextEditingController();
  Uint8List? image;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  goLiveStream() async {
    String channelId = await FirestoreMethods().startLiveStream(
      context,
      _titleController.text,
      image,
    );

    if (channelId.isNotEmpty) {
      showSnackBar(context, 'LiveStream has started successfully.');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BroadcastScreen(
            channelId: channelId,
            isBroadcaster: true,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      Uint8List? pickedImage = await pickImage();
                      if (pickedImage != null) {
                        setState(() {
                          image = pickedImage;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 20,
                      ),
                      child: image != null
                          ? SizedBox(
                              height: 300,
                              child: Image.memory(image!),
                            )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              color: buttonColor,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: buttonColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.folder_open,
                                      color: buttonColor,
                                      size: 40,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Select your Thumbnail',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Title',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: CustomTextField(
                          controller: _titleController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: CustomButton(
                  text: 'Go Live',
                  onTap: goLiveStream,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
