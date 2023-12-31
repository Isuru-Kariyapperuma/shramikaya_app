import 'package:flutter/material.dart';
import 'package:shramikaya_app/screens/work_profile_form.dart';
import 'package:shramikaya_app/utils/colors.dart';

class CreateWorkerProfile extends StatelessWidget {
  const CreateWorkerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.1),
      child: Card(
        elevation: 5,
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            left: 0,
            top: 5,
            right: 0,
            bottom: 5,
          ),
          width: 650,
          height: 350,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            //borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color.fromARGB(255, 249, 250, 250),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.control_point_rounded,
                    size: 100,
                  ),
                ],
              ),
              const Text(
                'Publish Your First Gig',
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 33, 16, 16),
                ),
              ),
              const SizedBox(height: 20),
              const Column(
                children: [
                  Text(
                    'You can register as a seller',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'and upgrade your job to the next level.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WorkProfileForm()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(295, 60),
                    padding: const EdgeInsets.all(16.0),
                    foregroundColor: Colors.white,
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  child: const Text(
                    'Create your work profile',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
