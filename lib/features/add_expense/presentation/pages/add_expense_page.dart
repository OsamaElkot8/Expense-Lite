import 'package:expense_tracker_lite/core/services/navigation_service.dart';
import 'package:expense_tracker_lite/features/dashboard/presentation/blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:expense_tracker_lite/features/dashboard/repositories/api_clients/currency_api_client.dart';
import 'package:expense_tracker_lite/features/dashboard/repositories/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/common_widgets/custom_button.dart';
import '../../../../core/common_widgets/custom_text_field.dart';
import '../../../../core/utils/date_utils.dart' as date_utils;
import '../../../../core/utils/validators.dart';
import '../blocs/add_expense_bloc/add_expense_bloc.dart';
import '../blocs/add_expense_bloc/add_expense_event.dart';
import '../blocs/add_expense_bloc/add_expense_state.dart';
import '../widgets/category_grid.dart';
import '../widgets/currency_dropdown.dart';

class AddExpensePage extends StatelessWidget {
  final DashboardBloc? dashboardBloc;
  const AddExpensePage({super.key, this.dashboardBloc});

  Future<void> _selectDate(
    BuildContext context, {
    DateTime? currentDate,
    required AddExpenseBloc controller,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != currentDate) {
      if (context.mounted) {
        controller.add(AddExpenseDateChanged(picked));
      }
    }
  }

  Future<void> _pickImage({required AddExpenseBloc controller}) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        controller.add(AddExpenseReceiptChanged(image.path));
      }
    } catch (e) {
      NavigationService.context?.showErrorSnackBar(
        message: NavigationService.context?.l10n.failedToPickImage ?? "Error",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => AddExpenseBloc(
        expenseRepository: ExpenseRepository.instance,
        currencyApiClient: CurrencyApiClient(),
        dashboardBloc: dashboardBloc,
      )..add(const AddExpenseInitialized()),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.addExpense)),
        body: SafeArea(
          child: BlocConsumer<AddExpenseBloc, AddExpenseState>(
            listener: (context, state) {
              if (state is AddExpenseSuccess) {
                context.showSuccessSnackBar(
                  message: context.l10n.expenseAddedSuccessfully,
                );
                if (context.canPop) {
                  context.navigatorPop();
                }
              } else if (state is AddExpenseError) {
                context.showErrorSnackBar(message: state.message);
              } else if (state is AddExpenseLoaded &&
                  state.errorMessage != null) {
                context.showErrorSnackBar(message: state.errorMessage!);
              }
            },
            builder: (context, state) {
              if (state is AddExpenseLoaded) {
                final controller = context.read<AddExpenseBloc>();
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CurrencyDropdown(
                          selectedCurrency: state.currency,
                          onCurrencyChanged: (currency) => controller.add(
                            AddExpenseCurrencyChanged(currency),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          label: context.l10n.amount,
                          hint: '\$50,000',
                          keyboardType: TextInputType.number,
                          validator: Validators.validateAmount,
                          onChanged: (value) =>
                              controller.add(AddExpenseAmountChanged(value)),
                        ),

                        const SizedBox(height: 24),
                        CustomTextField(
                          label: context.l10n.date,
                          hint: date_utils.DateUtils.formatDate(DateTime.now()),
                          controller: TextEditingController(
                            text: state.date != null
                                ? date_utils.DateUtils.formatDate(state.date!)
                                : null,
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(
                            context,
                            currentDate: state.date,
                            controller: controller,
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          label: context.l10n.attachReceipt,
                          hint: context.l10n.uploadImage,
                          controller: TextEditingController(
                            text: state.receiptPath != null
                                ? context.l10n.imageSelected
                                : '',
                          ),
                          readOnly: true,
                          onTap: () => _pickImage(controller: controller),
                          suffixIcon: const Icon(Icons.camera_alt),
                        ),
                        if (state.receiptPath != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: context.colorScheme.outline.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(state.receiptPath!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        CategoryGrid(
                          selectedCategory: state.category,
                          onCategorySelected: (category) => controller.add(
                            AddExpenseCategoryChanged(category),
                          ),
                        ),
                        const SizedBox(height: 32),
                        CustomButton(
                          text: context.l10n.save,
                          onPressed: controller.canSubmit
                              ? () {
                                  if (formKey.currentState!.validate()) {
                                    controller.add(const AddExpenseSubmitted());
                                  }
                                }
                              : null,
                          isLoading: state.isLoading,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
