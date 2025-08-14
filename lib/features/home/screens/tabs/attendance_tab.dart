import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lottie/lottie.dart' as lottie;
import '../../../../core/theme/app_theme.dart';

// Conditional import for QR scanner (mobile only)
import 'qr_scanner_mobile.dart' if (dart.library.html) 'qr_scanner_web.dart';

class AttendanceTab extends StatefulWidget {
  const AttendanceTab({super.key});

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrViewController;
  bool _isScanning = false;
  bool _isLoading = false;
  String _scanResult = '';
  String _selectedTab = 'Scan';
  
  // Sample attendance data
  final List<Map<String, dynamic>> _attendanceHistory = [
    {
      'id': '1',
      'course': 'Computer Science 301',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'time': '09:00 AM',
      'status': 'Present',
      'location': 'Science Complex, Room 201',
      'instructor': 'Dr. Johnson',
      'duration': '2 hours',
    },
    {
      'id': '2',
      'course': 'Mathematics 205',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'time': '11:00 AM',
      'status': 'Present',
      'location': 'Engineering Building, Room 105',
      'instructor': 'Prof. Smith',
      'duration': '1.5 hours',
    },
    {
      'id': '3',
      'course': 'Physics 101',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'time': '02:00 PM',
      'status': 'Late',
      'location': 'Science Complex, Lab 301',
      'instructor': 'Dr. Williams',
      'duration': '3 hours',
    },
    {
      'id': '4',
      'course': 'Business Ethics',
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'time': '10:00 AM',
      'status': 'Present',
      'location': 'Business School, Room 401',
      'instructor': 'Prof. Davis',
      'duration': '1 hour',
    },
    {
      'id': '5',
      'course': 'English Literature',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'time': '03:00 PM',
      'status': 'Absent',
      'location': 'Main Library, Study Room 2',
      'instructor': 'Dr. Brown',
      'duration': '1.5 hours',
    },
  ];

  final List<Map<String, dynamic>> _upcomingClasses = [
    {
      'id': '1',
      'course': 'Computer Science 301',
      'date': DateTime.now().add(const Duration(days: 1)),
      'time': '09:00 AM',
      'location': 'Science Complex, Room 201',
      'instructor': 'Dr. Johnson',
      'duration': '2 hours',
      'qrCode': 'CS301_${DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch}',
    },
    {
      'id': '2',
      'course': 'Mathematics 205',
      'date': DateTime.now().add(const Duration(days: 2)),
      'time': '11:00 AM',
      'location': 'Engineering Building, Room 105',
      'instructor': 'Prof. Smith',
      'duration': '1.5 hours',
      'qrCode': 'MATH205_${DateTime.now().add(const Duration(days: 2)).millisecondsSinceEpoch}',
    },
    {
      'id': '3',
      'course': 'Physics 101',
      'date': DateTime.now().add(const Duration(days: 3)),
      'time': '02:00 PM',
      'location': 'Science Complex, Lab 301',
      'instructor': 'Dr. Williams',
      'duration': '3 hours',
      'qrCode': 'PHY101_${DateTime.now().add(const Duration(days: 3)).millisecondsSinceEpoch}',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  void _startScanning() {
    setState(() {
      _isScanning = true;
      _scanResult = '';
    });
  }

  void _stopScanning() {
    setState(() {
      _isScanning = false;
    });
    _qrViewController?.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    _qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && _isScanning) {
        _processQRCode(scanData.code!);
      }
    });
  }

  void _processQRCode(String code) {
    setState(() {
      _isScanning = false;
      _scanResult = code;
      _isLoading = true;
    });

    // Simulate processing time
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      
      _showAttendanceResult(code);
    });
  }

  void _showAttendanceResult(String code) {
    // Parse QR code to get course information
    String courseName = 'Unknown Course';
    String instructor = 'Unknown Instructor';
    
    if (code.startsWith('CS301')) {
      courseName = 'Computer Science 301';
      instructor = 'Dr. Johnson';
    } else if (code.startsWith('MATH205')) {
      courseName = 'Mathematics 205';
      instructor = 'Prof. Smith';
    } else if (code.startsWith('PHY101')) {
      courseName = 'Physics 101';
      instructor = 'Dr. Williams';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Attendance Marked'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course: $courseName'),
            const SizedBox(height: 8),
            Text('Instructor: $instructor'),
            const SizedBox(height: 8),
            Text('Time: ${DateTime.now().toString().substring(11, 16)}'),
            const SizedBox(height: 8),
            const Text('Status: Present'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.green[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your attendance has been successfully recorded!',
                      style: TextStyle(color: Colors.green[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startScanning();
            },
            child: const Text('Scan Another'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _selectedTab = 'History';
              });
            },
            child: const Text('View History'),
          ),
        ],
      ),
    );
  }

  void _manualAttendance() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildManualAttendanceSheet(),
    );
  }

  Widget _buildManualAttendanceSheet() {
    String selectedCourse = _upcomingClasses.first['course'];
    String selectedStatus = 'Present';
    
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.edit_note,
                        color: AppTheme.primaryColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Manual Attendance',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Mark attendance manually',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course selection
                      const Text(
                        'Select Course',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          value: selectedCourse,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: _upcomingClasses.map<DropdownMenuItem<String>>((course) {
                            return DropdownMenuItem<String>(
                              value: course['course'] as String,
                              child: Text(course['course'] as String),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setModalState(() {
                              selectedCourse = value!;
                            });
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Status selection
                      const Text(
                        'Attendance Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatusOption(
                              'Present',
                              Icons.check_circle,
                              Colors.green,
                              selectedStatus == 'Present',
                              () {
                                setModalState(() {
                                  selectedStatus = 'Present';
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatusOption(
                              'Late',
                              Icons.schedule,
                              Colors.orange,
                              selectedStatus == 'Late',
                              () {
                                setModalState(() {
                                  selectedStatus = 'Late';
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatusOption(
                              'Absent',
                              Icons.cancel,
                              Colors.red,
                              selectedStatus == 'Absent',
                              () {
                                setModalState(() {
                                  selectedStatus = 'Absent';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _submitManualAttendance(selectedCourse, selectedStatus);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Submit Attendance',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(String status, IconData icon, Color color, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey[600], size: 32),
            const SizedBox(height: 8),
            Text(
              status,
              style: TextStyle(
                color: isSelected ? color : Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitManualAttendance(String course, String status) {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Attendance marked as $status for $course'),
          backgroundColor: status == 'Present' ? Colors.green : 
                         status == 'Late' ? Colors.orange : Colors.red,
        ),
      );
    });
  }

  Widget _buildStatistics() {
    int totalClasses = _attendanceHistory.length;
    int presentCount = _attendanceHistory.where((a) => a['status'] == 'Present').length;
    int lateCount = _attendanceHistory.where((a) => a['status'] == 'Late').length;
    int absentCount = _attendanceHistory.where((a) => a['status'] == 'Absent').length;
    double attendanceRate = totalClasses > 0 ? (presentCount / totalClasses) * 100 : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attendance Statistics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Overall attendance rate
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '${attendanceRate.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Overall Attendance Rate',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Detailed statistics
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Present',
                  presentCount.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Late',
                  lateCount.toString(),
                  Icons.schedule,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Absent',
                  absentCount.toString(),
                  Icons.cancel,
                  Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceHistory() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _attendanceHistory.length,
      itemBuilder: (context, index) {
        final attendance = _attendanceHistory[index];
        final status = attendance['status'] as String;
        
        Color statusColor;
        IconData statusIcon;
        
        switch (status) {
          case 'Present':
            statusColor = Colors.green;
            statusIcon = Icons.check_circle;
            break;
          case 'Late':
            statusColor = Colors.orange;
            statusIcon = Icons.schedule;
            break;
          case 'Absent':
            statusColor = Colors.red;
            statusIcon = Icons.cancel;
            break;
          default:
            statusColor = Colors.grey;
            statusIcon = Icons.help;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(statusIcon, color: statusColor, size: 24),
            ),
            title: Text(
              attendance['course'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('${attendance['date'].toString().substring(0, 10)} at ${attendance['time']}'),
                Text('${attendance['location']} • ${attendance['instructor']}'),
                Text('Duration: ${attendance['duration']}'),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpcomingClasses() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _upcomingClasses.length,
      itemBuilder: (context, index) {
        final course = _upcomingClasses[index];
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.schedule, color: AppTheme.primaryColor, size: 24),
            ),
            title: Text(
              course['course'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('${course['date'].toString().substring(0, 10)} at ${course['time']}'),
                Text('${course['location']} • ${course['instructor']}'),
                Text('Duration: ${course['duration']}'),
              ],
            ),
            trailing: IconButton(
              onPressed: () => _showQRCode(course),
              icon: const Icon(Icons.qr_code, color: AppTheme.primaryColor),
              tooltip: 'View QR Code',
            ),
          ),
        );
      },
    );
  }

  void _showQRCode(Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('QR Code for ${course['course']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.qr_code, size: 64, color: AppTheme.primaryColor),
                  const SizedBox(height: 16),
                  Text(
                    course['qrCode'],
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Show this QR code to your instructor or scan it with another device to mark attendance.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attendance'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: const TabBar(
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primaryColor,
            tabs: [
              Tab(text: 'Scan', icon: Icon(Icons.qr_code_scanner)),
              Tab(text: 'Manual', icon: Icon(Icons.edit_note)),
              Tab(text: 'History', icon: Icon(Icons.history)),
              Tab(text: 'Upcoming', icon: Icon(Icons.schedule)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Scan Tab
            _buildScanTab(),
            
            // Manual Tab
            _buildManualTab(),
            
            // History Tab
            _buildHistoryTab(),
            
            // Upcoming Tab
            _buildUpcomingTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildScanTab() {
    return Stack(
      children: [
        // QR Scanner
        if (_isScanning)
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        
        // Manual attendance button
        if (_isScanning)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: _manualAttendance,
                icon: const Icon(Icons.edit_note),
                label: const Text('Manual Attendance'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ),
        
        // Loading overlay
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  lottie.Lottie.asset(
                    'assets/animations/wave.json',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Processing attendance...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        // Scan result display
        if (_scanResult.isNotEmpty && !_isLoading)
          Container(
            color: Colors.black.withOpacity(0.8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.qr_code,
                    size: 64,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'QR Code Scanned:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _scanResult,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _scanResult = '';
                            _startScanning();
                          });
                        },
                        child: const Text('Scan Again'),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _scanResult = '';
                            _startScanning();
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildManualTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildStatistics(),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        'Mark Present',
                        Icons.check_circle,
                        Colors.green,
                        () => _manualAttendance(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionCard(
                        'Mark Late',
                        Icons.schedule,
                        Colors.orange,
                        () => _manualAttendance(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return _buildAttendanceHistory();
  }

  Widget _buildUpcomingTab() {
    return _buildUpcomingClasses();
  }

  @override
  void dispose() {
    _qrViewController?.dispose();
    super.dispose();
  }
}
