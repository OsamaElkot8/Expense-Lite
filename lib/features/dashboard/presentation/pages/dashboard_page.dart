import 'package:cached_network_image/cached_network_image.dart';
import 'package:expense_tracker_lite/features/dashboard/repositories/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_utils.dart' as date_utils;
import '../../../../core/common_widgets/loading_widget.dart';
import '../../../../core/common_widgets/empty_state_widget.dart';
import '../../../add_expense/presentation/pages/add_expense_page.dart';
import '../blocs/dashboard_bloc/dashboard_bloc.dart';
import '../blocs/dashboard_bloc/dashboard_event.dart';
import '../blocs/dashboard_bloc/dashboard_state.dart';
import '../widgets/balance_card.dart';
import '../widgets/expense_item.dart';
import '../widgets/filter_dropdown.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final ScrollController _scrollController;
  late final DashboardBloc _dashboardBloc;

  @override
  void initState() {
    _dashboardBloc = DashboardBloc(
      expenseRepository: ExpenseRepository.instance,
    )..add(const DashboardInitialized());
    _scrollController = ScrollController()..addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _dashboardBloc.add(const DashboardLoadMoreExpenses());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _dashboardBloc,
      child: Scaffold(
        backgroundColor: context.colorScheme.surface.withValues(alpha: 0.98),
        body: SafeArea(
          top: false,
          child: BlocConsumer<DashboardBloc, DashboardState>(
            listener: (context, state) {
              if (state is DashboardError) {
                context.showErrorSnackBar(message: state.message);
              }
            },
            builder: (context, state) {
              final controller = context.read<DashboardBloc>();

              if (state is DashboardLoading) {
                return const LoadingWidget();
              }

              if (state is DashboardError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            controller.add(const DashboardInitialized()),
                        child: Text(context.l10n.retry),
                      ),
                    ],
                  ),
                );
              }

              if (state is DashboardLoaded) {
                return RefreshIndicator(
                  onRefresh: () async =>
                      controller.add(const DashboardRefresh()),
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          fit: StackFit.loose,
                          children: [
                            Container(
                              height: 274.0,
                              alignment: Alignment.topCenter,
                              decoration: BoxDecoration(
                                color: context.colorScheme.primary,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(8),
                                ),
                              ),
                              margin: EdgeInsets.only(bottom: 70.0),
                              padding: EdgeInsets.only(
                                top: context.statusBarHeight,
                              ),
                              child: _buildHeader(context, state: state),
                            ),
                            BalanceCard(
                              totalBalance: state.totalBalance,
                              totalIncome: state.totalIncome,
                              totalExpenses: state.totalExpenses,
                              currentFilter: state.currentFilter,
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _buildRecentExpensesHeader(context),
                      ),
                      if (state.expenses.isEmpty)
                        SliverFillRemaining(
                          child: EmptyStateWidget(
                            message: context.l10n.noExpensesFound,
                            icon: Icons.receipt_long,
                          ),
                        )
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index < state.expenses.length) {
                                return ExpenseItem(
                                  expense: state.expenses[index],
                                  onDelete: () => controller.add(
                                    DashboardExpenseDeleted(
                                      state.expenses[index].id,
                                    ),
                                  ),
                                );
                              } else if (state.isLoadingMore) {
                                return _buildLoadingMoreIndicator(context);
                              } else if (!state.hasMore &&
                                  state.expenses.isNotEmpty) {
                                return _buildEndOfListIndicator(context);
                              }
                              return const SizedBox.shrink();
                            },
                            childCount:
                                state.expenses.length +
                                (state.isLoadingMore ? 1 : 0) +
                                (!state.hasMore && state.expenses.isNotEmpty
                                    ? 1
                                    : 0),
                          ),
                        ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.navigatorPush(
            child: AddExpensePage(dashboardBloc: _dashboardBloc),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {required DashboardLoaded state}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: context.colorScheme.surface,
            foregroundImage: CachedNetworkImageProvider(
              "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?_gl=1*17m6bxv*_ga*ODM5Mzc1Nzc4LjE3MjQxMzIwMDU.*_ga_8JE65Q40S6*czE3NjM0MzMyNjQkbzI2JGcxJHQxNzYzNDMzMjkwJGozNCRsMCRoMA..",
            ),
            child: Icon(Icons.person, color: context.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date_utils.DateUtils.getGreeting(),
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colorScheme.surface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppConstants.userName,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.colorScheme.surface,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          const Spacer(),
          FilterDropdown(
            currentFilter: state.currentFilter,
            onFilterChanged: (filter) =>
                _dashboardBloc.add(DashboardFilterChanged(filter)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentExpensesHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.l10n.recentExpenses,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              // Navigate to all expenses page if needed
            },
            child: Text(context.l10n.seeAll),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreIndicator(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.loadingMoreExpenses,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEndOfListIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 1,
            width: 40,
            color: context.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              context.l10n.noMoreExpenses,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          Container(
            height: 1,
            width: 40,
            color: context.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}
