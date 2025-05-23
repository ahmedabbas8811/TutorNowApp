import 'package:flutter/material.dart';
import 'package:newifchaly/weekattachimages.dart';
import 'package:newifchaly/controllers/progress_controller.dart';
import 'package:newifchaly/models/progress_model.dart';

class WeekProgress extends StatefulWidget {
  final int weekNumber;
  final String bookingId;
  const WeekProgress(
      {Key? key, required this.weekNumber, required this.bookingId})
      : super(key: key);

  @override
  _WeekProgressState createState() => _WeekProgressState();
}

class _WeekProgressState extends State<WeekProgress> {
  ProgressModel? existingReport;
  bool isLoading = true;
  bool reportExists = false;
  String? selectedPerformance;
  bool isConfidential = false;
  TextEditingController commentController = TextEditingController();
  final ProgressController progressController = ProgressController();

  @override
  void initState() {
    super.initState();
    debugPrint(
        'Opened WeekProgress Screen for Booking ID: ${widget.bookingId}, Week Number: ${widget.weekNumber}');
    _checkExistingReport();
  }

  Future<void> _checkExistingReport() async {
    try {
      // First check if report exists
      final exists = await progressController.checkProgressReportExists(
          widget.bookingId, widget.weekNumber);

      if (exists) {
        final report = await progressController.fetchProgressReport(
          widget.bookingId,
          widget.weekNumber,
        );
        setState(() {
          existingReport = report;
        });
      } else {
        setState(() {
          existingReport = null;
        });
      }
    } catch (e) {
      debugPrint('Error checking report: $e');
      setState(() {
        existingReport = null;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  final List<String> performanceOptions = [
    "😃 Excellent",
    "😊 Good",
    "😐 Average",
    "😕 Struggling",
  ];

  final List<List<Map<String, dynamic>>> groupedTags = [
    [
      {"text": "✅ Grasped the concepts", "color": const Color(0xffefffe7)},
      {
        "text": "💡 Getting There! Needs Support",
        "color": const Color(0xffffe7e7)
      },
    ],
    [
      {
        "text": "😟 Not performing well, need studies",
        "color": const Color(0xfffeffd3)
      },
      {"text": "🏆 Excellent Progress!", "color": const Color(0xffffe7fc)},
    ],
    [
      {"text": "📘 Revision week", "color": const Color(0xffe7f3ff)},
      {"text": "😕 Struggling needed", "color": const Color(0xffffd3d3)},
    ],
  ];

  void saveProgress() async {
    if (selectedPerformance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select overall performance")),
      );
      return;
    }

    ProgressModel report = ProgressModel(
        week: widget.weekNumber,
        overallPerformance: selectedPerformance!,
        comments: commentController.text.trim(),
        bookingId: widget.bookingId,
        imageUrl: '',
        imageId: '',
        isConfidential: isConfidential);

    String result =
        await progressController.saveProgressReport(report, context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result)),
    );
  }

  Widget _buildReportDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Performance Report",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        const Text("Overall performance", style: TextStyle(fontSize: 16)),
        Text("${existingReport!.overallPerformance}",
            style: TextStyle(fontSize: 16, color: Colors.grey)),
        SizedBox(height: 30),
        const Text("Additional Comments", style: TextStyle(fontSize: 16)),
        Text("${existingReport!.comments}",
            style: TextStyle(fontSize: 16, color: Colors.grey)),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _buildInputForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Overall performance", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        Wrap(
          spacing: 8.0,
          children: performanceOptions.map((option) {
            return ChoiceChip(
              label: Text(option,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.normal)),
              selected: selectedPerformance == option,
              backgroundColor: const Color(0xfff3f3f3),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20),
              ),
              onSelected: (selected) {
                setState(() {
                  selectedPerformance = selected ? option : null;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        const Text("Additional comments (if any)",
            style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          children: [
            Checkbox(
              value: isConfidential,
              onChanged: (value) {
                setState(() {
                  isConfidential = value ?? false;
                });
              },
            ),
            const Text("Only show to parent"),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          constraints: const BoxConstraints(minHeight: 50, maxHeight: 150),
          child: TextField(
            controller: commentController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: "Write your comment here",
              filled: true,
              fillColor: const Color(0xfff3f3f3),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupedTags
              .map((group) => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: group
                        .map((tag) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: _buildTag(tag),
                              ),
                            ))
                        .toList(),
                  ))
              .toList(),
        ),
        const SizedBox(height: 14),
        Center(
          child: ElevatedButton(
            onPressed: saveProgress,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff87e64c),
              padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 140),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
            child: const Text("Save",
                style: TextStyle(fontSize: 17, color: Colors.black)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Week ${widget.weekNumber} - Progress Report",
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Weekly Progress Report",
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              existingReport != null
                  ? _buildReportDisplay()
                  : _buildInputForm(),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WeekAttachImages(
                                bookingId: widget.bookingId,
                                week: widget.weekNumber,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black, width: 1),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text("Attach Images +",
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(Map<String, dynamic> tag) {
    return GestureDetector(
      onTap: () {
        setState(() {
          commentController.text = tag["text"];
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: tag["color"],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          tag["text"],
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
