import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/providers/cafeteria_provider.dart';
import '../../../../core/theme/app_theme.dart';

class CafeteriaTab extends StatefulWidget {
  const CafeteriaTab({super.key});

  @override
  State<CafeteriaTab> createState() => _CafeteriaTabState();
}

class _CafeteriaTabState extends State<CafeteriaTab> {
  int _selectedMealIndex = 0;
  bool _isLoading = false;

  final List<String> _meals = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

  @override
  void initState() {
    super.initState();
    _loadCafeteriaData();
  }

  Future<void> _loadCafeteriaData() async {
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildMealSelector(),
            Expanded(
              child: _isLoading ? _buildLoading() : _buildCafeteriaContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.restaurant,
            color: AppTheme.primaryColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cafeteria',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'Today\'s menu and dining options',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // View full menu or preferences
            },
            icon: Icon(
              Icons.menu_book,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSelector() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _meals.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedMealIndex;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedMealIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: !isSelected
                    ? Border.all(color: Colors.grey[300]!, width: 1)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _meals[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading menu...',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCafeteriaContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTodaySpecial(),
          const SizedBox(height: 24),
          _buildMealMenu(),
          const SizedBox(height: 24),
          _buildCafeteriaInfo(),
          const SizedBox(height: 24),
          _buildPopularItems(),
        ],
      ),
    );
  }

  Widget _buildTodaySpecial() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange[400]!,
            Colors.orange[600]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Special',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Grilled Chicken\nwith Rice',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '₦800',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.restaurant,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_meals[_selectedMealIndex]} Menu',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildMenuItems(),
      ],
    );
  }

  Widget _buildMenuItems() {
    final menuItems = _getMenuItemsForMeal(_selectedMealIndex);
    
    return Column(
      children: menuItems.map((item) => _buildMenuItem(item)).toList(),
    );
  }

  List<Map<String, dynamic>> _getMenuItemsForMeal(int mealIndex) {
    switch (mealIndex) {
      case 0: // Breakfast
        return [
          {
            'name': 'Jollof Rice & Chicken',
            'description': 'Spicy rice with grilled chicken',
            'price': '₦600',
            'image': 'assets/images/jollof_rice.jpg',
            'isAvailable': true,
          },
          {
            'name': 'Bread & Beans',
            'description': 'Fresh bread with beans stew',
            'price': '₦400',
            'image': 'assets/images/bread_beans.jpg',
            'isAvailable': true,
          },
          {
            'name': 'Yam & Egg',
            'description': 'Boiled yam with fried egg',
            'price': '₦350',
            'image': 'assets/images/yam_egg.jpg',
            'isAvailable': false,
          },
        ];
      case 1: // Lunch
        return [
          {
            'name': 'Fried Rice & Fish',
            'description': 'Chinese-style rice with fish',
            'price': '₦700',
            'image': 'assets/images/fried_rice.jpg',
            'isAvailable': true,
          },
          {
            'name': 'Efo Riro & Pounded Yam',
            'description': 'Traditional vegetable soup',
            'price': '₦500',
            'image': 'assets/images/efo_riro.jpg',
            'isAvailable': true,
          },
        ];
      case 2: // Dinner
        return [
          {
            'name': 'Amala & Ewedu',
            'description': 'Yam flour with jute soup',
            'price': '₦450',
            'image': 'assets/images/amala.jpg',
            'isAvailable': true,
          },
          {
            'name': 'Rice & Stew',
            'description': 'White rice with tomato stew',
            'price': '₦400',
            'image': 'assets/images/rice_stew.jpg',
            'isAvailable': true,
          },
        ];
      case 3: // Snacks
        return [
          {
            'name': 'Puff Puff',
            'description': 'Sweet fried dough balls',
            'price': '₦100',
            'image': 'assets/images/puff_puff.jpg',
            'isAvailable': true,
          },
          {
            'name': 'Meat Pie',
            'description': 'Flaky pastry with meat filling',
            'price': '₦150',
            'image': 'assets/images/meat_pie.jpg',
            'isAvailable': true,
          },
        ];
      default:
        return [];
    }
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.restaurant,
              color: AppTheme.primaryColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['description'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      item['price'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item['isAvailable']
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item['isAvailable'] ? 'Available' : 'Unavailable',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: item['isAvailable'] ? Colors.green : Colors.red,
                        ),
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

  Widget _buildCafeteriaInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cafeteria Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.access_time,
            title: 'Opening Hours',
            value: '7:00 AM - 9:00 PM',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.location_on,
            title: 'Location',
            value: 'Main Campus - Building A',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.phone,
            title: 'Contact',
            value: '+234 123 456 7890',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.people,
            title: 'Capacity',
            value: '200 students',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopularItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Items',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildPopularItem(
                name: 'Jollof Rice',
                image: 'assets/images/jollof_rice.jpg',
                rating: 4.8,
              ),
              const SizedBox(width: 16),
              _buildPopularItem(
                name: 'Fried Rice',
                image: 'assets/images/fried_rice.jpg',
                rating: 4.6,
              ),
              const SizedBox(width: 16),
              _buildPopularItem(
                name: 'Amala',
                image: 'assets/images/amala.jpg',
                rating: 4.7,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopularItem({
    required String name,
    required String image,
    required double rating,
  }) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Icon(
              Icons.restaurant,
              color: AppTheme.primaryColor,
              size: 40,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.textSecondary,
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
    );
  }
}
