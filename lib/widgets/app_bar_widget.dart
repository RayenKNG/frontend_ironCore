import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Reusable custom AppBar with IronCore branding.
class IronCoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBrand;
  final List<Widget>? actions;
  final Widget? bottom;
  final double bottomHeight;
  final bool automaticallyImplyLeading;

  const IronCoreAppBar({
    super.key,
    this.title = '',
    this.showBrand = false,
    this.actions,
    this.bottom,
    this.bottomHeight = 0,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + bottomHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.bgSurface,
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: automaticallyImplyLeading && Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  size: 18, color: AppTheme.textSecondary),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: showBrand
          ? RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
                children: [
                  TextSpan(
                    text: 'IRON',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: 'CORE',
                    style: TextStyle(color: AppTheme.primary),
                  ),
                ],
              ),
            )
          : Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
      actions: actions,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(bottomHeight),
              child: bottom!,
            )
          : null,
      iconTheme: const IconThemeData(color: AppTheme.textSecondary),
    );
  }
}
