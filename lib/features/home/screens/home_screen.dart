import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/attendance_tab.dart';
import 'tabs/schedule_tab.dart';
import 'tabs/cafeteria_tab.dart';
import 'tabs/maps_tab.dart';
import 'tabs/chat_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Widget> _screens = [
    const DashboardTab(),
    const AttendanceTab(),
    const ScheduleTab(),
    const CafeteriaTab(),
    const MapsTab(),
    const ChatTab(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.1, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
          setState(() {
            _currentIndex = index;
          });
    
    // Restart animation for smooth transitions
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Demo Mode Banner
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.token?.startsWith('demo_token_') == true) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Demo Mode - Testing without backend connection',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Demo Mode'),
                              content: Text(
                                'You are currently in demo mode. This allows you to test the app features without connecting to the backend server.\n\n'
                                'To exit demo mode, log out and log in with real credentials.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.help_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // Main Content
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _screens[_currentIndex],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildAnimatedBottomNav(),
    );
  }

  Widget _buildAnimatedBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
              child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
              _buildNavItem(0, Icons.dashboard_rounded, 'Dashboard'),
              _buildNavItem(1, Icons.qr_code_scanner_rounded, 'Attendance'),
              _buildNavItem(2, Icons.schedule_rounded, 'Schedule'),
              _buildNavItem(3, Icons.restaurant_rounded, 'Cafeteria'),
              _buildNavItem(4, Icons.map_rounded, 'Maps'),
              _buildNavItem(5, Icons.chat_bubble_rounded, 'Chat'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => _onTabChanged(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
          child: Column(
          mainAxisSize: MainAxisSize.min,
            children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(isSelected ? 8 : 4),
                decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                size: isSelected ? 24 : 20,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isSelected ? 12 : 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
              ),
              child: Text(label),
              ),
            ],
          ),
      ),
    );
  }
} 