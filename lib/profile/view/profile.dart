import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/profile/profile.dart';
import 'package:testingapp/utils/utils.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late UserProfileService _userProfileService;

  @override
  void initState() {
    super.initState();
    _userProfileService = GetIt.instance<UserProfileService>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _userProfileService.fetchUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.account),
      ),
      body: StreamBuilder<ProfileState>(
        stream: _userProfileService.profileStateStream,
        builder: (context, snapshot) {
          final userProfile = _userProfileService.userProfile;
          if (userProfile == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ExtendedColumn(
            children: [
              Gaps.gapMd16,
              SizedBox(
                width: double.infinity,
                height: 120,
                child: Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary,
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: InkWell(
                              onTap: () {
                                log('Edit Profile');
                              },
                              customBorder: const CircleBorder(),
                              child: Icon(Icons.edit, color: context.colorScheme.onPrimary),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.gapMd16,
              UserDetailItem(
                title: context.l10n.firstName,
                value: userProfile.firstName,
              ),
              Gaps.gapSm8,
              UserDetailItem(
                title: context.l10n.lastName,
                value: userProfile.lastName,
              ),
              Gaps.gapSm8,
              const Spacer(),
              CommonButton.primary(
                onPressed: () {},
                label: context.l10n.editProfile,
              ),
              Gaps.gapMd16,
              CommonButton.outline(
                onPressed: () {},
                label: context.l10n.changePassword,
              ),
              const RelativeGap(mainAxisExtent: 0.05),
            ],
          );
        },
      ),
    );
  }
}

class UserDetailItem extends StatelessWidget {
  const UserDetailItem({
    required this.title,
    required this.value,
    super.key,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: context.bodyDefault(),
          ),
          const Spacer(),
          Text(
            value,
            style: context.bodyDefault(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
