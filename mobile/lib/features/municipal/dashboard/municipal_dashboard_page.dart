import 'package:flutter/material.dart';
import 'models/municipal_dashboard_models.dart';
import 'services/municipal_dashboard_service.dart';
import '../theme/municipal_colors.dart';
import 'widgets/summary_card.dart';
import 'widgets/schedule_card.dart';
import 'widgets/complaints_card.dart';
import 'widgets/operations_overview.dart';
import 'widgets/hotspot_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/announcement_card.dart';

class MunicipalDashboardPage extends StatefulWidget {
  final Function(int) onTabChange;

  const MunicipalDashboardPage({
    super.key,
    required this.onTabChange,
  });

  @override
  State<MunicipalDashboardPage> createState() => _MunicipalDashboardPageState();
}

class _MunicipalDashboardPageState extends State<MunicipalDashboardPage> {
  final MunicipalDashboardService _dashboardService = MunicipalDashboardService();
  MunicipalDashboardSummary? _summaryData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _dashboardService.getDashboardSummary();
      setState(() {
        _summaryData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load dashboard data. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MunicipalColors.pageBg,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: MunicipalColors.secondaryGreen,
                ),
              )
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: MunicipalColors.error,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: MunicipalColors.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadDashboardData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MunicipalColors.secondaryGreen,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadDashboardData,
                    color: MunicipalColors.secondaryGreen,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildHeader(),
                              const SizedBox(height: 24),
                              _buildWelcomeTitle(),
                              const SizedBox(height: 24),
                              _buildSummaryGrid(),
                              const SizedBox(height: 20),
                              
                              // Schedule and Recent Complaints layout (Stacked for mobile)
                              ScheduleCard(
                                schedules: _summaryData!.todaySchedules,
                                onViewAll: () => widget.onTabChange(2), // Navigate to Schedule tab
                                onViewFullSchedule: () => widget.onTabChange(2),
                              ),
                              const SizedBox(height: 20),
                              
                              ComplaintsCard(
                                complaints: _summaryData!.recentComplaints,
                                onViewAll: () => widget.onTabChange(3), // Navigate to Reports/Complaints tab
                                onViewAllComplaints: () => widget.onTabChange(3),
                              ),
                              const SizedBox(height: 20),
                              
                              OperationsOverviewWidget(
                                overview: _summaryData!.operationsOverview,
                              ),
                              const SizedBox(height: 20),
                              
                              HotspotCard(
                                hotspots: _summaryData!.hotspots,
                                onViewMap: () {
                                  // Navigate to map (placeholder action / snackbar)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Map viewer coming soon in Sprint 2!")),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              
                              QuickActionsWidget(
                                onManageSchedules: () => widget.onTabChange(2),
                                onAssignCollectors: () => widget.onTabChange(1),
                                onViewReports: () => widget.onTabChange(3),
                                onSendAlerts: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Alert broadcast interface coming soon!")),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              
                              AnnouncementCard(
                                announcements: _summaryData!.announcements,
                                onViewAll: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("All Announcements page coming soon!")),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              'EcoMate',
              style: TextStyle(
                color: MunicipalColors.secondaryGreen,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: MunicipalColors.accentGreenLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 12,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Notification Icon with Badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: MunicipalColors.primaryText,
                  size: 28,
                ),
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: MunicipalColors.noticeGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Profile image
            CircleAvatar(
              radius: 20,
              backgroundColor: MunicipalColors.surface,
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&fit=crop&q=60',
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.person_rounded,
                    color: MunicipalColors.secondaryText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Municipal Operations",
          style: TextStyle(
            color: MunicipalColors.primaryText,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Municipal Council Dashboard",
          style: TextStyle(
            color: MunicipalColors.secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.15,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        SummaryCard(
          title: "Total Collections Today",
          value: "${_summaryData!.totalCollectionsToday}",
          subtitle: "+14% vs yesterday",
          icon: Icons.local_shipping_rounded,
          iconColor: MunicipalColors.secondaryGreen,
          iconBgColor: MunicipalColors.success.withValues(alpha: 0.1),
          comparisonWidget: const Row(
            children: [
              Text(
                "+14% ",
                style: TextStyle(
                  color: MunicipalColors.success,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "vs yesterday",
                style: TextStyle(
                  color: MunicipalColors.secondaryText,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.trending_up_rounded,
                color: MunicipalColors.success,
                size: 14,
              ),
            ],
          ),
        ),
        SummaryCard(
          title: "Active Trucks / Collectors",
          value: "${_summaryData!.activeCollectors} / ${_summaryData!.totalCollectors}",
          subtitle: "On duty now",
          icon: Icons.group_rounded,
          iconColor: MunicipalColors.secondaryGreen,
          iconBgColor: MunicipalColors.success.withValues(alpha: 0.1),
          comparisonWidget: const Row(
            children: [
              Icon(
                Icons.fiber_manual_record,
                color: MunicipalColors.success,
                size: 8,
              ),
              SizedBox(width: 6),
              Text(
                "On duty now",
                style: TextStyle(
                  color: MunicipalColors.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SummaryCard(
          title: "Pending Complaints",
          value: "${_summaryData!.pendingComplaints}",
          subtitle: "5 High Priority",
          icon: Icons.error_rounded,
          iconColor: MunicipalColors.error,
          iconBgColor: MunicipalColors.error.withValues(alpha: 0.1),
          comparisonWidget: Text(
            "${_summaryData!.highPriorityComplaints} High Priority",
            style: const TextStyle(
              color: MunicipalColors.error,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SummaryCard(
          title: "Recycling Rate",
          value: "${_summaryData!.recyclingRate}%",
          subtitle: "+6% vs last month",
          icon: Icons.recycling_rounded,
          iconColor: MunicipalColors.secondaryGreen,
          iconBgColor: MunicipalColors.success.withValues(alpha: 0.1),
          comparisonWidget: const Row(
            children: [
              Text(
                "+6% ",
                style: TextStyle(
                  color: MunicipalColors.success,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "vs last month",
                style: TextStyle(
                  color: MunicipalColors.secondaryText,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.trending_up_rounded,
                color: MunicipalColors.success,
                size: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
