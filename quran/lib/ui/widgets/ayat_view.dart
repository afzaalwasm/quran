// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quran/model/ayat_model.dart';
import 'package:share/share.dart';

class AyatView extends StatefulWidget {
  final AyatModel ayatModel;
  final String fontFamily;
  final String totalVerses;
  final String currentVerseNumber;
  final String surahName;

  const AyatView(
      {required this.ayatModel,
      required this.fontFamily,
      required this.currentVerseNumber,
      required this.totalVerses,
      required this.surahName});
  @override
  _AyatViewState createState() => _AyatViewState();
}

class _AyatViewState extends State<AyatView> {
  bool _showTrnaslation = false;
  var translation = '';
  var shareArabic = false;
  var shareEnglish = false;
  var shareUrdu = false;
  var shareChinese = false;

  @override
  void initState() {
    setState(() {
      translation = widget.ayatModel.english!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Column(children: [
        ContainerPlus(
            border: BorderPlus(color: Colors.amber, width: 2),
            radius: RadiusPlus.all(5),
            child: Column(
              children: [
                ContainerPlus(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Text(
                          'verse ${widget.currentVerseNumber} of ${widget.totalVerses}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                ContainerPlus(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      widget.ayatModel.arabic!,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontFamily: widget.fontFamily,
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                _showTrnaslation
                    ? Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Text(
                          translation,
                          style: const TextStyle(color: Colors.black),
                        ),
                      )
                    : Container(),
                ContainerPlus(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => ShareDialogue(
                                      surahName: widget.surahName,
                                      ayatModel: widget.ayatModel,
                                    ));
                          },
                          icon: const Icon(
                            Icons.share,
                            size: 16,
                          )),
                      ButtonPlus(
                        child: const Text(
                          'English',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          setState(() {
                            _showTrnaslation = true;
                            translation = widget.ayatModel.english!;
                          });
                        },
                      ),
                      ButtonPlus(
                        child: const Text(
                          'اُردو',
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Jameel"),
                        ),
                        onPressed: () {
                          setState(() {
                            _showTrnaslation = true;
                            translation = widget.ayatModel.urdu!;
                          });
                        },
                      ),
                      ButtonPlus(
                        child: const Text(
                          'Chinese',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          setState(() {
                            _showTrnaslation = true;
                            translation = widget.ayatModel.chiness!;
                          });
                        },
                      ),
                      Visibility(
                          visible: _showTrnaslation,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_drop_up),
                            onPressed: () {
                              setState(() {
                                _showTrnaslation = false;
                              });
                            },
                          ))
                    ],
                  ),
                ),
              ],
            )),
      ]),
    );
  }
}

class ShareDialogue extends StatefulWidget {
  const ShareDialogue({required this.ayatModel, required this.surahName})
      : super();
  final AyatModel ayatModel;
  final String surahName;

  @override
  State<ShareDialogue> createState() => _ShareDialogueState();
}

class _ShareDialogueState extends State<ShareDialogue> {
  var shareArabicValue = false;
  var shareEnglishValue = false;
  var shareUrduValue = false;
  var shareChineseValue = false;

  shareAction() {
    var shareString = '';
    if (shareArabicValue ||
        shareEnglishValue ||
        shareUrduValue ||
        shareChineseValue) {
      if (shareArabicValue) {
        shareString = shareString + widget.ayatModel.arabic! + "\n\n";
      }
      if (shareEnglishValue) {
        shareString = shareString + widget.ayatModel.english! + "\n\n";
      }
      if (shareUrduValue) {
        shareString = shareString + widget.ayatModel.urdu! + "\n\n";
      }
      if (shareChineseValue) {
        shareString = shareString + widget.ayatModel.chiness! + "\n\n";
      }
      shareString =
          shareString + "\n" + "${widget.surahName} ${widget.ayatModel.id}";
      Get.back();
      Share.share(shareString);
    } else {
      Fluttertoast.showToast(msg: 'Select Atleast One Language');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ContainerPlus(
          color: Colors.white,
          width: Get.width * 0.8,
          border: BorderPlus(color: Colors.amber),
          radius: RadiusPlus.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                child: const Text(
                  'Select The Language In Which You Want to Share This Verse',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Arabic',
                        style: TextStyle(fontSize: 20),
                      ),
                      CupertinoSwitch(
                          activeColor: Colors.amber,
                          value: shareArabicValue,
                          onChanged: (v) {
                            setState(() {
                              shareArabicValue = v;
                            });
                          })
                    ]),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'English',
                        style: TextStyle(fontSize: 20),
                      ),
                      CupertinoSwitch(
                          activeColor: Colors.amber,
                          value: shareEnglishValue,
                          onChanged: (v) {
                            setState(() {
                              shareEnglishValue = v;
                            });
                          })
                    ]),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Urdu',
                        style: TextStyle(fontSize: 20),
                      ),
                      CupertinoSwitch(
                          activeColor: Colors.amber,
                          value: shareUrduValue,
                          onChanged: (v) {
                            setState(() {
                              shareUrduValue = v;
                            });
                          })
                    ]),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Chinese',
                        style: TextStyle(fontSize: 20),
                      ),
                      CupertinoSwitch(
                          activeColor: Colors.amber,
                          value: shareChineseValue,
                          onChanged: (v) {
                            setState(() {
                              shareChineseValue = v;
                            });
                          })
                    ]),
              ),
              ButtonPlus(
                height: 40,
                width: Get.width * 0.5,
                margin: const EdgeInsets.only(bottom: 15),
                color: Colors.amber,
                radius: RadiusPlus.all(20),
                onPressed: shareAction,
                child: const Text(
                  'Share',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
