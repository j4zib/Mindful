import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/extensions/ext_num.dart';
import 'package:mindful/core/extensions/ext_widget.dart';
import 'package:mindful/providers/bedtime_provider.dart';
import 'package:mindful/ui/common/flexible_appbar.dart';
import 'package:mindful/ui/common/persistent_header.dart';
import 'package:mindful/ui/common/switchable_list_tile.dart';
import 'package:mindful/ui/common/stateful_text.dart';
import 'package:mindful/ui/screens/home/bedtime/bedtime_card.dart';
import 'package:mindful/ui/screens/home/bedtime/bedtime_actions.dart';

class TabBedtime extends StatelessWidget {
  const TabBedtime({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 8),
      child: CustomScrollView(
        slivers: [
          /// Appbar
          const FlexibleAppBar(title: "Bedtime"),

          /// Information about bedtime
          const StatefulText(
            "Silence your phone, change screen to black and white at bedtime. Only alarms and important calls can reach you.",
            activeColor: Colors.grey,
          ).toSliverBox(),

          12.vSliverBox(),

          /// Card with start and end time for schedule
          /// also schedule days
          const BedtimeCard(),

          8.vSliverBox(),

          /// Bedtimem schedule status toggler
          Consumer(
            builder: (_, WidgetRef ref, __) {
              return SwitchableListTile(
                isPrimary: true,
                leadingIcon: FluentIcons.sleep_20_regular,
                titleText: "Status",
                subTitleText: "Enable or disable daily schedule task",
                value: ref.watch(
                  bedtimeProvider.select((v) => v.scheduleStatus),
                ),
                onPressed: () => ref
                    .read(bedtimeProvider.notifier)
                    .toggleBedtimeScheduleStatus(),
              );
            },
          ).toSliverBox(),

          /// Bedtime actions
          SliverPersistentHeader(
            pinned: true,
            delegate: PersistentHeader(
              minHeight: 32,
              maxHeight: 42,
              alignment: const Alignment(-1, 0.75),
              child: const Text("Actions"),
            ),
          ),

          /// Actions related to bedtime
          const BedtimeActions(),

          /// Distracting apps
          SliverPersistentHeader(
            pinned: true,
            delegate: PersistentHeader(
              minHeight: 32,
              maxHeight: 42,
              alignment: const Alignment(-1, 0.75),
              child: const Text("Distracting apps"),
            ),
          ),
        ],
      ),
    );
  }
}
