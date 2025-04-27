import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newifchaly/admin/controllers/manage_users_controller.dart';
import 'package:newifchaly/admin/controllers/reports_controller.dart';
import 'package:newifchaly/admin/models/reports_model.dart';
import 'package:newifchaly/admin/views/approve_tutors.dart';
import 'package:newifchaly/admin/views/home_admin.dart';
import 'package:newifchaly/admin/views/manageusers.dart';
import 'package:newifchaly/messagescreen.dart';
import 'package:newifchaly/student/views/chat_screen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ReportHistory extends StatefulWidget {
  final Report report;
  const ReportHistory({super.key, required this.report});

  @override
  State<ReportHistory> createState() => _ReportHistoryState();
}

class _ReportHistoryState extends State<ReportHistory> {
  final ReportController _reportController = ReportController();
  final UserController _userController = UserController();
  late Future<List<Report>> _reportedUserHistoryFuture;
  late Future<List<Report>> _reporterHistoryFuture;
  int _selectedTabIndex = 0;
  late Future<int> _reportedUserCountFuture;
  late Future<int> _reporterCountFuture;
  int _reportedUserCount = 0;
  int _reporterCount = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialCounts();
    _loadReportData();
  }

  Future<void> _loadInitialCounts() async {
    _reportedUserCount = await _reportController.countReportsForUser(
      widget.report.reportedUserId ?? '',
      excludeReportId: widget.report.id,
    );
    _reporterCount = await _reportController.countReportsForUser(
      widget.report.reporterId ?? '',
      excludeReportId: widget.report.id,
    );
    setState(() {});
  }

  Future<void> _loadReportData() async {
    if (_selectedTabIndex == 0) {
      _reportedUserHistoryFuture = _reportController.fetchUserReportHistory(
        widget.report.reportedUserId ?? '',
        excludeReportId: widget.report.id,
      );
    } else {
      _reporterHistoryFuture = _reportController.fetchUserReportHistory(
        widget.report.reporterId ?? '',
        excludeReportId: widget.report.id,
      );
    }
    setState(() {});
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required String confirmText,
    required Color confirmColor,
    required VoidCallback onConfirm,
    bool isDanger = false,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 50),
              const SizedBox(height: 12),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        confirmText,
                        style: TextStyle(
                          color: isDanger ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'Day' : 'Days'} Ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'Hour' : 'Hours'} Ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'Minute' : 'Minutes'} Ago';
    }
    return 'Just Now';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 15),
                Image.asset('assets/ali.png', width: 50, height: 50),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 0,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.home, color: Colors.black),
                    title: const Text(
                      'Home',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeAdmin(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    leading:
                        const Icon(Icons.check_circle, color: Colors.black),
                    title: const Text(
                      'Approve Tutors',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApproveTutorsScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.userTie,
                        color: Colors.black),
                    title: const Text(
                      'Manage Users',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Manageusers(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xff87e64c),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.insert_drive_file,
                        color: Colors.black),
                    title: const Text(
                      'Reports',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    top: 16.0,
                    bottom: 8.0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Report #${widget.report.id}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.message,
                            size: 28, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TutorChatListScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Status: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(
                              status: widget.report.status,
                              color:
                                  widget.report.status.toLowerCase() == 'open'
                                      ? const Color(0xffe64b4b)
                                      : const Color(0xff87e64c),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),

                        // Submitted
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Submitted: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text: _formatDate(widget.report.createdAt)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 7),

                        // Reported By section
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Reported By: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: widget.report.reporterName),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      receiverId:
                                          widget.report.reporterId ?? '',
                                      receiverName: widget.report.reporterName,
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(Icons.message,
                                  color: Colors.black, size: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),

                        // Reported User section
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Reported User: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                      text: widget.report.reportedUserName),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      receiverId:
                                          widget.report.reportedUserId ?? '',
                                      receiverName:
                                          widget.report.reportedUserName,
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(Icons.message,
                                  color: Colors.black, size: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),

                        // Comments section
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Comments: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: widget.report.comments),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Add the images display here
                        if (widget.report.images != null &&
                            widget.report.images!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.report.images!.length,
                                  itemBuilder: (context, index) {
                                    final imageUrl = widget
                                        .report.images!['$index']
                                        ?.toString();
                                    if (imageUrl == null)
                                      return const SizedBox.shrink();

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              final pageController =
                                                  PageController(
                                                      initialPage: index);
                                              ValueNotifier<int>
                                                  currentIndexNotifier =
                                                  ValueNotifier<int>(index);

                                              return Scaffold(
                                                appBar: AppBar(
                                                  title: ValueListenableBuilder<
                                                      int>(
                                                    valueListenable:
                                                        currentIndexNotifier,
                                                    builder: (context,
                                                        currentIndex, child) {
                                                      return Text(
                                                          'Image ${currentIndex + 1}/${widget.report.images!.length}');
                                                    },
                                                  ),
                                                ),
                                                body: Stack(
                                                  children: [
                                                    PhotoViewGallery.builder(
                                                      itemCount: widget.report
                                                          .images!.length,
                                                      builder:
                                                          (context, index) {
                                                        final galleryImageUrl =
                                                            widget
                                                                .report
                                                                .images![
                                                                    '$index']
                                                                ?.toString();
                                                        return PhotoViewGalleryPageOptions(
                                                          imageProvider:
                                                              NetworkImage(
                                                                  galleryImageUrl!),
                                                          minScale:
                                                              PhotoViewComputedScale
                                                                  .contained,
                                                          maxScale:
                                                              PhotoViewComputedScale
                                                                      .covered *
                                                                  2,
                                                          heroAttributes:
                                                              PhotoViewHeroAttributes(
                                                                  tag:
                                                                      galleryImageUrl),
                                                        );
                                                      },
                                                      scrollPhysics:
                                                          const BouncingScrollPhysics(),
                                                      backgroundDecoration:
                                                          const BoxDecoration(
                                                        color: Colors.black,
                                                      ),
                                                      pageController:
                                                          pageController,
                                                      onPageChanged: (index) {
                                                        currentIndexNotifier
                                                            .value = index;
                                                      },
                                                    ),

                                                    // Left arrow - only show when not on first image
                                                    ValueListenableBuilder<int>(
                                                      valueListenable:
                                                          currentIndexNotifier,
                                                      builder: (context,
                                                          currentIndex, child) {
                                                        return currentIndex > 0
                                                            ? Positioned(
                                                                left: 10,
                                                                top: 0,
                                                                bottom: 0,
                                                                child: Center(
                                                                  child:
                                                                      IconButton(
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .arrow_back_ios,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      pageController
                                                                          .previousPage(
                                                                        duration:
                                                                            const Duration(milliseconds: 300),
                                                                        curve: Curves
                                                                            .easeInOut,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox
                                                                .shrink();
                                                      },
                                                    ),

                                                    // Right arrow - only show when not on last image
                                                    ValueListenableBuilder<int>(
                                                      valueListenable:
                                                          currentIndexNotifier,
                                                      builder: (context,
                                                          currentIndex, child) {
                                                        return currentIndex <
                                                                widget
                                                                        .report
                                                                        .images!
                                                                        .length -
                                                                    1
                                                            ? Positioned(
                                                                right: 10,
                                                                top: 0,
                                                                bottom: 0,
                                                                child: Center(
                                                                  child:
                                                                      IconButton(
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      pageController
                                                                          .nextPage(
                                                                        duration:
                                                                            const Duration(milliseconds: 300),
                                                                        curve: Curves
                                                                            .easeInOut,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox
                                                                .shrink();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: imageUrl,
                                        child: Container(
                                          width: 208.2,
                                          height: 200,
                                          margin:
                                              const EdgeInsets.only(right: 16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            image: DecorationImage(
                                              image: NetworkImage(imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        // User Report History section
                        const Text(
                          'User Report History',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),

                        // Tabs and Report Cards
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tabs (always visible, not part of loading)
                            Row(
                              children: [
                                TabBadge(
                                  label:
                                      "${widget.report.reportedUserName}($_reportedUserCount)",
                                  isSelected: _selectedTabIndex == 0,
                                  onTap: () {
                                    setState(() {
                                      _selectedTabIndex = 0;
                                      _loadReportData(); // Refresh data without showing loading on buttons
                                    });
                                  },
                                ),
                                TabBadge(
                                  label:
                                      "${widget.report.reporterName}($_reporterCount)",
                                  isSelected: _selectedTabIndex == 1,
                                  removeBorder: true,
                                  onTap: () {
                                    setState(() {
                                      _selectedTabIndex = 1;
                                      _loadReportData(); // Refresh data without showing loading on buttons
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Report Cards (with loading state)
                            FutureBuilder<List<Report>>(
                              future: _selectedTabIndex == 0
                                  ? _reportedUserHistoryFuture
                                  : _reporterHistoryFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }

                                final reports = snapshot.data ?? [];

                                return reports.isEmpty
                                    ? const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child:
                                            Text('No previous reports found'),
                                      )
                                    : Wrap(
                                        spacing: 16,
                                        runSpacing: 16,
                                        children: reports.map((report) {
                                          return ReportCard(
                                            report: report,
                                            isClosed:
                                                report.status.toLowerCase() !=
                                                    'open',
                                          );
                                        }).toList(),
                                      );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),
                        const Text(
                          'Take Action',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Action Buttons
                        Wrap(
                          spacing: 12,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                _showConfirmationDialog(
                                  context: context,
                                  title:
                                      "Block User ${widget.report.reportedUserName}?",
                                  description:
                                      "You're going to block ${widget.report.reportedUserName}, this will prevent them from logging in to app",
                                  icon: Icons.block,
                                  iconColor: Colors.red,
                                  confirmText: "Block",
                                  confirmColor: const Color(0xffe64b4b),
                                  onConfirm: () async {
                                    try {
                                      // Update report status
                                      await _reportController
                                          .updateReportStatus(
                                              widget.report.id, 'closed',
                                              actionType: 'block');

                                      // Update user status to blocked
                                      if (widget.report.reportedUserId !=
                                          null) {
                                        await _userController.updateUserStatus(
                                            widget.report.reportedUserId!,
                                            true // true means block the user
                                            );
                                      }

                                      // Show success message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'User blocked and report closed')),
                                      );

                                      // Navigate back to handler reports screen
                                      Navigator.pop(context);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to block user: ${e.toString()}')),
                                      );
                                    }
                                  },
                                  isDanger: true,
                                );
                              },
                              icon:
                                  const Icon(Icons.block, color: Colors.white),
                              label: const Text(
                                'Block User',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffe64b4b),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _showConfirmationDialog(
                                  context: context,
                                  title:
                                      "Warn User ${widget.report.reportedUserName}?",
                                  description:
                                      "This will send them a warning message.",
                                  icon: Icons.warning_amber_rounded,
                                  iconColor: Colors.orange,
                                  confirmText: "Warn",
                                  confirmColor: const Color(0xffffa21e),
                                  onConfirm: () async {
                                    try {
                                      // First, send the warning message
                                      final myUserId =
                                          supabase.auth.currentUser?.id;
                                      if (myUserId != null) {
                                        await supabase.from('messages').insert({
                                          'sender_id': myUserId,
                                          'receiver_id':
                                              widget.report.reportedUserId ??
                                                  '',
                                          'content':
                                              'You have received a warning from the admin regarding your recent behavior. Please review our community guidelines.',
                                          'created_at':
                                              DateTime.now().toIso8601String(),
                                        });
                                      }

                                      // Then update report status
                                      await _reportController
                                          .updateReportStatus(
                                              widget.report.id, 'closed',
                                              actionType: 'warn');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'User warned and report closed')),
                                      );

                                      Navigator.pop(context);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to warn user: ${e.toString()}')),
                                      );
                                    }
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'Warn User',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffffa21e),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _showConfirmationDialog(
                                  context: context,
                                  title: "Mark As Spam?",
                                  description:
                                      "You're going to mark this report as spam.",
                                  icon: Icons.report_gmailerrorred,
                                  iconColor: Colors.yellow,
                                  confirmText: "Spam",
                                  confirmColor: const Color(0xffe6e14b),
                                  onConfirm: () async {
                                    try {
                                      await _reportController
                                          .updateReportStatus(
                                              widget.report.id, 'closed',
                                              actionType: 'spam');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Report marked as spam and closed')),
                                      );
                                      Navigator.pop(context);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to mark as spam: ${e.toString()}')),
                                      );
                                    }
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'Mark As Spam',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffe6e14b),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _showConfirmationDialog(
                                  context: context,
                                  title: "Mark As Resolved?",
                                  description:
                                      "You're about to mark this report as resolved.",
                                  icon: Icons.check_circle_outline,
                                  iconColor: Colors.green,
                                  confirmText: "Resolve",
                                  confirmColor: const Color(0xff87e64c),
                                  onConfirm: () async {
                                    try {
                                      await _reportController
                                          .updateReportStatus(
                                              widget.report.id, 'closed',
                                              actionType: 'resolve');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Report marked as resolved')),
                                      );
                                      Navigator.pop(context);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to resolve report: ${e.toString()}')),
                                      );
                                    }
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'Mark As Resolved',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff87e64c),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;
  final Color color;
  const StatusBadge({
    required this.status,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}

class TabBadge extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool removeBorder;
  final VoidCallback? onTap;
  const TabBadge({
    required this.label,
    required this.isSelected,
    this.removeBorder = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 8, right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff87e64c) : Colors.grey[300],
          borderRadius: BorderRadius.circular(7),
          border: removeBorder ? null : Border.all(color: Colors.black),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final Report report;
  final bool isClosed;
  const ReportCard({
    required this.report,
    required this.isClosed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Status:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                decoration: BoxDecoration(
                  color: isClosed
                      ? const Color(0xff87e64c)
                      : const Color(0xffe64b4b),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  report.status,
                  style: TextStyle(
                    fontSize: 16,
                    color: isClosed ? Colors.black : Colors.white,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 7),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: [
                const TextSpan(
                  text: 'Submitted: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: _formatDate(report.createdAt)),
              ],
            ),
          ),
          const SizedBox(height: 7),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: [
                const TextSpan(
                  text: 'Reported By: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: report.reporterName),
              ],
            ),
          ),
          const SizedBox(height: 7),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: [
                const TextSpan(
                  text: 'Comments: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: report.comments),
              ],
            ),
          ),
          const SizedBox(height: 7),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: [
                const TextSpan(
                  text: 'Action Taken: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: report.actionTaken ?? "No action taken"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'Day' : 'Days'} Ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'Hour' : 'Hours'} Ago';
    }
    return 'Less than an hour ago';
  }
}
