// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class EmotionShowAndSelect extends StatefulWidget {
  final Function(int) onEmotionSelected;
  final int initialEmotion;

  const EmotionShowAndSelect({super.key, required this.onEmotionSelected, required this.initialEmotion});

  @override
  _EmotionShowAndSelectState createState() => _EmotionShowAndSelectState();
}

class _EmotionShowAndSelectState extends State<EmotionShowAndSelect> {
  late int _selectedEmotion;

  @override
  void initState() {
    super.initState();
    _selectedEmotion = widget.initialEmotion;
  }

  void _onEmotionTap(int emotion) {
    setState(() {
      _selectedEmotion = emotion;
    });
    widget.onEmotionSelected(emotion);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildEmotionButton(1, 'assets/images/happy.png', 'assets/images/happy_tapped.png'),
        buildEmotionButton(2, 'assets/images/smile_pink.png', 'assets/images/smile_pink_tapped.png'),
        buildEmotionButton(3, 'assets/images/soso.png', 'assets/images/soso_tapped.png'),
        buildEmotionButton(4, 'assets/images/sad.png', 'assets/images/sad_tapped.png'),
        buildEmotionButton(5, 'assets/images/cry.png', 'assets/images/cry_tapped.png'),
      ],
    );
  }

  Widget buildEmotionButton(int emotion, String normalImage, String tappedImage) {
    return InkWell(
      onTap: () => _onEmotionTap(emotion),
      child: SizedBox(
        width: 55,
        height: 55,
        child: Image.asset(
          _selectedEmotion == emotion ? tappedImage : normalImage,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: Scaffold(body: EmotionShowAndSelect(onEmotionSelected: (emotion) {}, initialEmotion: 0))));
}
