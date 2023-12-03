import 'package:flutter/material.dart';
import 'package:shramikaya_app/utils/colors.dart';
import 'package:shramikaya_app/widgets/getListedJobs.dart';

class PauseJobCard extends StatelessWidget {
  final GetListedJobService _getListedJobService = GetListedJobService();

  final String jobId;
  final String jobName;
  final String price;
  final String address;
  final String displayName;
  final String jobCategory;
  final String profileUrl;
  final String sellerLevel;
  final int orderCount;
  final String mobileNumber;

  PauseJobCard({
    super.key,
    required this.jobId,
    required this.jobName,
    required this.price,
    required this.address,
    required this.displayName,
    required this.jobCategory,
    required this.profileUrl,
    required this.sellerLevel,
    required this.orderCount,
    required this.mobileNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
        width: double.infinity,
        height: 320,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(blurRadius: 5.0, color: Colors.grey),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(profileUrl),
                        ),
                      ),
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      displayName,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Text(
                sellerLevel,
                style: const TextStyle(color: secondaryColor),
              ),
              Text(
                jobName,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: "Baloo",
                  color: primaryColor,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Icon(Icons.category),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(jobCategory),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.location_pin),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    address,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.price_change_rounded),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Rs: $price",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.check_circle),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "$orderCount Orders",
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _getListedJobService
                          .toggleIsActive(jobId, false)
                          .then((value) => {Navigator.pop(context)});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    label: const Text("Active"),
                    icon: const Icon(Icons.check),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _getListedJobService
                          .deleteJob(jobId)
                          .then((value) => {Navigator.pop(context)});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    label: const Text("Delete"),
                    icon: const Icon(Icons.delete_forever),
                  ),
                  // ElevatedButton.icon(
                  //   onPressed: () {},
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: secondaryColor,
                  //   ),
                  //   label: const Text("Add"),
                  //   icon: const Icon(Icons.star_border),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to make a phone call
