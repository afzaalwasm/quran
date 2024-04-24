import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quran/model/ayat_model.dart';
import 'package:quran/ui/widgets/ayat_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../common/constants.dart';

class SingleSurahPage extends StatefulWidget {
  const SingleSurahPage({Key? key}) : super(key: key);

  @override
  _SingleSurahPageState createState() => _SingleSurahPageState();
}

class _SingleSurahPageState extends State<SingleSurahPage> {
  List<AyatModel> versese = [];
  final ItemScrollController _itemScrollController = ItemScrollController();
  final TextEditingController textEditingController = TextEditingController();
  var surahName = '';
  String currentFont = Al_Majeed_Quran;
  String surahNumber = '';
  bool surahLoaded = false;

  Future<void> loadJson() async {
    try {
      final String response =
          await rootBundle.loadString('assets/quran/$surahNumber.json');
      final data = await json.decode(response);
      setState(() {
        surahName = data['name'];
      });
      for (var verse in data['verses']) {
        final v = AyatModel.fromJson(verse);
        setState(() {
          versese.add(v);
        });
      }
    } catch (e) {
      debugPrint('$e');
    } finally {
      setState(() {
        surahLoaded = true;
      });
    }
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      loadJson();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    surahNumber = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
          title: Text(surahName),
          titleSpacing: 00.0,
          centerTitle: true,
          toolbarHeight: 60.2,
          toolbarOpacity: 0.8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25)),
          ),
          elevation: 0.00,
          backgroundColor: Colors.amber[400],
          actions: [
            Visibility(
                visible: surahLoaded,
                child: Container(
                  margin: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: TextButton(
                    child: const Text(
                      'Go To',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => _showIndexPicker(Get.size));
                    },
                  ),
                )),
          ],
        ),
        body: surahLoaded
            ? ScrollablePositionedList.builder(
                itemScrollController: _itemScrollController,
                itemCount: versese.length,
                itemBuilder: (context, index) {
                  return AyatView(
                    totalVerses: versese.length.toString(),
                    surahName: surahName,
                    currentVerseNumber: '${index + 1}',
                    ayatModel: versese[index],
                    fontFamily: currentFont,
                  );
                })
            : Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.amber, size: 80)));
  }

  Widget _showIndexPicker(Size size) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ContainerPlus(
          color: Colors.white,
          width: size.width * 0.8,
          height: size.width * 0.5,
          border: BorderPlus(color: Colors.amber),
          radius: RadiusPlus.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContainerPlus(
                margin: const EdgeInsets.only(top: 10),
                child: const Text(
                  'Enter Ayat Number',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              TextFieldPlus(
                controller: textEditingController,
                height: size.height * 0.06,
                radius: RadiusPlus.all(10),
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                border: BorderPlus(color: Colors.amber),
                onlyNumbers: true,
              ),
              ButtonPlus(
                border: BorderPlus(color: Colors.amber),
                height: Get.height * 0.05,
                radius: RadiusPlus.all(10),
                onPressed: () {
                  if (textEditingController.text.isNotNullOrEmpty) {
                    var input = int.parse(textEditingController.text);
                    if (input >= 1 && input <= versese.length) {
                      Navigator.pop(context);
                      _itemScrollController.scrollTo(
                          index: input - 1,
                          duration: const Duration(seconds: 2));
                      textEditingController.clear();
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please Input Valid Ayat Number');
                    }
                  }
                },
                child: const Text(
                  'Go',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
