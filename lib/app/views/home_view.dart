import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'dashboard_view.dart';
import 'orders_view.dart';
import 'stock_view.dart';
import 'customers_view.dart';
import 'profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _idx = 0;
  final _screens = const [DashboardView(), OrdersView(), StockView(), CustomersView(), ProfileView()];

  static const _items = [
    _NavItem(icon: Icons.dashboard_outlined,      activeIcon: Icons.dashboard_rounded,        label: 'Home'),
    _NavItem(icon: Icons.receipt_long_outlined,   activeIcon: Icons.receipt_long_rounded,     label: 'Orders'),
    _NavItem(icon: Icons.inventory_2_outlined,    activeIcon: Icons.inventory_2_rounded,      label: 'Stock'),
    _NavItem(icon: Icons.people_outline_rounded,  activeIcon: Icons.people_rounded,           label: 'Customers'),
    _NavItem(icon: Icons.person_outline_rounded,  activeIcon: Icons.person_rounded,           label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: IndexedStack(index: _idx, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: dark ? C.s800 : Colors.white,
          border: Border(top: BorderSide(color: dark ? C.s700 : C.s200, width: 0.5)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(_items.length, (i) {
                final sel = _idx == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _idx = i),
                    behavior: HitTestBehavior.opaque,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: sel ? 24 : 0, height: sel ? 3 : 0,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: dark ? C.g400 : C.g700,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Icon(_items[i].icon,
                        color: sel ? (dark ? C.g400 : C.g700) : (dark ? C.s500 : C.s400),
                        size: 22),
                      const SizedBox(height: 3),
                      Text(_items[i].label,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                          color: sel ? (dark ? C.g400 : C.g700) : (dark ? C.s500 : C.s400),
                        )),
                    ]),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon, activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}
