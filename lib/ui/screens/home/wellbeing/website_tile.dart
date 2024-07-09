import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/providers/wellbeing_provider.dart';
import 'package:mindful/ui/common/default_list_tile.dart';
import 'package:mindful/ui/common/rounded_container.dart';
import 'package:mindful/ui/dialogs/remove_confirm_dialog.dart';

class WebsiteTile extends ConsumerWidget {
  const WebsiteTile({required this.websitehost, super.key});

  final String websitehost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultListTile(
      height: 50,
      leading: const RoundedContainer(width: 12, height: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      titleText: websitehost,
      trailing: IconButton(
        iconSize: 18,
        icon: const Icon(FluentIcons.delete_dismiss_20_regular),
        onPressed: () async {
          final confirm = await showRemoveConfirmDialog(
            context: context,
            title: "Remove website",
            info:
                "Are you sure? you want to remove \"$websitehost\" from blocked websites.",
          );

          if (confirm) {
            ref
                .read(wellBeingProvider.notifier)
                .insertRemoveBlockedSite(websitehost, false);
          }
        },
      ),
    );
  }
}
