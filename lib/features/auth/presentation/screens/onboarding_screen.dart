import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:hostel_managemet/core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  bool _isLastPage = false;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Raise Issues Easily',
      'desc': 'Report hostel problems instantly with photos and detailed descriptions.',
      'icon': '📝',
    },
    {
      'title': 'Track Ticket Status',
      'desc': 'Monitor your complaints from submission to resolution with live updates.',
      'icon': '📈',
    },
    {
      'title': 'Fast Resolution by Hostel Admin',
      'desc': 'Get quick responses and efficient solutions from your hostel management team',
      'icon': '⚡',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _isLastPage = index == 2),
            itemCount: _slides.length,
            itemBuilder: (context, index) => _OnboardingSlide(
              title: _slides[index]['title']!,
              desc: _slides[index]['desc']!,
              icon: _slides[index]['icon']!,
            ),
          ),
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => context.go('/hostels'),
                  child: const Text('Skip', style: TextStyle(color: AppColors.textMuted)),
                ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.primary,
                    dotColor: AppColors.primary.withValues(alpha: 0.2),
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 4,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_isLastPage) {
                      context.go('/hostels');
                    } else {
                      _pageController.nextPage(
                        duration: 300.ms,
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_isLastPage ? 'Get Started' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final String title;
  final String desc;
  final String icon;

  const _OnboardingSlide({
    required this.title,
    required this.desc,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              icon,
              style: const TextStyle(fontSize: 80),
            ).animate().scale(delay: 200.ms),
          ),
          const SizedBox(height: 60),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
          const SizedBox(height: 16),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }
}
