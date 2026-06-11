import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/consultation.dart';
import '../services/consultation_service.dart';
import 'teleconsultation_screen.dart';

// Helper function to format date
String _formatConsultationDate(DateTime dateTime) {
  final now = DateTime.now();
  final isToday =
      dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day;

  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final month = months[dateTime.month - 1];
  final day = dateTime.day;
  final year = dateTime.year;
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');

  if (isToday) {
    return 'Today - $hour:$minute';
  } else {
    return '$month $day, $year - $hour:$minute';
  }
}

class ConsultationListScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final bool isPharmacist;

  const ConsultationListScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.isPharmacist = false,
  });

  @override
  State<ConsultationListScreen> createState() => _ConsultationListScreenState();
}

class _ConsultationListScreenState extends State<ConsultationListScreen> {
  int _selectedTabIndex = 0;

  static const Color primaryGreen = Color(0xFF0F6E56);
  static const Color lightGreen = Color(0xFFE1F5EE);
  static const Color darkGreen = Color(0xFF085041);
  static const Color accentGreen = Color(0xFF9FE1CB);

  void _showNewConsultationDialog() {
    String selectedType = 'chat';
    final topicController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Request Consultation',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 20),
                // Consultation Type
                const Text(
                  'Consultation Type',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                StatefulBuilder(
                  builder: (context, setDialogState) => Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Chat Consultation'),
                        value: 'chat',
                        groupValue: selectedType,
                        onChanged: (value) {
                          setDialogState(() => selectedType = value!);
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Video Consultation'),
                        value: 'video',
                        groupValue: selectedType,
                        onChanged: (value) {
                          setDialogState(() => selectedType = value!);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Topic
                const Text(
                  'Consultation Topic',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: topicController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Medication side effects',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Description
                const Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Describe your concern...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                        ),
                        onPressed: () {
                          if (topicController.text.isEmpty ||
                              descriptionController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill in all fields'),
                              ),
                            );
                            return;
                          }

                          context
                              .read<ConsultationService>()
                              .createConsultation(
                                customerId: widget.userId,
                                customerName: widget.userName,
                                topic: topicController.text,
                                description: descriptionController.text,
                                consultationType: selectedType,
                              );

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Consultation request sent!'),
                              backgroundColor: primaryGreen,
                            ),
                          );
                        },
                        child: const Text('Request Consultation'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _acceptConsultation(
    String consultationId,
    String pharmacistId,
    String pharmacistName,
  ) {
    context.read<ConsultationService>().startConsultation(
      consultationId,
      pharmacistId,
      pharmacistName,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeleconsultationScreen(
          consultationId: consultationId,
          currentUserId: widget.userId,
          currentUserName: widget.userName,
          isPharmacist: widget.isPharmacist,
        ),
      ),
    );
  }

  Widget _buildConsultationCard(Consultation consultation) {
    Color statusColor;
    IconData statusIcon;

    switch (consultation.status) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      case 'active':
        statusColor = Colors.green;
        statusIcon = Icons.call;
        break;
      case 'completed':
        statusColor = Colors.grey;
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        consultation.topic,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        consultation.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 32),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        consultation.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  widget.isPharmacist
                      ? 'Customer: ${consultation.customerName}'
                      : 'Pharmacist: ${consultation.pharmacistName ?? 'Waiting...'}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  _formatConsultationDate(consultation.createdAt),
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accentGreen,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${consultation.consultationType.toUpperCase()} · ${consultation.messages.length} messages',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (consultation.status == 'pending' && widget.isPharmacist)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<ConsultationService>().cancelConsultation(
                          consultation.id,
                        );
                      },
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                      ),
                      onPressed: () {
                        _acceptConsultation(
                          consultation.id,
                          widget.userId,
                          widget.userName,
                        );
                      },
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              )
            else if (consultation.status == 'active' ||
                consultation.status == 'pending')
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeleconsultationScreen(
                              consultationId: consultation.id,
                              currentUserId: widget.userId,
                              currentUserName: widget.userName,
                              isPharmacist: widget.isPharmacist,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        consultation.status == 'active'
                            ? 'Join Consultation'
                            : 'View Details',
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text('Telemedicine Consultations'),
        elevation: 0,
      ),
      body: Consumer<ConsultationService>(
        builder: (context, consultationService, _) {
          List<Consultation> consultations;

          if (widget.isPharmacist) {
            if (_selectedTabIndex == 0) {
              consultations = consultationService.getPendingConsultations();
            } else {
              consultations = consultationService.getPharmacistConsultations(
                widget.userId,
              );
            }
          } else {
            consultations = consultationService.getCustomerConsultations(
              widget.userId,
            );
          }

          return Column(
            children: [
              if (widget.isPharmacist)
                Container(
                  color: lightGreen,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _selectedTabIndex = 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: _selectedTabIndex == 0
                                      ? primaryGreen
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Pending Requests',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${consultationService.getPendingConsultations().length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _selectedTabIndex = 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: _selectedTabIndex == 1
                                      ? primaryGreen
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: const Column(
                              children: [
                                Text(
                                  'My Consultations',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: consultations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.isPharmacist
                                  ? 'No pending consultations'
                                  : 'No consultations yet',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.isPharmacist
                                  ? 'Consultations will appear here'
                                  : 'Request a consultation to get started',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: consultations.length,
                        itemBuilder: (context, index) {
                          return _buildConsultationCard(consultations[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: !widget.isPharmacist
          ? FloatingActionButton.extended(
              onPressed: _showNewConsultationDialog,
              backgroundColor: primaryGreen,
              icon: const Icon(Icons.add),
              label: const Text('Request Consultation'),
            )
          : null,
    );
  }
}
