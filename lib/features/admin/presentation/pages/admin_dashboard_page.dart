import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/admin_dashboard_cubit.dart';
import '../bloc/admin_dashboard_state.dart';

/// Full Admin Dashboard — responsive web layout with sidebar navigation.
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();
  String? _roleFilter;

  final _sections = const [
    _SidebarItem(icon: Icons.people, label: 'Users'),
    _SidebarItem(icon: Icons.description, label: 'RFQs'),
    _SidebarItem(icon: Icons.monetization_on, label: 'Revenue'),
    _SidebarItem(icon: Icons.verified, label: 'Verification'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminDashboardCubit>()..loadUsers(),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;

            if (isWide) {
              // Desktop: sidebar + content
              return Row(
                children: [
                  _buildSidebar(context),
                  const VerticalDivider(width: 1),
                  Expanded(child: _buildContent(context)),
                ],
              );
            } else {
              // Mobile: drawer-based
              return Scaffold(
                appBar: AppBar(
                  title: Text(_sections[_selectedIndex].label),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout_rounded),
                      onPressed: () {
                        context.read<AuthCubit>().signOut();
                        context.go(AppRoutes.login);
                      },
                    ),
                  ],
                ),
                drawer: Drawer(child: _buildSidebarContent(context)),
                body: _buildContent(context),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 240,
      color: AppColors.primaryLight,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: const Text(
              'Admin Panel',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(child: _buildSidebarContent(context)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextButton.icon(
              onPressed: () {
                context.read<AuthCubit>().signOut();
                context.go(AppRoutes.login);
              },
              icon: const Icon(Icons.logout, color: Colors.white70),
              label: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent(BuildContext context) {
    return ListView.builder(
      itemCount: _sections.length,
      itemBuilder: (context, index) {
        final section = _sections[index];
        final isSelected = index == _selectedIndex;

        return ListTile(
          leading: Icon(
            section.icon,
            color: isSelected ? Colors.white : Colors.white60,
          ),
          title: Text(
            section.label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          selectedTileColor: Colors.white12,
          onTap: () {
            setState(() => _selectedIndex = index);
            _loadSection(context, index);
            // Close drawer on mobile
            if (Navigator.of(context).canPop()) {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  void _loadSection(BuildContext context, int index) {
    final cubit = context.read<AdminDashboardCubit>();
    switch (index) {
      case 0:
        cubit.loadUsers(
          search: _searchController.text,
          roleFilter: _roleFilter,
        );
        break;
      case 1:
        cubit.loadRfqs();
        break;
      case 2:
        cubit.loadRevenue();
        break;
      case 3:
        cubit.loadVerificationQueue();
        break;
    }
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AdminError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _loadSection(context, _selectedIndex),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return switch (_selectedIndex) {
          0 => _buildUsersSection(context, state),
          1 => _buildRfqsSection(context, state),
          2 => _buildRevenueSection(context, state),
          3 => _buildVerificationSection(context, state),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }

  // ── Users Section ──

  Widget _buildUsersSection(BuildContext context, AdminDashboardState state) {
    final users = state is AdminUsersLoaded
        ? state.users
        : <Map<String, dynamic>>[];
    final totalCount = state is AdminUsersLoaded ? state.totalCount : 0;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Users ($totalCount)',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),

          // Search + filter row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onSubmitted: (_) {
                    context.read<AdminDashboardCubit>().loadUsers(
                      search: _searchController.text,
                      roleFilter: _roleFilter,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<String?>(
                value: _roleFilter,
                hint: const Text('All Roles'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All Roles')),
                  DropdownMenuItem(value: 'brand', child: Text('Brand')),
                  DropdownMenuItem(value: 'factory', child: Text('Factory')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
                onChanged: (value) {
                  setState(() => _roleFilter = value);
                  context.read<AdminDashboardCubit>().loadUsers(
                    search: _searchController.text,
                    roleFilter: value,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Data table
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Joined')),
                  DataColumn(label: Text('Status')),
                ],
                rows: users.map((user) {
                  final suspended = user['suspended_at'] != null;
                  return DataRow(
                    cells: [
                      DataCell(Text(user['full_name'] ?? 'N/A')),
                      DataCell(Text(user['email'] ?? 'N/A')),
                      DataCell(_roleBadge(user['role'] ?? 'unknown')),
                      DataCell(
                        Text(
                          user['created_at'] != null
                              ? DateFormat.yMMMd().format(
                                  DateTime.parse(user['created_at']),
                                )
                              : 'N/A',
                        ),
                      ),
                      DataCell(
                        suspended
                            ? const Chip(
                                label: Text('Suspended'),
                                backgroundColor: Colors.red,
                              )
                            : const Chip(
                                label: Text('Active'),
                                backgroundColor: Colors.green,
                              ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleBadge(String role) {
    final color = switch (role) {
      'brand' => Colors.blue,
      'factory' => Colors.orange,
      'admin' => Colors.purple,
      _ => Colors.grey,
    };
    return Chip(
      label: Text(
        role.toUpperCase(),
        style: const TextStyle(fontSize: 11, color: Colors.white),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  // ── RFQs Section ──

  Widget _buildRfqsSection(BuildContext context, AdminDashboardState state) {
    final rfqs = state is AdminRfqsLoaded
        ? state.rfqs
        : <Map<String, dynamic>>[];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RFQ Requests',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Brand')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Created')),
                ],
                rows: rfqs.map((rfq) {
                  final brand = rfq['profiles'] as Map<String, dynamic>?;
                  return DataRow(
                    cells: [
                      DataCell(Text(rfq['title'] ?? 'N/A')),
                      DataCell(Text(brand?['full_name'] ?? 'N/A')),
                      DataCell(Text('${rfq['quantity'] ?? 0} units')),
                      DataCell(
                        Text(
                          rfq['created_at'] != null
                              ? DateFormat.yMMMd().format(
                                  DateTime.parse(rfq['created_at']),
                                )
                              : 'N/A',
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Revenue Section ──

  Widget _buildRevenueSection(BuildContext context, AdminDashboardState state) {
    final accepted = state is AdminRevenueLoaded ? state.totalAccepted : 0;
    final revenue = state is AdminRevenueLoaded ? state.totalRevenue : 0.0;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Dashboard',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _RevenueCard(
                title: 'Accepted Quotes',
                value: '$accepted',
                icon: Icons.check_circle,
                color: Colors.green,
              ),
              const SizedBox(width: 16),
              _RevenueCard(
                title: 'Total Revenue',
                value: '\$${revenue.toStringAsFixed(2)}',
                icon: Icons.attach_money,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Verification Section ──

  Widget _buildVerificationSection(
    BuildContext context,
    AdminDashboardState state,
  ) {
    final factories = state is AdminVerificationLoaded
        ? state.unverifiedFactories
        : <Map<String, dynamic>>[];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Factory Verification',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          if (factories.isEmpty)
            const Center(
              child: Column(
                children: [
                  SizedBox(height: 48),
                  Icon(Icons.verified, size: 64, color: Colors.green),
                  SizedBox(height: 16),
                  Text('All factories are verified!'),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: factories.length,
                itemBuilder: (context, index) {
                  final factory = factories[index];
                  final profile = factory['profiles'] as Map<String, dynamic>?;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  factory['name'] ?? 'Unknown Factory',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                if (profile != null) ...[
                                  Text('Owner: ${profile['full_name']}'),
                                  Text('Email: ${profile['email']}'),
                                ],
                                Text(
                                  'Location: ${factory['location'] ?? 'N/A'}',
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  context
                                      .read<AdminDashboardCubit>()
                                      .verifyFactory(
                                        factory['id'],
                                        approved: true,
                                      );
                                },
                                icon: const Icon(Icons.check),
                                label: const Text('Approve'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8),
                              OutlinedButton.icon(
                                onPressed: () {
                                  context
                                      .read<AdminDashboardCubit>()
                                      .verifyFactory(
                                        factory['id'],
                                        approved: false,
                                        reason: 'Rejected by admin',
                                      );
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  'Reject',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _SidebarItem {
  final IconData icon;
  final String label;

  const _SidebarItem({required this.icon, required this.label});
}

class _RevenueCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _RevenueCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 12),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
