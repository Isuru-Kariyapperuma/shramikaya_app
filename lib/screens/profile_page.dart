import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shramikaya_app/utils/colors.dart';
import 'package:shramikaya_app/widgets/create_worker_profile.dart';
import 'package:shramikaya_app/widgets/profile_details.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isWorker = false;

  @override
  void initState() {
    super.initState();
    checkIsWorker();
  }

  Future<void> checkIsWorker() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    bool isWorkerResult = await checkDocumentExists(userId);

    setState(() {
      isWorker = isWorkerResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayName = FirebaseAuth.instance.currentUser!.displayName!;
    final photoUrl = FirebaseAuth.instance.currentUser!.photoURL!;
    final userEmail = FirebaseAuth.instance.currentUser!.email!;

    // final isLongName;
    // if (displayName.length < 10) {
    //   isLongName = false;
    // } else {
    //   isLongName = true;
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            color: primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: silverColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  elevation: 5,
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: (MediaQuery.of(context).size.height / 100) * 20,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      //borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(photoUrl),
                          radius: 40,
                          backgroundColor: Colors.white,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userEmail,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                await GoogleSignIn().signOut();
                                FirebaseAuth.instance.signOut();
                              },
                              icon: const Icon(
                                Icons.logout_rounded,
                                color: primaryColor,
                              ),
                              label: const Text(
                                "Sign Out",
                                style: TextStyle(color: primaryColor),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              isWorker ? const ProfileDetails() : const CreateWorkerProfile(),

              // Add the rest of your content here
            ],
          ),
        ),
      ),
    );
  }
}

// Stream<List<Worker>> readWorker() => FirebaseFirestore.instance
//     .collection('worker')
//     .snapshots()
//     .map((snapshot) =>
//         snapshot.docs.map((doc) => Worker.fromJson(doc.data())).toList());

Future<bool> checkDocumentExists(userId) async {
  // Reference to the 'worker' collection
  CollectionReference workers = FirebaseFirestore.instance.collection('worker');

  // Reference to the specific document using the provided document ID
  DocumentReference documentRef = workers.doc(userId);

  // Get the document snapshot
  DocumentSnapshot documentSnapshot = await documentRef.get();

  // Check if the document exists
  if (documentSnapshot.exists) {
    return true;
  } else {
    return false;
  }
}
