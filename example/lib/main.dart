import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adaptive Scaffold Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0B6E4F),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F1EA),
        useMaterial3: true,
      ),
      home: const MailWorkspaceScreen(),
    );
  }
}

class MailWorkspaceScreen extends StatefulWidget {
  const MailWorkspaceScreen({super.key});

  @override
  State<MailWorkspaceScreen> createState() => _MailWorkspaceScreenState();
}

class _MailWorkspaceScreenState extends State<MailWorkspaceScreen> {
  int _selectedTab = 0;

  static const List<NavigationDestination> _destinations =
      <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.space_dashboard_outlined),
          selectedIcon: Icon(Icons.space_dashboard),
          label: 'Overview',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2),
          label: 'Orders',
        ),
        NavigationDestination(
          icon: Icon(Icons.forum_outlined),
          selectedIcon: Icon(Icons.forum),
          label: 'Messages',
        ),
        NavigationDestination(
          icon: Icon(Icons.tune_outlined),
          selectedIcon: Icon(Icons.tune),
          label: 'Settings',
        ),
      ];

  static const List<_WorkspaceTab> _tabs = <_WorkspaceTab>[
    _WorkspaceTab(
      label: 'Overview',
      headline: 'Operations snapshot',
      description:
          'Track shipment volume, customer replies, and fulfillment pace from one adaptive shell.',
      accent: Color(0xFF0B6E4F),
      cards: <_WorkspaceCard>[
        _WorkspaceCard(
          title: 'Revenue',
          value: '\$128.4K',
          subtitle: '+14% vs last week',
        ),
        _WorkspaceCard(
          title: 'Pending orders',
          value: '42',
          subtitle: '8 need packing today',
        ),
        _WorkspaceCard(
          title: 'First response',
          value: '12 min',
          subtitle: 'Down from 19 min',
        ),
      ],
      activity: <String>[
        'Warehouse B finished the priority batch 18 minutes early.',
        'Three VIP accounts are waiting on invoicing approval.',
        'Support queue is clear enough to shift agents to chat.',
      ],
    ),
    _WorkspaceTab(
      label: 'Orders',
      headline: 'Today\'s shipping board',
      description:
          'Review the status of the order pipeline and surface the next action for the team.',
      accent: Color(0xFF8D5A15),
      cards: <_WorkspaceCard>[
        _WorkspaceCard(
          title: 'Ready to pack',
          value: '18',
          subtitle: 'Most due before 14:00',
        ),
        _WorkspaceCard(
          title: 'Awaiting pickup',
          value: '9',
          subtitle: 'Carrier window opens in 25 min',
        ),
        _WorkspaceCard(
          title: 'Returns',
          value: '3',
          subtitle: 'Two need photo review',
        ),
      ],
      activity: <String>[
        'Order 1048 needs an address confirmation before dispatch.',
        'Wholesale carton labels were regenerated after a SKU merge.',
        'Evening pickup is already 70% full.',
      ],
    ),
    _WorkspaceTab(
      label: 'Messages',
      headline: 'Conversations that need attention',
      description:
          'Surface the threads that are closest to SLA breach and keep context visible on wider screens.',
      accent: Color(0xFF6D3FC3),
      cards: <_WorkspaceCard>[
        _WorkspaceCard(
          title: 'Open tickets',
          value: '27',
          subtitle: '6 marked high priority',
        ),
        _WorkspaceCard(
          title: 'Live chat',
          value: '4',
          subtitle: 'One handoff in progress',
        ),
        _WorkspaceCard(
          title: 'CSAT',
          value: '96%',
          subtitle: 'Stable over 30 days',
        ),
      ],
      activity: <String>[
        'A wholesale buyer is asking for split delivery options.',
        'Two refund conversations are waiting on finance approval.',
        'Chat volume is peaking in the German market this hour.',
      ],
    ),
    _WorkspaceTab(
      label: 'Settings',
      headline: 'Workspace configuration',
      description:
          'Keep key operational switches, policy notes, and environment details accessible in one place.',
      accent: Color(0xFF174A7E),
      cards: <_WorkspaceCard>[
        _WorkspaceCard(
          title: 'Automation rules',
          value: '12',
          subtitle: 'Two changed this morning',
        ),
        _WorkspaceCard(
          title: 'Team members',
          value: '18',
          subtitle: '3 with admin access',
        ),
        _WorkspaceCard(
          title: 'Integrations',
          value: '7',
          subtitle: 'All healthy',
        ),
      ],
      activity: <String>[
        'Carrier fallback rules now prioritize local couriers first.',
        'Email templates were updated for delayed shipment notices.',
        'SSO enforcement is scheduled for next Monday.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final _WorkspaceTab activeTab = _tabs[_selectedTab];

    return AdaptiveScaffold(
      appBar: AppBar(
        title: const Text('Adaptive Workspace'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: FilledButton.tonalIcon(
                onPressed: () {},
                icon: const Icon(Icons.add_task),
                label: const Text('New task'),
              ),
            ),
          ),
        ],
      ),
      selectedIndex: _selectedTab,
      onSelectedIndexChange: (int index) {
        setState(() {
          _selectedTab = index;
        });
      },
      destinations: _destinations,
      bodyRatio: 0.62,
      leadingExtendedNavRail: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
        child: _WorkspaceBadge(color: activeTab.accent),
      ),
      leadingUnextendedNavRail: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: CircleAvatar(
          backgroundColor: activeTab.accent,
          foregroundColor: Colors.white,
          child: Text(activeTab.label.substring(0, 1)),
        ),
      ),
      trailingNavRail: Padding(
        padding: const EdgeInsets.all(12),
        child: IconButton.filledTonal(
          onPressed: () {},
          icon: const Icon(Icons.notifications_active_outlined),
        ),
      ),
      body: MaterialSlotBuilders(
        smallBody: (_) => _WorkspaceFeed(tab: activeTab),
        body: (_) => _WorkspaceFeed(tab: activeTab),
        mediumLargeBody: (_) => _WorkspaceFeed(tab: activeTab),
        largeBody: (_) => _WorkspaceFeed(tab: activeTab),
        extraLargeBody: (_) => _WorkspaceFeed(tab: activeTab),
      ),
      secondaryBody: MaterialSlotBuilders(
        body: (_) => _WorkspaceDetails(tab: activeTab),
        mediumLargeBody: (_) => _WorkspaceDetails(tab: activeTab),
        largeBody: (_) => _WorkspaceDetails(tab: activeTab),
        extraLargeBody: (_) => _WorkspaceDetails(tab: activeTab),
      ),
    );
  }
}

class _WorkspaceFeed extends StatelessWidget {
  const _WorkspaceFeed({required this.tab});

  final _WorkspaceTab tab;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFF4F1EA), Color(0xFFE8F0E8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: <Widget>[
          _HeroPanel(tab: tab),
          const SizedBox(height: 20),
          Text(
            'Today',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          for (final _WorkspaceCard card in tab.cards) ...<Widget>[
            _MetricCard(card: card, accent: tab.accent),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 8),
          Text(
            'Recent activity',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          for (int index = 0; index < tab.activity.length; index++) ...<Widget>[
            _ActivityTile(
              index: index + 1,
              text: tab.activity[index],
              accent: tab.accent,
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _WorkspaceDetails extends StatelessWidget {
  const _WorkspaceDetails({required this.tab});

  final _WorkspaceTab tab;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white.withValues(alpha: 0.78),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: <Widget>[
          Text(
            '${tab.label} focus',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'This secondary pane stays visible on larger breakpoints and collapses away on compact layouts.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          _SidePanelCard(
            title: 'Suggested next action',
            accent: tab.accent,
            child: Text(
              tab.activity.first,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 16),
          _SidePanelCard(
            title: 'Owners',
            accent: tab.accent,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Text('AK')),
                  title: Text('Anya K.'),
                  subtitle: Text('Operations'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Text('MR')),
                  title: Text('Milo R.'),
                  subtitle: Text('Support lead'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SidePanelCard(
            title: 'Environment',
            accent: tab.accent,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _InfoRow(label: 'Region', value: 'Europe'),
                _InfoRow(label: 'Timezone', value: 'UTC+1'),
                _InfoRow(label: 'Mode', value: 'Production'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.tab});

  final _WorkspaceTab tab;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: <Color>[
            tab.accent,
            tab.accent.withValues(alpha: 0.68),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tab.headline,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            tab.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: tab.accent,
                ),
                onPressed: () {},
                child: const Text('Review queue'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                ),
                onPressed: () {},
                child: const Text('Export report'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.card, required this.accent});

  final _WorkspaceCard card;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white.withValues(alpha: 0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.insights, color: accent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    card.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.subtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              card.value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.index,
    required this.text,
    required this.accent,
  });

  final int index;
  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: accent.withValues(alpha: 0.15),
            foregroundColor: accent,
            child: Text('$index'),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidePanelCard extends StatelessWidget {
  const _SidePanelCard({
    required this.title,
    required this.accent,
    required this.child,
  });

  final String title;
  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _WorkspaceBadge extends StatelessWidget {
  const _WorkspaceBadge({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: color,
            foregroundColor: Colors.white,
            child: const Icon(Icons.warehouse_outlined),
          ),
          const SizedBox(height: 12),
          Text(
            'Northline',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Operations workspace',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

class _WorkspaceTab {
  const _WorkspaceTab({
    required this.label,
    required this.headline,
    required this.description,
    required this.accent,
    required this.cards,
    required this.activity,
  });

  final String label;
  final String headline;
  final String description;
  final Color accent;
  final List<_WorkspaceCard> cards;
  final List<String> activity;
}

class _WorkspaceCard {
  const _WorkspaceCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final String title;
  final String value;
  final String subtitle;
}
