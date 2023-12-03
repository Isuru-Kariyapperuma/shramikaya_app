import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shramikaya_app/utils/colors.dart';
import 'package:shramikaya_app/widgets/active_gig_job_card.dart';
import 'package:shramikaya_app/widgets/getListedJobs.dart';

class ActiveGigs extends StatelessWidget {
  final GetListedJobService _getListedJobService = GetListedJobService();
  ActiveGigs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Active Gigs",
          style: TextStyle(
            color: primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _getListedJobService.getActiveJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              'No jobs available.',
              style: TextStyle(fontSize: 20),
            ));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var jobData =
                    snapshot.data![index].data() as Map<String, dynamic>;
                var jobId = snapshot.data![index].id;

                return ActiveJobCard(
                  jobId: jobId,
                  jobName: jobData["jobName"],
                  price: jobData["price"],
                  address: jobData["address"],
                  displayName: jobData["displayName"],
                  jobCategory: jobData["jobCategory"],
                  profileUrl: jobData["profileUrl"],
                  sellerLevel: jobData["sellerLevel"],
                  orderCount: jobData["orderCount"],
                  mobileNumber: jobData["mobileNumber"],
                );
              },
            );
          }
        },
      ),
    );
  }
}
