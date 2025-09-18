import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/supabase_config.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import 'login_screen.dart';

/// Performance-Optimized Splash Screen with 3-second Animation
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _showConfigError = false;

  @override
  void initState() {
    super.initState();
    _setupOptimizedAnimations();
    _initializeAndNavigate();
  }

  void _setupOptimizedAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: AppConstants.longAnimationDuration),
      vsync: this,
    );

    // Fade animation for smooth entrance
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Scale animation for dynamic effect
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Slide animation for title
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  void _initializeAndNavigate() async {
    try {
      // Check if Supabase is configured
      if (!SupabaseConfig.isConfigured) {
        setState(() {
          _showConfigError = true;
        });
        return;
      }

      // Initialize authentication
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.initialize();

      // Navigate after 3 seconds
      Timer(const Duration(seconds: AppConstants.splashDuration), () {
        if (mounted) {
          _navigateToNextScreen();
        }
      });
    } catch (e) {
      setState(() {
        _showConfigError = true;
      });
    }
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
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
        transitionDuration: const Duration(milliseconds: AppConstants.animationDuration),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                if (_showConfigError) {
                  return _buildConfigurationError();
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Icon with scale animation
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: AppConstants.largeIconSize * 2,
                          height: AppConstants.largeIconSize * 2,
                          decoration: BoxDecoration(
                            color: AppColors.buttonText,
                            borderRadius: BorderRadius.circular(
                              AppConstants.largeIconSize,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.agriculture,
                            size: AppConstants.largeIconSize,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.paddingLarge),
                    
                    // App name with slide animation
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Text(
                          AppConstants.appName,
                          style: TextStyle(
                            fontSize: AppConstants.textSizeHeading + 4,
                            fontWeight: FontWeight.bold,
                            color: AppColors.buttonText,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.paddingSmall),
                    
                    // App description
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        AppConstants.appDescription,
                        style: TextStyle(
                          fontSize: AppConstants.textSizeLarge,
                          color: AppColors.buttonText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.paddingExtraLarge),
                    
                    // Loading indicator
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.buttonText,
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfigurationError() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: AppConstants.largeIconSize,
            color: AppColors.buttonText,
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          const Text(
            'Configuration Required',
            style: TextStyle(
              fontSize: AppConstants.textSizeTitle,
              fontWeight: FontWeight.bold,
              color: AppColors.buttonText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          const Text(
            'Please configure your Supabase credentials in:\nlib/config/supabase_config.dart',
            style: TextStyle(
              fontSize: AppConstants.textSizeMedium,
              color: AppColors.buttonText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          const Text(
            'Check README.md for detailed setup instructions.',
            style: TextStyle(
              fontSize: AppConstants.textSizeMedium,
              color: AppColors.buttonText,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}