import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../services/storage_service.dart';
import '../../../config/routes.dart';

class _OnboardPage {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;

  const _OnboardPage(this.icon, this.title, this.description, this.gradient);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  final _pages = const [
    _OnboardPage(
      Icons.camera_alt_rounded,
      'Snap a photo, know the disease',
      'Point your camera at a leaf and get an instant AI diagnosis for tomato and potato crops — even offline.',
      AppColors.heroGradient,
    ),
    _OnboardPage(
      Icons.groups_rounded,
      'Connect with fellow farmers',
      'Share your harvest wins, ask questions, and learn from farmers across Assam and Meghalaya.',
      AppColors.sunriseGradient,
    ),
    _OnboardPage(
      Icons.forum_rounded,
      'Ask anything, in your language',
      'Get answers from AI, verified agriculture experts, and your community — by text or voice.',
      AppColors.skyGradient,
    ),
  ];

  Future<void> _finish() async {
    await StorageService.instance.setOnboardingDone();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: const Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: page.gradient),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(page.icon, size: 72, color: Colors.white),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: _pages.length,
              effect: const ExpandingDotsEffect(
                activeDotColor: AppColors.primaryGreen,
                dotColor: AppColors.divider,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryButton(
                label: isLast ? 'Get Started' : 'Next',
                onPressed: () {
                  if (isLast) {
                    _finish();
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
