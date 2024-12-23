import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/location2_screen.dart';
import 'package:newifchaly/utils/profile_helper.dart';
import 'package:newifchaly/views/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/bio_controller.dart';
import '../models/bio_model.dart';

class BioScreen extends StatefulWidget {
  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {
  final BioController bioController = Get.put(BioController());

  final TextEditingController bioTextController = TextEditingController();
  
    @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await bioController.isBioCompleted()) {
       
        final completionData =
            await ProfileCompletionHelper.fetchCompletionData();
        final incompleteSteps =
            ProfileCompletionHelper.getIncompleteSteps(completionData);
        ProfileCompletionHelper.navigateToNextScreen(context, incompleteSteps);
      }
    });
   }


  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Bio',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: bioTextController,
              cursorColor: Colors.grey,
              maxLength: bioController.charLimit,
              onChanged: bioController.updateCharCount,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
                hintText: 'Explain yourself in 2-3 lines...',
              ),
            ),
         
            SizedBox(height: 16),
            Center(
              child: Row(
                children: [
                  
                    Expanded(
                      child: ElevatedButton(
                            onPressed: () async {
                                    final bioModel = BioModel(
                                      bio: bioTextController.text,
                                      userId: userId!,
                                    );
                                   final response = await bioController.saveBio(bioModel,context);
                                    if(response!= null){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Location2Screen(),
                                      ),
                                    );}
                                  
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff87e64c),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                                    'Next',
                                    style: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                          ),
                    ),
                  
                  
                ],
              ),
            ),
         
          ],
        ),
      ),
    );
  }
}
