import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/models/prayer.dart';

class TeleprompterScreen extends StatefulWidget {
  final Prayer prayer;

  const TeleprompterScreen({super.key, required this.prayer});

  @override
  State<TeleprompterScreen> createState() => _TeleprompterScreenState();
}

class _TeleprompterScreenState extends State<TeleprompterScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  
  bool _isPlaying = false;
  double _scrollSpeed = 30.0; // pixels per second
  double _fontSizeOffset = 0.0; // Dynamic font adjustment

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _startScrolling();
    } else {
      _scrollTimer?.cancel();
    }
  }

  void _startScrolling() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_scrollController.hasClients) return;
      
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      
      if (currentScroll >= maxScroll) {
        // Reached the end
        setState(() {
          _isPlaying = false;
        });
        timer.cancel();
        return;
      }

      // Calculate translation step (50ms = 1/20 of a second)
      final step = _scrollSpeed / 20.0;
      _scrollController.jumpTo(currentScroll + step);
    });
  }

  void _changeFontSize(double delta) {
    setState(() {
      _fontSizeOffset = (_fontSizeOffset + delta).clamp(-4.0, 12.0);
    });
  }

  void _changeSpeed(double delta) {
    setState(() {
      _scrollSpeed = (_scrollSpeed + delta).clamp(10.0, 100.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ivory,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Đọc Văn Khấn'),
        backgroundColor: AppColors.ivory,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // The scrollable text content
          GestureDetector(
            onTap: () {
              // Pause if user taps on screen
              if (_isPlaying) _togglePlayPause();
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 160), // Space for bottom controls
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.prayer.name,
                    textAlign: TextAlign.center,
                    style: AppTypography.title.copyWith(
                      color: AppColors.templeRed,
                      fontSize: 24 + _fontSizeOffset,
                    ),
                  ).animate().fadeIn(),
                  
                  AppSpacing.gap24,

                  Text(
                    widget.prayer.content,
                    textAlign: TextAlign.center, // Typical for traditional prayers
                    style: AppTypography.body.copyWith(
                      fontSize: 18 + _fontSizeOffset, // Default slightly larger for reading
                      height: 1.8, // Relaxed line height
                      color: AppColors.textPrimary,
                    ),
                  ).animate().fadeIn(delay: 150.ms),
                ],
              ),
            ),
          ),

          // Bottom Control Bar
          Positioned(
            left: 16,
            right: 16,
            bottom: 32,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Font Size Controls
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ControlButton(
                        icon: Icons.text_decrease,
                        onPressed: () => _changeFontSize(-2.0),
                      ),
                      _ControlButton(
                        icon: Icons.text_increase,
                        onPressed: () => _changeFontSize(2.0),
                      ),
                    ],
                  ),
                  
                  // Play/Pause Button
                  GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: const BoxDecoration(
                        color: AppColors.templeRed,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppColors.white,
                        size: 32,
                      ),
                    ),
                  ),

                  // Speed Controls
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ControlButton(
                        icon: Icons.fast_rewind,
                        onPressed: () => _changeSpeed(-10.0),
                      ),
                      _ControlButton(
                        icon: Icons.fast_forward,
                        onPressed: () => _changeSpeed(10.0),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().slideY(begin: 1.0, duration: 400.ms, curve: Curves.easeOutBack),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ControlButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: AppColors.textSecondary, size: 24),
        ),
      ),
    );
  }
} // EOF
