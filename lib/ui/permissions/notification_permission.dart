import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/providers/permissions_provider.dart';
import 'package:mindful/ui/common/sliver_primary_action_container.dart';

class NotificationPermission extends ConsumerWidget {
  const NotificationPermission({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final havePermission = ref
        .watch(permissionProvider.select((v) => v.haveNotificationPermission));

    return SliverPrimaryActionContainer(
      isVisible: !havePermission,
      margin: const EdgeInsets.only(bottom: 8),
      title: "Notification",
      information:
          "Please grant notification permission. This will allow Mindful to send you important reminders and updates, helping you stay on track and maintain a focused environment.",
      onTapAction:
          ref.read(permissionProvider.notifier).askNotificationPermission,
    );
  }
}
