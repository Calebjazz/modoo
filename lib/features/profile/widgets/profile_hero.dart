import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'profile_avatar_badge.dart';
import 'profile_hero_icon.dart';

class ProfileHero extends StatelessWidget {
  const ProfileHero({
    super.key,
    required this.userName,
    required this.email,
    required this.memberNumber,
    required this.onEditIdentity,
    required this.onCopyProfile,
    required this.onMemberCard,
  });

  final String userName;
  final String email;
  final int? memberNumber;
  final VoidCallback onEditIdentity;
  final VoidCallback onCopyProfile;
  final VoidCallback onMemberCard;

  @override
  Widget build(BuildContext context) {
    final initials = userName
        .trim()
        .split(RegExp(r'\s+'))
        .map((word) => String.fromCharCode(word.runes.first))
        .take(2)
        .join()
        .toUpperCase();
    return Column(
      children: [
        ProfileAvatarBadge(initials: initials),
        const SizedBox(height: 18),
        Text(
          userName.toUpperCase(),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.display.copyWith(fontSize: 25),
        ),
        const SizedBox(height: 5),
        Text(
          email,
          style: AppTextStyles.caption.copyWith(color: AppColors.grey),
        ),
        if (memberNumber case final id?)
          Text(
            'LOCAL ATELIER MEMBER  //  #$id',
            style: AppTextStyles.eyebrow.copyWith(fontSize: 9),
          ),
        const SizedBox(height: 14),
        const Text(
          'Your studio, wardrobe and saved looks in one place.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 18),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            FilledButton.icon(
              onPressed: onEditIdentity,
              icon: const Icon(Icons.tune_rounded, size: 16),
              label: Text(
                'EDIT IDENTITY',
                style: AppTextStyles.button.copyWith(color: AppColors.white),
              ),
              style: FilledButton.styleFrom(backgroundColor: AppColors.black),
            ),
            ProfileHeroIcon(
              icon: Icons.share_outlined,
              tooltip: 'Copy profile details',
              onPressed: onCopyProfile,
            ),
            ProfileHeroIcon(
              icon: Icons.qr_code_2_rounded,
              tooltip: 'View atelier member card',
              onPressed: onMemberCard,
            ),
          ],
        ),
      ],
    );
  }
}
