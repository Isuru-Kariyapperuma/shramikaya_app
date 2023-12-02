class Worker {
  final String address;
  final String displayName;
  final String jobCategory;
  final String mobileNumber;
  final String profileUrl;

  Worker(
      {required this.address,
      required this.displayName,
      required this.jobCategory,
      required this.mobileNumber,
      required this.profileUrl});

  Map<String, dynamic> toJson() => {
        'address': address,
        'displayName': displayName,
        'jobCategory': jobCategory,
        'mobileNumber': mobileNumber,
        'profileUrl': profileUrl
      };

  static Worker fromJson(Map<String, dynamic> json) => Worker(
      address: json['address'],
      displayName: json['displayName'],
      jobCategory: json['jobCategory'],
      mobileNumber: json['mobileNumber'],
      profileUrl: json['profileUrl']);
}
