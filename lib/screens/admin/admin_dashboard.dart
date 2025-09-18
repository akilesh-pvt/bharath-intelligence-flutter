import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../login_screen.dart';

/// Admin Dashboard Screen
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    await taskProvider.loadDashboardStats();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboardOverview(),
          _buildUsersTab(),
          _buildFarmersTab(),
          _buildTasksTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: 'Farmers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tasks',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardOverview() {
    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return CustomCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Text(
                          authProvider.currentUser?.name.substring(0, 1) ?? 'A',
                          style: const TextStyle(
                            color: AppColors.buttonText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, ${authProvider.currentUser?.name}',
                              style: const TextStyle(
                                fontSize: AppConstants.textSizeLarge,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppConstants.paddingSmall / 2),
                            const Text(
                              'Administrator Dashboard',
                              style: TextStyle(
                                fontSize: AppConstants.textSizeMedium,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Statistics cards
            const Text(
              'System Overview',
              style: TextStyle(
                fontSize: AppConstants.textSizeTitle,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            
            Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                if (taskProvider.isLoadingStats) {
                  return const LoadingWidget(message: 'Loading statistics...');
                }
                
                final stats = taskProvider.dashboardStats;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: AppConstants.paddingMedium,
                  crossAxisSpacing: AppConstants.paddingMedium,
                  children: [
                    InfoCard(
                      title: 'Total Users',
                      value: '${stats['totalUsers'] ?? 0}',
                      icon: Icons.people,
                      onTap: () => _onItemTapped(1),
                    ),
                    InfoCard(
                      title: 'Total Farmers',
                      value: '${stats['totalFarmers'] ?? 0}',
                      icon: Icons.agriculture,
                      onTap: () => _onItemTapped(2),
                    ),
                    InfoCard(
                      title: 'Total Tasks',
                      value: '${stats['totalTasks'] ?? 0}',
                      icon: Icons.assignment,
                      onTap: () => _onItemTapped(3),
                    ),
                    InfoCard(
                      title: 'Pending Tasks',
                      value: '${stats['pendingTasks'] ?? 0}',
                      icon: Icons.pending_actions,
                      backgroundColor: AppColors.warning.withOpacity(0.1),
                      iconColor: AppColors.warning,
                      onTap: () => _onItemTapped(3),
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Quick actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: AppConstants.textSizeTitle,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    onTap: () {
                      // Navigate to add user
                      _onItemTapped(1);
                    },
                    child: const Column(
                      children: [
                        Icon(
                          Icons.person_add,
                          size: AppConstants.largeIconSize,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: AppConstants.paddingSmall),
                        Text(
                          'Add User',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: CustomCard(
                    onTap: () {
                      // Navigate to add farmer
                      _onItemTapped(2);
                    },
                    child: const Column(
                      children: [
                        Icon(
                          Icons.add_business,
                          size: AppConstants.largeIconSize,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: AppConstants.paddingSmall),
                        Text(
                          'Add Farmer',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
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

  Widget _buildUsersTab() {
    return const Center(
      child: Text(
        'User Management\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppConstants.textSizeLarge,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildFarmersTab() {
    return const Center(
      child: Text(
        'Farmer Management\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppConstants.textSizeLarge,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildTasksTab() {
    return const Center(
      child: Text(
        'Task Management\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppConstants.textSizeLarge,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}