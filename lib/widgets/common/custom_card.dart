import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';

/// Custom Card Widget with Light Green Theme
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double elevation;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool showShadow;
  final Border? border;
  final Gradient? gradient;

  const CustomCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation = AppConstants.cardElevation,
    this.borderRadius = AppConstants.borderRadius,
    this.onTap,
    this.showShadow = true,
    this.border,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget cardChild = Container(
      padding: padding ?? const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? AppColors.cardBackground) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: showShadow ? [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: elevation,
            offset: Offset(0, elevation / 2),
          ),
        ] : null,
      ),
      child: child,
    );

    if (onTap != null) {
      cardChild = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: cardChild,
        ),
      );
    }

    return Container(
      margin: margin ?? const EdgeInsets.all(AppConstants.paddingSmall),
      child: cardChild,
    );
  }
}

/// Info Card for Dashboard Statistics
class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const InfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      backgroundColor: backgroundColor,
      gradient: backgroundColor == null ? LinearGradient(
        colors: AppColors.primaryGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppConstants.largeIconSize,
            color: iconColor ?? AppColors.buttonText,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            value,
            style: TextStyle(
              fontSize: AppConstants.textSizeHeading,
              fontWeight: FontWeight.bold,
              color: iconColor ?? AppColors.buttonText,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            title,
            style: TextStyle(
              fontSize: AppConstants.textSizeMedium,
              color: (iconColor ?? AppColors.buttonText).withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// List Item Card
class ListItemCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? trailing;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final VoidCallback? onTap;
  final Color? statusColor;
  final bool showDivider;

  const ListItemCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.leadingWidget,
    this.trailingWidget,
    this.onTap,
    this.statusColor,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall / 2,
      ),
      child: Row(
        children: [
          if (leadingWidget != null) ..[
            leadingWidget!,
            const SizedBox(width: AppConstants.paddingMedium),
          ],
          if (statusColor != null) ..[
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppConstants.textSizeLarge,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ..[
                  const SizedBox(height: AppConstants.paddingSmall / 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: AppConstants.textSizeMedium,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null || trailingWidget != null) ..[
            const SizedBox(width: AppConstants.paddingMedium),
            trailingWidget ?? Text(
              trailing!,
              style: const TextStyle(
                fontSize: AppConstants.textSizeMedium,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (onTap != null) ..[
            const SizedBox(width: AppConstants.paddingSmall),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ],
      ),
    );
  }
}

/// Status Card with Color Indicator
class StatusCard extends StatelessWidget {
  final String title;
  final String status;
  final Color statusColor;
  final String? description;
  final VoidCallback? onTap;
  final Widget? actions;

  const StatusCard({
    Key? key,
    required this.title,
    required this.status,
    required this.statusColor,
    this.description,
    this.onTap,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius / 2),
                  border: Border.all(
                    color: statusColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: AppConstants.textSizeSmall,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              if (actions != null) actions!,
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppConstants.textSizeLarge,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (description != null) ..[
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              description!,
              style: const TextStyle(
                fontSize: AppConstants.textSizeMedium,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}