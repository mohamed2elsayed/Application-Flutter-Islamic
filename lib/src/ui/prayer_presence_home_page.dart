import 'package:flutter/material.dart';

import '../models/prayer_session.dart';
import '../models/prayer_type.dart';
import '../state/prayer_presence_controller.dart';

class PrayerPresenceHomePage extends StatefulWidget {
  const PrayerPresenceHomePage({
    super.key,
    required this.controller,
  });

  final PrayerPresenceController controller;

  @override
  State<PrayerPresenceHomePage> createState() => _PrayerPresenceHomePageState();
}

class _PrayerPresenceHomePageState extends State<PrayerPresenceHomePage> {
  PrayerType _selectedPrayer = PrayerType.asr;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    final String? message = widget.controller.lastNotification;
    if (message == null || !mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
    widget.controller.clearNotification();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (BuildContext context, _) {
        final PrayerSession? mySession = widget.controller.myActiveSession;
        final bool isPrayingNow = mySession != null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Prayer Presence'),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.circle,
                    color: isPrayingNow ? Colors.green : Colors.grey,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Text(isPrayingNow ? 'Online (Praying)' : 'Offline'),
                  const SizedBox(width: 16),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              const Text(
                'My Prayer Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (!isPrayingNow) ...<Widget>[
                DropdownButtonFormField<PrayerType>(
                  value: _selectedPrayer,
                  decoration: const InputDecoration(
                    labelText: 'Prayer type',
                    border: OutlineInputBorder(),
                  ),
                  items: PrayerType.values
                      .map(
                        (PrayerType type) => DropdownMenuItem<PrayerType>(
                          value: type,
                          child: Text(type.label),
                        ),
                      )
                      .toList(),
                  onChanged: (PrayerType? value) {
                    if (value != null) {
                      setState(() {
                        _selectedPrayer = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {
                    widget.controller.startPrayer(
                      prayerType: _selectedPrayer,
                      locationLabel: 'Approximate: City Center',
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('I am praying now'),
                ),
              ] else ...<Widget>[
                Card(
                  child: ListTile(
                    title: Text('Now praying: ${mySession.prayerType.label}'),
                    subtitle: Text('Location: ${mySession.locationLabel}'),
                    trailing: FilledButton.tonalIcon(
                      onPressed: widget.controller.finishPrayer,
                      icon: const Icon(Icons.stop),
                      label: const Text('Finish'),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              const Text(
                'Nearby prayer activity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...widget.controller.visibleNearbySessions
                  .map((PrayerSession session) => _SessionTile(session: session)),
            ],
          ),
        );
      },
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});

  final PrayerSession session;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          session.isCurrentUser ? Icons.person : Icons.people_alt_outlined,
        ),
        title: Text(
          session.isCurrentUser
              ? 'You - ${session.prayerType.label}'
              : '${session.userName} - ${session.prayerType.label}',
        ),
        subtitle: Text('${session.locationLabel} • Active now'),
      ),
    );
  }
}
