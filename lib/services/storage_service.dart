import 'package:get_storage/get_storage.dart';
import 'package:newifchaly/utils/storage_constants.dart';

class StorageService {
  static final GetStorage box = GetStorage();

  // * To get the user session
  static dynamic get getUserSession {
    return box.read(StorageConstants
        .authKey); // This should match how you're storing the session
  }
}
