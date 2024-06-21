import 'package:flutter/material.dart';

class JournalCard extends StatelessWidget {
  final String title;
  final String content;
  final String entryDate;
  final int moodRating;
  final int id;

  const JournalCard({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.entryDate,
    required this.moodRating,
  });

  String getMoodImage(int moodRating) {
    switch (moodRating) {
      case 1:
        return 'assets/images/happy.png';
      case 2:
        return 'assets/images/smile_pink.png';
      case 3:
        return 'assets/images/soso.png';
      case 4:
        return 'assets/images/sad.png';
      case 5:
        return 'assets/images/cry.png';
      default:
        return 'assets/images/happy.png'; // Default image if mood rating is out of expected range
    }
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    return date;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap action here
      },
      child: Container(
        width: 400,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: -5,
              blurRadius: 15.5,
              offset: const Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                getMoodImage(moodRating),
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff666159),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      formatDate(entryDate),
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: Color(0xff666159),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.chevron_right,
                  color: Color(0xff3C270B),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context, 
                    '/journalDetail' ,
                    arguments: {
                      'id': id,
                      'title': title,
                      'content': content,
                      'entryDate': entryDate,
                      'moodRating': moodRating,
                     },
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}