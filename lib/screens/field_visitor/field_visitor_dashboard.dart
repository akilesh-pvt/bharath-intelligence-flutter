import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../login_screen.dart';

/// Field Visitor Dashboard Screen
class FieldVisitorDashboard extends StatefulWidget {
  const FieldVisitorDashboard({Key? key}) : super(key: key);

  @override
  _FieldVisitorDashboardState createState() => _FieldVisitorDashboardState();
}

class _FieldVisitorDashboardState extends State<FieldVisitorDashboard> {
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    if (authProvider.currentUser != null) {
      await Future.wait([
        taskProvider.loadMyTasks(authProvider.currentUser!.id),
        taskProvider.loadMyClaims(authProvider.currentUser!.id),
        taskProvider.loadDashboardStats(userId: authProvider.currentUser!.id),
      ]);
    }
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
        title: const Text('Field Visitor Dashboard'),
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
          _buildMyTasksTab(),
          _buildMyClaimsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.assignment),
            label: 'My Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'My Claims',
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
                          authProvider.currentUser?.name.substring(0, 1) ?? 'F',
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
                              'Field Visitor Dashboard',
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
              'My Work Overview',
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
                  return const LoadingWidget(message: 'Loading your work...');
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
                      title: 'My Tasks',
                      value: '${stats['myTasks'] ?? 0}',
                      icon: Icons.assignment,
                      onTap: () => _onItemTapped(1),
                    ),
                    InfoCard(
                      title: 'My Claims',
                      value: '${stats['myClaims'] ?? 0}',
                      icon: Icons.receipt,
                      onTap: () => _onItemTapped(2),
                    ),
                    InfoCard(
                      title: 'Pending Tasks',
                      value: '${taskProvider.getPendingTasks().length}',
                      icon: Icons.pending_actions,
                      backgroundColor: AppColors.warning.withOpacity(0.1),
                      iconColor: AppColors.warning,
                      onTap: () => _onItemTapped(1),
                    ),
                    InfoCard(
                      title: 'Completed',
                      value: '${taskProvider.getCompletedTasks().length}',
                      icon: Icons.check_circle,
                      backgroundColor: AppColors.success.withOpacity(0.1),
                      iconColor: AppColors.success,
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Recent tasks
            const Text(
              'Recent Tasks',
              style: TextStyle(
                fontSize: AppConstants.textSizeTitle,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            
            Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                if (taskProvider.isLoading) {
                  return const LoadingWidget(message: 'Loading tasks...');
                }
                
                final recentTasks = taskProvider.tasks.take(3).toList();
                
                if (recentTasks.isEmpty) {
                  return const CustomCard(
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: AppConstants.largeIconSize,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: AppConstants.paddingMedium),
                          Text(
                            'No tasks assigned yet',
                            style: TextStyle(
                              fontSize: AppConstants.textSizeMedium,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                return Column(
                  children: recentTasks.map((task) {
                    return ListItemCard(
                      title: task.title,
                      subtitle: 'Farmer: ${task.farmerName}',
                      trailing: Helpers.formatDate(task.createdAt),
                      statusColor: Helpers.getStatusColor(task.status),
                      onTap: () {
                        // Navigate to task details
                        _onItemTapped(1);
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyTasksTab() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        if (taskProvider.isLoading) {
          return const LoadingWidget(message: 'Loading your tasks...');
        }
        
        if (taskProvider.tasks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: AppConstants.largeIconSize * 2,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppConstants.paddingLarge),
                Text(
                  'No tasks assigned',
                  style: TextStyle(
                    fontSize: AppConstants.textSizeExtraLarge,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppConstants.paddingSmall),
                Text(
                  'Your assigned tasks will appear here',
                  style: TextStyle(
                    fontSize: AppConstants.textSizeMedium,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return StatusCard(
                title: task.title,
                status: task.status,
                statusColor: Helpers.getStatusColor(task.status),
                description: 'Farmer: ${task.farmerName}\nCreated: ${Helpers.formatDate(task.createdAt)}',
                onTap: () {
                  // Navigate to task details
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMyClaimsTab() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        if (taskProvider.isLoadingClaims) {
          return const LoadingWidget(message: 'Loading your claims...');
        }
        
        if (taskProvider.claims.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_outlined,
                  size: AppConstants.largeIconSize * 2,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppConstants.paddingLarge),
                Text(
                  'No claims submitted',
                  style: TextStyle(
                    fontSize: AppConstants.textSizeExtraLarge,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppConstants.paddingSmall),
                Text(
                  'Your submitted claims will appear here',
                  style: TextStyle(
                    fontSize: AppConstants.textSizeMedium,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            itemCount: taskProvider.claims.length,
            itemBuilder: (context, index) {
              final claim = taskProvider.claims[index];
              return StatusCard(
                title: 'Claim #${claim.id}',
                status: claim.status,
                statusColor: Helpers.getStatusColor(claim.status),
                description: 'Amount: ${Helpers.formatCurrency(claim.amount)}\nTask: ${claim.taskTitle}\nDate: ${Helpers.formatDate(claim.createdAt)}',
              );
            },
          ),
        );
      },
    );
  }
}