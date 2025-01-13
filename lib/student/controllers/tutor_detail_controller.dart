import 'package:get/get.dart';
import 'package:newifchaly/models/person_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TutorDetailController extends GetxController {
  var selectedTab = 0.obs;
  var subs = "";
  final String? UserId;
  TutorDetailController({required this.UserId});

  var profile = PersonModel(
          name: "",
          bio: "",
          isProfileComplete: false,
          profileImage: "",
          isVerified: false)
      .obs;

  void resetProfile() {
    profile.value = PersonModel(
      name: "",
      bio: "",
      isProfileComplete: false,
      profileImage: "",
      isVerified: false,
    );
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserName(UserId!);
    fetchSubjects(UserId!);
    fetchBio(UserId!);
    updateVerificationStatus();
    fetchUserImg(UserId!);
    fetchQualifications(UserId!);
    fetchExperiences(UserId!);
  }

  Future<void> updateVerificationStatus() async {
    final supabase = Supabase.instance.client;
    final user = Supabase.instance.client.auth.currentUser;

    try {
      final response = await supabase
          .from('users')
          .select('is_verified')
          .eq('id', user!.id)
          .single();

      if (response == null) {
        throw Exception("Profile not found");
      }

      //check if all columns are true

      if (response != null && response['is_verified'] == true) {
        profile.update((p) {
          p?.isVerified = true;
        });
      }
    } catch (error) {
      print("Error checking columns: $error");
    }
  }

  Future<void> fetchUserName(String userId) async {
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('id', userId)
        .single();

    if (response.isNotEmpty) {
      try {
        final response = await Supabase.instance.client
            .from('users')
            .select('metadata->>name')
            .eq('id', userId)
            .maybeSingle();

        if (response != null && response['name'] != null) {
          profile.update((p) {
            p?.name = response['name'];
          });
        } else {
          print("Name not found in metadata.");
        }
      } catch (e) {
        print("Error fetching user name: $e");
      }
    }
  }

  Future<void> fetchBio(String userId) async {
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('id', userId)
        .single();

    if (response.isNotEmpty) {
      try {
        final response = await Supabase.instance.client
            .from('bios')
            .select('bio')
            .eq('userid', userId)
            .maybeSingle();

        if (response != null && response['bio'] != null) {
          profile.update((p) {
            p?.bio = response['bio'];
          });
        } else {
          print("Bio not found.");
        }
      } catch (e) {
        print("Error fetching user bio: $e");
      }
    }
  }

  Future<void> fetchSubjects(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('teachto')
          .select('subject')
          .eq('user_id', userId)
          .select();

      if (response.isEmpty) {
        print("No subjects found.");
      }

      //extract subject from each row and concat them into a single string
      List<String> subjects = [];
      for (var row in response) {
        subjects.add(row['subject']);
      }
      subs = subjects.join(', ');

      //join subs
    } catch (e) {
      print("Error fetching user subjects: $e");
    }
  }

  Future<void> fetchUserImg(String userId) async {
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('id', userId)
        .single();

    if (response.isNotEmpty) {
      try {
        final response = await Supabase.instance.client
            .from('users')
            .select('image_url')
            .eq('id', userId)
            .maybeSingle();

        if (response != null && response['image_url'] != null) {
          profile.update((p) {
            p?.profileImage = response['image_url'];
          });
        } else {
          print("Image url not found");
        }
      } catch (e) {
        print("Error fetching img url: $e");
      }
    }
  }

  Future<void> fetchQualifications(String userId) async {
    final supabase = Supabase.instance.client;
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('id', userId)
        .single();

    if (response.isNotEmpty) {
      try {
        final response = await supabase
            .from('qualification')
            .select('education_level, institute_name')
            .eq('user_id', userId);

        if (response != null && response is List) {
          final qualificationList = response.map((data) {
            return Qualification.fromJson(data);
          }).toList();

          profile.update((p) {
            p?.updateQualifications(qualificationList);
          });
        }
      } catch (e) {
        print("Error fetching qualifications: $e");
      }
    }
  }

  Future<void> fetchExperiences(String userId) async {
    final supabase = Supabase.instance.client;
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('id', userId)
        .single();

    if (response.isNotEmpty) {
      try {
        final response = await supabase
            .from('experience')
            .select(
                'student_education_level, start_date, end_date, still_working')
            .eq('user_id', userId);

        if (response != null && response is List) {
          final experienceList = response.map((data) {
            return Experience.fromJson(data);
          }).toList();

          profile.update((p) {
            p?.updateExperiences(experienceList);
          });
        }
      } catch (e) {
        print("Error fetching experiences: $e");
      }
    }
  }
}
