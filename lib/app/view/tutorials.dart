import 'package:flutter/material.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/utils/utils.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  late PageController _pageController;
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Withdrawal Restricted Savings Accounts',
      'description':
          'Create your account in the settings if you have into do so. Select the amount and deposit interval and set the date for how long you willing to save for you',
      'features': [
        {
          'title': 'Feature 1',
          'description': 'Feature 1 description',
        },
        {
          'title': 'Feature 2',
          'description': 'Feature 2 description',
        },
        {
          'title': 'Feature 3',
          'description': 'Feature 3 description',
        },
      ],
    },
    {
      'title': 'Withdrawal Restricted Savings Accounts',
      'description':
          'Create your account in the settings if you have into do so. Select the amount and deposit interval and set the date for how long you willing to save for you',
      'features': [
        {
          'title': 'Feature 1',
          'description': 'Feature 1 description',
        },
        {
          'title': 'Feature 2',
          'description': 'Feature 2 description',
        },
        {
          'title': 'Feature 3',
          'description': 'Feature 3 description',
        },
      ],
    },
    {
      'title': 'Withdrawal Restricted Savings Accounts',
      'description':
          'Create your account in the settings if you have into do so. Select the amount and deposit interval and set the date for how long you willing to save for you',
      'features': [
        {
          'title': 'Feature 1',
          'description': 'Feature 1 description',
        },
        {
          'title': 'Feature 2',
          'description': 'Feature 2 description',
        },
        {
          'title': 'Feature 3',
          'description': 'Feature 3 description',
        },
      ],
    },
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: _currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: context.colorScheme.shadow,
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...List.generate(
                                  (_pages[index]['features'] as List<dynamic>).length,
                                  (index) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: context.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: context.colorScheme.primary,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: context.colorScheme.shadow,
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: context.colorScheme.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Transform.rotate(
                                              angle: 0.585398,
                                              child: Icon(
                                                Icons.notifications_active_rounded,
                                                color: context.colorScheme.onPrimary,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Gaps.gapMd16,
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (_pages[index]['features'] as List<Map>)[index]['title'].toString(),
                                              style: context.bodyLarge(
                                                color: context.colorScheme.secondary,
                                              ),
                                            ),
                                            Gaps.gapXs4,
                                            Text(
                                              (_pages[index]['features'] as List<Map>)[index]['description'].toString(),
                                              style: context.bodyDefault(),
                                            ),
                                          ],
                                        ),
                                        Gaps.gapMd16,
                                      ],
                                    ),
                                  ),
                                ),
                                Gaps.gapMd12,
                                Text(
                                  _pages[index]['title'].toString(),
                                  style: context.headline1().bold.setColor(context.colorScheme.secondary),
                                ),
                                Gaps.gapMd16,
                                Text(
                                  _pages[index]['description'].toString(),
                                  style: context.bodyDefault(),
                                ),
                                Gaps.gapLg24,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Gaps.gapMd16,
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == index ? context.colorScheme.primary : context.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Gaps.gapXxl48,
            CommonButton.primary(
              onPressed: () {
                GetIt.I<AppStates>().isTutorialShown = true;
              },
              label: _currentIndex == 2 ? context.l10n.getStarted : context.l10n.skip,
            ),
            const RelativeGap(mainAxisExtent: 0.04),
          ],
        ),
      ),
    );
  }
}
