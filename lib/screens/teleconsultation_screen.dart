import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/consultation.dart';
import '../services/consultation_service.dart';
import '../widgets/consultation_chat_widget.dart';

// Helper function to format date and time
String _formatDateTime(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

class TeleconsultationScreen extends StatefulWidget {
  final String consultationId;
  final String currentUserId;
  final String currentUserName;
  final bool isPharmacist;

  const TeleconsultationScreen({
    super.key,
    required this.consultationId,
    required this.currentUserId,
    required this.currentUserName,
    this.isPharmacist = false,
  });

  @override
  State<TeleconsultationScreen> createState() => _TeleconsultationScreenState();
}

class _TeleconsultationScreenState extends State<TeleconsultationScreen> {
  bool _showVideo = false;
  bool _isMuted = false;
  bool _isCameraOff = false;
  late Consultation? _consultation;

  static const Color primaryGreen = Color(0xFF0F6E56);
  static const Color lightGreen = Color(0xFFE1F5EE);
  static const Color darkGreen = Color(0xFF085041);

  @override
  void initState() {
    super.initState();
    _consultation = context.read<ConsultationService>().getConsultation(
      widget.consultationId,
    );
  }

  void _handleSendMessage(String message) {
    context.read<ConsultationService>().addMessage(
      consultationId: widget.consultationId,
      senderId: widget.currentUserId,
      senderName: widget.currentUserName,
      message: message,
    );
  }

  void _endConsultation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Consultation?'),
        content: const Text('Are you sure you want to end this consultation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ConsultationService>().endConsultation(
                widget.consultationId,
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('End'),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoView() {
    return Container(
      color: darkGreen,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam, size: 80, color: Colors.white30),
                const SizedBox(height: 16),
                Text(
                  _consultation?.status == 'active'
                      ? 'Video Call Active'
                      : 'Ready for Video Call',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (_consultation?.pharmacistName != null)
                  Text(
                    'with ${_consultation?.pharmacistName}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
              ],
            ),
          ),
          // Video Controls
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mute Button
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() => _isMuted = !_isMuted);
                      },
                      icon: Icon(
                        _isMuted ? Icons.mic_off : Icons.mic,
                        color: _isMuted ? Colors.red : Colors.white,
                      ),
                      iconSize: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Camera Toggle
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() => _isCameraOff = !_isCameraOff);
                      },
                      icon: Icon(
                        _isCameraOff ? Icons.videocam_off : Icons.videocam,
                        color: _isCameraOff ? Colors.red : Colors.white,
                      ),
                      iconSize: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // End Call Button
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _endConsultation,
                      icon: const Icon(Icons.call_end, color: Colors.white),
                      iconSize: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConsultationService>(
      builder: (context, consultationService, _) {
        _consultation = consultationService.getConsultation(
          widget.consultationId,
        );

        if (_consultation == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Consultation')),
            body: const Center(child: Text('Consultation not found')),
          );
        }

        return WillPopScope(
          onWillPop: () async {
            if (_consultation!.status == 'active') {
              return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Leave Consultation?'),
                      content: const Text(
                        'Your consultation is still active. Are you sure you want to leave?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Leave'),
                        ),
                      ],
                    ),
                  ) ??
                  false;
            }
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: primaryGreen,
              title: const Text('Telemedicine Consultation'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                if (_consultation!.status == 'active')
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Active',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            body: Column(
              children: [
                // Consultation Info Header
                Container(
                  color: lightGreen,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _consultation!.topic,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.person, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.isPharmacist
                                  ? 'Customer: ${_consultation!.customerName}'
                                  : 'Pharmacist: ${_consultation!.pharmacistName ?? 'Waiting for acceptance...'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Started: ${_consultation!.startedAt != null ? _formatDateTime(_consultation!.startedAt!) : 'Not started'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Toggle between Chat and Video
                if (_consultation!.consultationType == 'video')
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: !_showVideo
                                      ? primaryGreen
                                      : Colors.grey[300]!,
                                  width: !_showVideo ? 2 : 1,
                                ),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () =>
                                  setState(() => _showVideo = false),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat,
                                    color: !_showVideo
                                        ? primaryGreen
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Chat'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: _showVideo
                                      ? primaryGreen
                                      : Colors.grey[300]!,
                                  width: _showVideo ? 2 : 1,
                                ),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () =>
                                  setState(() => _showVideo = true),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.videocam,
                                    color: _showVideo
                                        ? primaryGreen
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Video'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Main Content Area
                Expanded(
                  child: _showVideo
                      ? _buildVideoView()
                      : ConsultationChatWidget(
                          consultation: _consultation!,
                          currentUserId: widget.currentUserId,
                          currentUserName: widget.currentUserName,
                          onSendMessage: _handleSendMessage,
                          isPharmacist: widget.isPharmacist,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
