import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:math' as math;

@RoutePage()
class CurrentTrainingSessionPage extends StatefulWidget {
  const CurrentTrainingSessionPage({super.key});

  @override
  State<CurrentTrainingSessionPage> createState() =>
      _CurrentTrainingSessionPageState();
}

class BoulderProblem {
  BoulderProblem({
    required this.id,
    required this.name,
    required this.grade,
    required this.location,
    required this.attempts,
    required this.isCompleted,
    required this.time,
    required this.holdTypes,
    required this.techniques,
    required this.notes,
  });
  final String id;
  final String name;
  final String grade;
  final String location;
  final int attempts;
  final bool isCompleted;
  final DateTime time;
  final List<String> holdTypes;
  final List<String> techniques;
  final String notes;

  BoulderProblem copyWith({
    bool? isCompleted,
  }) {
    return BoulderProblem(
      id: id,
      name: name,
      grade: grade,
      location: location,
      attempts: attempts,
      isCompleted: isCompleted ?? this.isCompleted,
      time: time,
      holdTypes: holdTypes,
      techniques: techniques,
      notes: notes,
    );
  }
}

class _CurrentTrainingSessionPageState extends State<CurrentTrainingSessionPage>
    with SingleTickerProviderStateMixin {
  final DateTime _startTime =
      DateTime.now().subtract(const Duration(minutes: 45));
  int _problemsAttempted = 5;
  int _problemsCompleted = 3;
  List<BoulderProblem> _problems = [];
  late TabController _tabController;
  bool _isShowingStats = false;
  final ScrollController _scrollController = ScrollController();

  // Timer do symulacji czasu rzeczywistego
  late Timer _timer;

  // Zaawansowane statystyki sesji
  final int _totalAttempts = 14;
  final Map<String, int> _gradeDistribution = {
    'V3': 1,
    'V4': 2,
    'V5': 1,
    'V6': 1,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Przykładowe dane - w rzeczywistej aplikacji powinny pochodzić z bloku
    _problems = [
      BoulderProblem(
        id: '1',
        name: 'Roof Crusher',
        grade: 'V4',
        location: 'Cave Section',
        attempts: 3,
        isCompleted: true,
        time: DateTime.now().subtract(const Duration(minutes: 30)),
        holdTypes: ['Crimps', 'Slopers'],
        techniques: ['Dynamic Move', 'Body Tension'],
        notes: 'Need to focus more on body position before the dynamic move.',
      ),
      BoulderProblem(
        id: '2',
        name: 'Crimpy Traverse',
        grade: 'V5',
        location: 'Main Wall',
        attempts: 5,
        isCompleted: true,
        time: DateTime.now().subtract(const Duration(minutes: 20)),
        holdTypes: ['Crimps', 'Pinches'],
        techniques: ['Balance', 'Flagging'],
        notes: 'Right hand crimp is the crux. Try heel hook on third move.',
      ),
      BoulderProblem(
        id: '3',
        name: 'Dynamic Start',
        grade: 'V3',
        location: 'Slab Area',
        attempts: 2,
        isCompleted: true,
        time: DateTime.now().subtract(const Duration(minutes: 10)),
        holdTypes: ['Jugs', 'Volumes'],
        techniques: ['Dyno', 'Coordination'],
        notes: 'Easy start if you get the coordination right.',
      ),
      BoulderProblem(
        id: '4',
        name: 'Balance Test',
        grade: 'V6',
        location: 'Competition Wall',
        attempts: 4,
        isCompleted: false,
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        holdTypes: ['Slopers', 'Volumes'],
        techniques: ['Balance', 'Compression'],
        notes: 'Very difficult to maintain tension through the middle section.',
      ),
      BoulderProblem(
        id: '5',
        name: 'Power Moves',
        grade: 'V4',
        location: 'Overhang Section',
        attempts: 2,
        isCompleted: false,
        time: DateTime.now().subtract(const Duration(minutes: 2)),
        holdTypes: ['Jugs', 'Pockets'],
        techniques: ['Power', 'Lock-off'],
        notes: 'Need more core tension for the roof section.',
      ),
    ];

    // Timer do aktualizacji czasu sesji co sekundę
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // To tylko do aktualizacji wyświetlanego czasu
      });
    });

    // Dodaj efekt przewijania dla karty statystyk
    _scrollController.addListener(() {
      if (_scrollController.offset > 180 && !_isShowingStats) {
        setState(() {
          _isShowingStats = true;
        });
      } else if (_scrollController.offset <= 180 && _isShowingStats) {
        setState(() {
          _isShowingStats = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDuration(DateTime startTime) {
    final duration = DateTime.now().difference(startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: AppColors.background,
              pinned: true,
              expandedHeight: 180,
              title: _isShowingStats
                  ? Row(
                      children: [
                        Text(
                          'Active Session',
                          style: context.textTheme.titleLarge?.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.timer,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDuration(_startTime),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Active Session',
                      style: context.textTheme.titleLarge?.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => _showEndSessionDialog(context),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: _buildSessionStatsCard(),
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: const [
                  Tab(text: 'PROBLEMS'),
                  Tab(text: 'ANALYSIS'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Problems Tab
            _buildProblemsTab(),

            // Analysis Tab
            _buildAnalysisTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProblemModal(context),
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  Widget _buildSessionStatsCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.8),
            AppColors.primary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  LucideIcons.timer,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _formatDuration(_startTime),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItemNew(
                'ATTEMPTED',
                _problemsAttempted.toString(),
                LucideIcons.target,
              ),
              _buildVerticalDivider(),
              _buildStatItemNew(
                'COMPLETED',
                _problemsCompleted.toString(),
                LucideIcons.checkCheck,
              ),
              _buildVerticalDivider(),
              _buildStatItemNew(
                'SUCCESS RATE',
                '${(_problemsCompleted / _problemsAttempted * 100).toStringAsFixed(0)}%',
                LucideIcons.percent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white30,
    );
  }

  Widget _buildStatItemNew(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.white70,
            ),
            const SizedBox(width: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildProblemsTab() {
    return _problems.isEmpty
        ? _buildEmptyState()
        : ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              _buildProblemsSectionHeader('In Progress', LucideIcons.loader),
              ..._problems
                  .where((p) => !p.isCompleted)
                  .map(_buildProblemCardNew),

              const SizedBox(height: 24),

              _buildProblemsSectionHeader('Completed', LucideIcons.checkCheck),
              ..._problems
                  .where((p) => p.isCompleted)
                  .map(_buildProblemCardNew),

              // Extra padding at bottom for FAB
              const SizedBox(height: 80),
            ],
          );
  }

  Widget _buildProblemsSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.mountain,
              size: 64,
              color: AppColors.primary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No problems tracked yet',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const SizedBox(
            width: 260,
            child: Text(
              'Add your first boulder problem to start tracking your session',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showAddProblemModal(context),
            icon: const Icon(LucideIcons.plus),
            label: const Text('Add First Problem'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemCardNew(BoulderProblem problem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showProblemDetailsModal(context, problem),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grade indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getGradeColor(problem.grade),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      problem.grade,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Problem name and location
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          problem.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.mapPin,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              problem.location,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Completion status
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: problem.isCompleted
                          ? Colors.green.withOpacity(0.1)
                          : AppColors.background.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      problem.isCompleted
                          ? LucideIcons.checkCheck
                          : LucideIcons.circleOff,
                      color: problem.isCompleted
                          ? Colors.green
                          : AppColors.textSecondary,
                      size: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Tags for techniques and holds
              Row(
                children: [
                  ...problem.holdTypes
                      .take(2)
                      .map((hold) => _buildTag(hold, LucideIcons.grip)),
                  const SizedBox(width: 6),
                  ...problem.techniques
                      .take(2)
                      .map((tech) => _buildTag(tech, LucideIcons.move)),
                  if (problem.holdTypes.length + problem.techniques.length >
                      4) ...[
                    const SizedBox(width: 6),
                    _buildTag(
                      '+${problem.holdTypes.length + problem.techniques.length - 4}',
                      LucideIcons.undoDot,
                    ),
                  ],
                ],
              ),
              const Divider(height: 24),
              // Footer with stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.redo2,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${problem.attempts} ${problem.attempts == 1 ? 'attempt' : 'attempts'}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.clock,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTimeAgo(problem.time),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d').format(time);
    }
  }

  Widget _buildAnalysisTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAnalysisCard(
          title: 'Grade Distribution',
          child: Column(
            children: [
              const SizedBox(height: 8),
              SizedBox(
                height: 180,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _gradeDistribution.entries.map((entry) {
                    final barHeight = 120 * (entry.value / _problemsAttempted);
                    return _buildGradeBar(entry.key, entry.value, barHeight);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildAnalysisCard(
          title: 'Session Metrics',
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildMetricRow(
                'Total Climbing Time',
                '00:35:12',
                LucideIcons.timer,
              ),
              _buildMetricRow(
                'Average Attempts per Problem',
                (_totalAttempts / _problemsAttempted).toStringAsFixed(1),
                LucideIcons.redo2,
              ),
              _buildMetricRow(
                'Rest Time between Problems',
                '~7 minutes',
                LucideIcons.coffee,
              ),
              _buildMetricRow(
                'Highest Grade Attempted',
                'V6',
                LucideIcons.arrowUp,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildAnalysisCard(
          title: 'Technique Overview',
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTechniqueCircle('Dynamic\nMoves', 0.8, Colors.orange),
                  _buildTechniqueCircle('Balance', 0.5, Colors.green),
                  _buildTechniqueCircle('Power', 0.7, Colors.red),
                  _buildTechniqueCircle('Flexibility', 0.3, Colors.blue),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildAnalysisCard(
          title: 'Top Hold Types Used',
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildHoldTypeItem('Crimps', '42%', LucideIcons.gripVertical),
                  _buildHoldTypeItem('Slopers', '28%', LucideIcons.hand),
                  _buildHoldTypeItem(
                    'Jugs',
                    '15%',
                    LucideIcons.arrowBigDown,
                  ),
                  _buildHoldTypeItem('Pockets', '15%', LucideIcons.circleOff),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const SizedBox(height: 80), // Extra padding for FAB
      ],
    );
  }

  Widget _buildAnalysisCard({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildGradeBar(String grade, int count, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuart,
          width: 40,
          height: height,
          decoration: BoxDecoration(
            color: _getGradeColor(grade),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: _getGradeColor(grade).withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getGradeColor(grade).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            grade,
            style: TextStyle(
              color: _getGradeColor(grade),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechniqueCircle(String label, double progress, Color color) {
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: progress,
                  backgroundColor: color.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation(color),
                  strokeWidth: 6,
                ),
              ),
              Center(
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildHoldTypeItem(String type, String percentage, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          type,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getGradeColor(String grade) {
    // V-scale difficulty colors
    if (grade.startsWith('V1') ||
        grade.startsWith('V2') ||
        grade.startsWith('V3')) {
      return Colors.green;
    } else if (grade.startsWith('V4') || grade.startsWith('V5')) {
      return Colors.blue;
    } else if (grade.startsWith('V6') || grade.startsWith('V7')) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  void _showAddProblemModal(BuildContext context) {
    final grades = [
      'V0',
      'V1',
      'V2',
      'V3',
      'V4',
      'V5',
      'V6',
      'V7',
      'V8',
      'V9',
      'V10+',
    ];
    final locations = [
      'Main Wall',
      'Cave Section',
      'Slab Area',
      'Competition Wall',
      'Overhang Section',
    ];
    final holdTypes = [
      'Crimps',
      'Jugs',
      'Slopers',
      'Pinches',
      'Pockets',
      'Volumes',
    ];
    final techniques = [
      'Balance',
      'Power',
      'Dynamic Move',
      'Coordination',
      'Flagging',
      'Body Tension',
      'Heel Hook',
      'Toe Hook',
    ];

    var selectedGrade = 'V4';
    var selectedLocation = 'Main Wall';
    final selectedHoldTypes = <String>[];
    final selectedTechniques = <String>[];
    var problemName = '';
    var attempts = 1;
    const notes = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: AppColors.tileColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.plus,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Add Boulder Problem',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(LucideIcons.x),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  // Form Fields
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Problem Name
                        const Text(
                          'Problem Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: (value) {
                            setModalState(() {
                              problemName = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter problem name',
                            fillColor: AppColors.background,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Grade Selection
                        const Text(
                          'Grade',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: grades.length,
                            itemBuilder: (context, index) {
                              final grade = grades[index];
                              return GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    selectedGrade = grade;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedGrade == grade
                                        ? _getGradeColor(grade)
                                        : AppColors.background,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      grade,
                                      style: TextStyle(
                                        color: selectedGrade == grade
                                            ? Colors.white
                                            : AppColors.textSecondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Location Selection
                        const Text(
                          'Location',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedLocation,
                              isExpanded: true,
                              icon: const Icon(LucideIcons.chevronDown),
                              items: locations.map((location) {
                                return DropdownMenuItem<String>(
                                  value: location,
                                  child: Text(location),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setModalState(() {
                                  selectedLocation = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Attempts
                        const Text(
                          'Attempts',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setModalState(() {
                                  if (attempts > 1) attempts--;
                                });
                              },
                              icon: const Icon(LucideIcons.minus),
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.background,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  attempts.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setModalState(() {
                                  attempts++;
                                });
                              },
                              icon: const Icon(LucideIcons.plus),
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.background,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Hold Types
                        const Text(
                          'Hold Types',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: holdTypes.map((type) {
                            final isSelected = selectedHoldTypes.contains(type);
                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  if (isSelected) {
                                    selectedHoldTypes.remove(type);
                                  } else {
                                    selectedHoldTypes.add(type);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withOpacity(0.2)
                                      : AppColors.background,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 16),

                        // Techniques
                        const Text(
                          'Techniques',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: techniques.map((technique) {
                            final isSelected =
                                selectedTechniques.contains(technique);
                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  if (isSelected) {
                                    selectedTechniques.remove(technique);
                                  } else {
                                    selectedTechniques.add(technique);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withOpacity(0.2)
                                      : AppColors.background,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Text(
                                  technique,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 16),

                        // Notes
                        const Text(
                          'Notes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: (value) {
                            // zapisywanie notatek
                          },
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Add notes about this problem (optional)',
                            fillColor: AppColors.background,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Completed status
                        Row(
                          children: [
                            const Text(
                              'Mark as completed',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight,
                              ),
                            ),
                            const Spacer(),
                            Switch(
                              value:
                                  false, // Można dodać zmienną dla tego stanu
                              onChanged: (value) {
                                // setModalState(() {
                                //   isCompleted = value;
                                // });
                              },
                              activeColor: Colors.green,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  side: const BorderSide(
                                    color: AppColors.textSecondary,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _problemsAttempted++;
                                    _problems.insert(
                                      0,
                                      BoulderProblem(
                                        id: DateTime.now().toString(),
                                        name: problemName.isNotEmpty
                                            ? problemName
                                            : 'New Problem',
                                        grade: selectedGrade,
                                        location: selectedLocation,
                                        attempts: attempts,
                                        isCompleted:
                                            false, // lub użyj zmiennej stanu
                                        time: DateTime.now(),
                                        holdTypes: selectedHoldTypes.toList(),
                                        techniques: selectedTechniques.toList(),
                                        notes: notes,
                                      ),
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Add Problem'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showProblemDetailsModal(BuildContext context, BoulderProblem problem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.secondary,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getGradeColor(problem.grade),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      problem.grade,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      problem.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Details
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Location
                  _buildDetailRow(
                    LucideIcons.mapPin,
                    'Location',
                    problem.location,
                  ),

                  // Attempts
                  _buildDetailRow(
                    LucideIcons.redo2,
                    'Attempts',
                    '${problem.attempts}',
                  ),

                  // Time added
                  _buildDetailRow(
                    LucideIcons.clock,
                    'Added',
                    DateFormat('MMM d, yyyy h:mm a').format(problem.time),
                  ),

                  // Status
                  _buildDetailRow(
                    problem.isCompleted
                        ? LucideIcons.checkCheck
                        : LucideIcons.x,
                    'Status',
                    problem.isCompleted ? 'Completed' : 'In progress',
                    valueColor:
                        problem.isCompleted ? Colors.green : Colors.orange,
                  ),

                  const Divider(height: 32),

                  // Hold Types
                  const Text(
                    'Hold Types',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: problem.holdTypes
                        .map(
                          (hold) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              hold,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  // Techniques
                  const Text(
                    'Techniques',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: problem.techniques
                        .map(
                          (technique) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              technique,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  if (problem.notes.isNotEmpty) ...[
                    const SizedBox(height: 16),

                    // Notes
                    const Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        problem.notes,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Action buttons
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.secondary,
                  ),
                ),
              ),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        final index = _problems.indexOf(problem);
                        final newIsCompleted = !problem.isCompleted;
                        _problems[index] = problem.copyWith(
                          isCompleted: newIsCompleted,
                        );

                        if (newIsCompleted) {
                          _problemsCompleted++;
                        } else {
                          _problemsCompleted--;
                        }
                      });
                    },
                    icon: Icon(
                      problem.isCompleted
                          ? LucideIcons.x
                          : LucideIcons.checkCheck,
                    ),
                    label: Text(
                      problem.isCompleted
                          ? 'Mark as Not Completed'
                          : 'Mark as Completed',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          problem.isCompleted ? Colors.orange : Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Implementacja edycji problemu
                            Navigator.pop(context);
                          },
                          icon: const Icon(LucideIcons.pencil),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              if (problem.isCompleted) {
                                _problemsCompleted--;
                              }
                              _problemsAttempted--;
                              _problems.remove(problem);
                            });
                          },
                          icon: const Icon(LucideIcons.trash2),
                          label: const Text('Delete'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? AppColors.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEndSessionDialog(BuildContext context) {
    // Implementacja dialogu kończącego sesję
  }
}
