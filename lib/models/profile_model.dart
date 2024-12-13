class ProfileModel {
  String name;
  final bool isProfileComplete;
  final List<String> upcomingBookings;
  int stepscount;

  ProfileModel(
      {required this.name,
      required this.isProfileComplete,
      required this.upcomingBookings,
      required this.stepscount});
}
