import 'package:flutter/material.dart';
import 'package:shramikaya_app/screens/active_gigs.dart';
import 'package:shramikaya_app/screens/create_new_gig.dart';
import 'package:shramikaya_app/screens/pause_gigs.dart';
import 'package:shramikaya_app/utils/colors.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            child: const Card(
              elevation: 5,
              child: SizedBox(
                width: 650,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_box_outlined,
                      size: 50,
                      color: primaryColor,
                    ),
                    Text(
                      "Create New Gig - අලුත් ගිග් එකක් සෑදීම",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateNewGig(),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            child: const Card(
              elevation: 5,
              child: SizedBox(
                width: 650,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.checklist_rounded,
                      size: 50,
                      color: Colors.green,
                    ),
                    Text(
                      "Active Gigs - සක්‍රීය ගිග්",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActiveGigs(),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            child: const Card(
              elevation: 5,
              child: SizedBox(
                width: 650,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pause_circle_outline_rounded,
                      size: 50,
                      color: Colors.orange,
                    ),
                    Text(
                      "Pause Gigs - තාවකාලිකව නැවතු ගිග්",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  PauseGigs(),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            child: const Card(
              elevation: 5,
              child: SizedBox(
                width: 650,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_forever_rounded,
                      size: 50,
                      color: Colors.red,
                    ),
                    Text(
                      "Delete Worker Profile - වැඩ ගිණුම ඉවත් කිරීම",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              print("Tap 4");
            },
          ),
        ),
      ],
    );
  }
}
