import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/providers/permissions_provider.dart';
import 'package:mindful/ui/common/sliver_primary_action_container.dart';

class NotificationPermission extends ConsumerWidget {
  /// Creates a animated [SliverPrimaryActionContainer] for asking permission from user
  /// with self handled state and automatically hides itself if the user have granted the permission
  const NotificationPermission({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final havePermission = ref
        .watch(permissionProvider.select((v) => v.haveNotificationPermission));

    return SliverPrimaryActionContainer(
      isVisible: !havePermission,
      margin: const EdgeInsets.only(bottom: 8),
      icon: FluentIcons.alert_on_20_regular,
      title: "Notification",
      information:
          "Please grant notification permission. This will allow Mindful to send you important reminders and updates, helping you stay on track and maintain a focused environment.",
      actionBtnLabel: havePermission ? "Already granted" : "Allow",
      actionBtnIcon: havePermission
          ? const Icon(FluentIcons.checkmark_circle_20_filled)
          : null,
      onTapAction: !havePermission
          ? ref.read(permissionProvider.notifier).askNotificationPermission
          : null,
    );
  }
}
