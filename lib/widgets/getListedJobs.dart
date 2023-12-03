import 'package:cloud_firestore/cloud_firestore.dart';

class GetListedJobService {
  final CollectionReference jobCollection =
      FirebaseFirestore.instance.collection('job');

  Future<List<DocumentSnapshot>> getJobs() async {
    QuerySnapshot querySnapshot = await jobCollection.get();
    return querySnapshot.docs;
  }
}
