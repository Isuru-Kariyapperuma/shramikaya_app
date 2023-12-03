import 'package:cloud_firestore/cloud_firestore.dart';

class GetListedJobService {
  final CollectionReference jobCollection =
      FirebaseFirestore.instance.collection('job');

  Future<List<DocumentSnapshot>> getJobs() async {
    QuerySnapshot querySnapshot = await jobCollection.get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> getActiveJobs() async {
    try {
      QuerySnapshot querySnapshot =
          await jobCollection.where('isActive', isEqualTo: true).get();
      return querySnapshot.docs;
    } catch (error) {
      // Handle errors appropriately
      print('Error getting active jobs: $error');
      throw error;
    }
  }

  Future<List<DocumentSnapshot>> getPauseJobs() async {
    try {
      QuerySnapshot querySnapshot =
          await jobCollection.where('isActive', isEqualTo: false).get();
      return querySnapshot.docs;
    } catch (error) {
      // Handle errors appropriately
      print('Error getting pause jobs: $error');
      throw error;
    }
  }

  Future<void> deleteJob(String documentId) async {
    try {
      await jobCollection.doc(documentId).delete();
    } catch (error) {
      print('Error deleting job: $error');
      throw error;
    }
  }

  Future<void> toggleIsActive(String documentId, bool currentStatus) async {
    try {
      await jobCollection.doc(documentId).update({
        'isActive': !currentStatus,
      });
    } catch (error) {
      print('Error toggling isActive: $error');
      throw error;
    }
  }
}
