import 'package:get_storage/get_storage.dart';
import 'package:newifchaly/utils/storage_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  static final GetStorage box = GetStorage();

  // * To get the user session as a `Session` object
  static Session? get getUserSession {
    final sessionData = box.read(StorageConstants.authKey);
    if (sessionData != null) {
      return Session.fromJson(sessionData);
    }
    return null;
  }
}




