import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/custom_card.dart';
import '../widgets/common/loading_widget.dart';
import 'admin/admin_dashboard.dart';
import 'field_visitor/field_visitor_dashboard.dart';

/// Login Screen with Custom Authentication
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animationController.forward();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.login(
      Helpers.cleanMobileNumber(_mobileController.text),
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      Helpers.showSuccessSnackBar(context, AppConstants.successLogin);
      _navigateToDashboard(authProvider.currentUser!.role);
    } else if (mounted) {
      Helpers.showErrorSnackBar(
        context,
        authProvider.error ?? AppConstants.errorInvalidCredentials,
      );
    }
  }

  void _navigateToDashboard(String role) {
    Widget dashboard;
    if (role == AppConstants.adminRole) {
      dashboard = const AdminDashboard();
    } else {
      dashboard = const FieldVisitorDashboard();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => dashboard,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.surfaceGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo and title
                          _buildHeader(),
                          
                          const SizedBox(height: AppConstants.paddingExtraLarge),
                          
                          // Login form
                          _buildLoginForm(),
                          
                          const SizedBox(height: AppConstants.paddingLarge),
                          
                          // Default credentials info
                          _buildCredentialsInfo(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: AppConstants.largeIconSize * 1.5,
          height: AppConstants.largeIconSize * 1.5,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppConstants.largeIconSize),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.agriculture,
            size: AppConstants.largeIconSize,
            color: AppColors.buttonText,
          ),
        ),
        const SizedBox(height: AppConstants.paddingLarge),
        const Text(
          AppConstants.appName,
          style: TextStyle(
            fontSize: AppConstants.textSizeHeading,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        Text(
          'Welcome back! Please sign in to continue.',
          style: TextStyle(
            fontSize: AppConstants.textSizeMedium,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return CustomCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Sign In',
              style: TextStyle(
                fontSize: AppConstants.textSizeTitle,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Mobile number field
            TextFormField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                hintText: 'Enter 10-digit mobile number',
                prefixIcon: Icon(Icons.phone, color: AppColors.primary),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter mobile number';
                }
                if (!Helpers.isValidMobile(value)) {
                  return AppConstants.errorInvalidMobile;
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            // Password field
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                if (!Helpers.isValidPassword(value)) {
                  return AppConstants.errorPasswordTooShort;
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Login button
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return CustomButton(
                  text: 'Sign In',
                  onPressed: _isLoading ? null : _handleLogin,
                  isLoading: _isLoading,
                  icon: Icons.login,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialsInfo() {
    return CustomCard(
      backgroundColor: AppColors.surfaceLight,
      child: Column(
        children: [
          const Text(
            'Default Login Credentials',
            style: TextStyle(
              fontSize: AppConstants.textSizeLarge,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Admin Account:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      'Mobile: 9999999999\nPassword: admin123',
                      style: TextStyle(
                        fontSize: AppConstants.textSizeMedium,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Field Visitor:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      'Mobile: 8888888888\nPassword: visitor123',
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
        ],
      ),
    );
  }
}