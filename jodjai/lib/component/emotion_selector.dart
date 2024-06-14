import 'package:flutter/material.dart';

class EmotionSelector extends StatefulWidget {
  const EmotionSelector({super.key});

  @override
  _EmotionSelectorState createState() => _EmotionSelectorState();
}

class _EmotionSelectorState extends State<EmotionSelector> {
  String _selectedEmotion = '';

  void _onEmotionTap(String emotion) {
    setState(() {
      _selectedEmotion = emotion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildEmotionButton('happy', 'assets/images/happy.png',
            'assets/images/happy_tapped.png'),
        buildEmotionButton('smile', 'assets/images/smile_pink.png',
            'assets/images/smile_pink_tapped.png'),
        buildEmotionButton('soso', 'assets/images/soso.png',
            'assets/images/soso_tapped.png'),
        buildEmotionButton('sad', 'assets/images/sad.png',
            'assets/images/sad_tapped.png'),
        buildEmotionButton('cry', 'assets/images/cry.png',
            'assets/images/cry_tapped.png'),
      ],
    );
  }

  Widget buildEmotionButton(
      String emotion, String normalImage, String tappedImage) {
    return InkWell(
      onTap: () => _onEmotionTap(emotion),
      child: Container(
        width: 55, // Adjust width as needed
        height: 55, // Adjust height as needed
        child: Image.asset(
          _selectedEmotion == emotion ? tappedImage : normalImage,
          fit: BoxFit
              .contain, // Adjust the fit to maintain aspect ratio
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: Scaffold(body: EmotionSelector())));
}
