import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/providers/permissions_provider.dart';
import 'package:mindful/ui/common/sliver_primary_action_container.dart';

class UsageAccessPermission extends ConsumerWidget {
  /// Creates a animated [SliverPrimaryActionContainer] for asking permission from user
  /// with self handled state and automatically hides itself if the user have granted the permission
  const UsageAccessPermission({
    super.key,
    this.showEvenIfGranted = false,
  });

  final bool showEvenIfGranted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final havePermission = ref
        .watch(permissionProvider.select((v) => v.haveUsageAccessPermission));

    return SliverPrimaryActionContainer(
      isVisible: !havePermission || showEvenIfGranted,
      margin: const EdgeInsets.only(bottom: 8),
      title: "Usage access",
      information:
          "Please grant usage access permission. This will allow Mindful to monitor app usage and manage access to certain apps, ensuring a more focused and controlled digital environment.",
      actionBtnLabel: havePermission ? "Already granted" : "Allow",
      actionBtnIcon: havePermission
          ? const Icon(FluentIcons.checkmark_circle_20_filled)
          : null,
      onTapAction: !havePermission
          ? ref.read(permissionProvider.notifier).askUsageAccessPermission
          : () {},
    );
  }
}
