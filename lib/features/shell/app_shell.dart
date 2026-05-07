import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Ana uygulama kabuğu — alt navigasyon barı + içerik alanı.
///
/// 4 sekme: Bugün, Dosyalar, Senkron, Ayarlar.
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  static const _tabs = <_TabDef>[
    _TabDef('/', Icons.today_outlined, Icons.today, 'Bugün'),
    _TabDef('/cases', Icons.folder_outlined, Icons.folder, 'Dosyalar'),
    _TabDef('/sync', Icons.sync_outlined, Icons.sync, 'Senkron'),
    _TabDef('/settings', Icons.settings_outlined, Icons.settings, 'Ayarlar'),
  ];

  int _indexFromLocation(String location) {
    for (var i = 0; i < _tabs.length; i++) {
      if (location == _tabs[i].path ||
          (_tabs[i].path != '/' && location.startsWith(_tabs[i].path))) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _indexFromLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        destinations: [
          for (final t in _tabs)
            NavigationDestination(
              icon: Icon(t.icon),
              selectedIcon: Icon(t.iconActive),
              label: t.label,
            ),
        ],
      ),
    );
  }
}

class _TabDef {
  const _TabDef(this.path, this.icon, this.iconActive, this.label);
  final String path;
  final IconData icon;
  final IconData iconActive;
  final String label;
}
