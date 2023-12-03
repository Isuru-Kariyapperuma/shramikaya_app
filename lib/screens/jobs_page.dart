import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shramikaya_app/utils/colors.dart';
import 'package:shramikaya_app/widgets/banner_slider.dart';
import 'package:shramikaya_app/widgets/getListedJobs.dart';
import 'package:shramikaya_app/widgets/job_card.dart';

class JobsPage extends StatefulWidget {
  JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final GetListedJobService _getListedJobService = GetListedJobService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Shramikaya",
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: FutureBuilder<List<DocumentSnapshot>>(
          future: _getListedJobService.getJobs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text(
                'No jobs available.',
                style: TextStyle(fontSize: 25),
              ));
            } else {
              final jobs = snapshot.data!
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height * 0.255,
                    flexibleSpace: const FlexibleSpaceBar(
                      background: BannerSlider(),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final jobData = jobs[index];

                        return JobCard(
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
                      childCount: jobs.length,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in searchTerms) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in searchTerms) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
