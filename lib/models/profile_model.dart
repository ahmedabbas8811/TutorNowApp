class ProfileModel {
  String name;
  bool isProfileComplete;
  final List<String> upcomingBookings;
  int stepscount;
  bool isVerified;

  ProfileModel(
      {required this.name,
      required this.isProfileComplete,
      required this.upcomingBookings,
      required this.stepscount,
      required this.isVerified
      });
}
