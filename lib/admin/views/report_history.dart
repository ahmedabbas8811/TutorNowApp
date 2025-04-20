import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newifchaly/admin/models/reports_model.dart';
import 'package:newifchaly/admin/views/approve_tutors.dart';
import 'package:newifchaly/admin/views/home_admin.dart';
import 'package:newifchaly/admin/views/manageusers.dart';

class ReportHistory extends StatelessWidget {
  final Report report;
  const ReportHistory({super.key, required this.report});

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
              Icon(icon, color: iconColor, size: 50), // Icon is back!
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
                style: const TextStyle(
                  fontSize: 15,
                ),
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
                          borderRadius: BorderRadius.circular(
                              10), // Circular border radius 10
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
                          borderRadius: BorderRadius.circular(
                              10), // Circular border radius 10
                        ),
                      ),
                      child: Text(
                        confirmText,
                        style: TextStyle(
                            color: isDanger ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
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
                          spreadRadius: 1),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.home, color: Colors.black),
                    title: const Text('Home',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeAdmin()));
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
                    title: const Text('Approve Tutors',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ApproveTutorsScreen()));
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
                    title: const Text('Manage Users',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Manageusers()));
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
                    title: const Text('Reports',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
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
                      left: 24.0, right: 24.0, top: 16.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Text(
                        'Report #${report.id}',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      const Icon(Icons.message, size: 28, color: Colors.black),
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
                              status: report.status,
                              color: report.status.toLowerCase() == 'open'
                                  ? const Color(0xff87e64c)
                                  : const Color(0xffe64b4b),
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
                              TextSpan(text: _formatDate(report.createdAt)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 7),

                        // Reported By
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
                                  TextSpan(text: report.reporterName),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.message,
                                color: Colors.black, size: 15),
                          ],
                        ),
                        const SizedBox(height: 7),

                        // Reported User
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
                                  TextSpan(text: report.reportedUserName),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.message,
                                color: Colors.black, size: 15),
                          ],
                        ),
                        const SizedBox(height: 7),

                        // Comments
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
                              TextSpan(text: report.comments),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text('User Report History',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),

                        // Tabs
                        const Row(
                          children: [
                            TabBadge(label: "Ali(5)", isSelected: true),
                            TabBadge(
                                label: "Kashif(0)",
                                isSelected: false,
                                removeBorder: true),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Report Cards
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: List.generate(5, (index) {
                            final isClosed = index > 1;
                            return ReportCard(isClosed: isClosed);
                          }),
                        ),

                        const SizedBox(height: 15),

                        const Text('Take Action',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),

                        // Action Buttons
                        Wrap(
                          spacing: 12,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                _showConfirmationDialog(
                                  context: context,
                                  title: "Block User Kashif?",
                                  description:
                                      "You’re going to block Kashif,this will \nprevent him from logging in to app",
                                  icon: Icons.block,
                                  iconColor: Colors.red,
                                  confirmText: "Block",
                                  confirmColor: const Color(0xffe64b4b),
                                  onConfirm: () {
                                    print("Blocked user");
                                  },
                                  isDanger: true,
                                );
                              },
                              icon:
                                  const Icon(Icons.block, color: Colors.white),
                              label: const Text('Block User',
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffe64b4b),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _showConfirmationDialog(
                                  context: context,
                                  title: "Warn User Kashif?",
                                  description:
                                      "This will send him a warning message.",
                                  icon: Icons.warning_amber_rounded,
                                  iconColor: Colors.orange,
                                  confirmText: "Warn",
                                  confirmColor: const Color(0xffffa21e),
                                  onConfirm: () {
                                    print("Warned user");
                                  },
                                );
                              },
                              icon: const Icon(Icons.warning_amber_rounded,
                                  color: Colors.black),
                              label: const Text('Warn User',
                                  style: TextStyle(color: Colors.black)),
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
                                  onConfirm: () {
                                    print("Marked as spam");
                                  },
                                );
                              },
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.black),
                              label: const Text('Mark As Spam',
                                  style: TextStyle(color: Colors.black)),
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
                                  onConfirm: () {
                                    print("Marked as resolved");
                                  },
                                );
                              },
                              icon: const Icon(Icons.check_circle_outline,
                                  color: Colors.black),
                              label: const Text('Mark As Resolved',
                                  style: TextStyle(color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff87e64c),
                              ),
                            ),
                          ],
                        )
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
}

// ======= Sidebar Item Widget =======
class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[800] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

// ======= Extra Widgets =======

class StatusBadge extends StatelessWidget {
  final String status;
  final Color color;
  const StatusBadge({required this.status, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: const TextStyle(color: Colors.black)),
    );
  }
}

class TabBadge extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool removeBorder;
  const TabBadge(
      {required this.label,
      required this.isSelected,
      this.removeBorder = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class ReportCard extends StatelessWidget {
  final bool isClosed;
  const ReportCard({required this.isClosed, super.key});

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
              spreadRadius: 1)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Status:'),
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
                  isClosed ? 'Closed' : 'Open',
                  style: TextStyle(
                    color: isClosed ? Colors.black : Colors.white,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Submitted: 3 Days Ago'),
          const Text('Reported By: Ali (Student)'),
          const Text('Comments: Foul Language'),
          Text('Action Taken: ${isClosed ? "Warned User" : ""}'),
        ],
      ),
    );
  }
}
