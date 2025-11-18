import 'package:expense_tracker_lite/core/services/navigation_service.dart';
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

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    context.read<AddExpenseBloc>().add(const AddExpenseInitialized());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = date_utils.DateUtils.formatDate(picked);
      });

      NavigationService.context?.read<AddExpenseBloc>().add(
        AddExpenseDateChanged(picked),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        NavigationService.context?.read<AddExpenseBloc>().add(
          AddExpenseReceiptChanged(image.path),
        );
      }
    } catch (e) {
      NavigationService.context?.showErrorSnackBar(
        message: 'Failed to pick image',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.navigatorPop(),
        ),
        title: Text(context.l10n.addExpense),
      ),
      body: SafeArea(
        child: BlocConsumer<AddExpenseBloc, AddExpenseState>(
          listener: (context, state) {
            if (state is AddExpenseSuccess) {
              context.showSuccessSnackBar(
                message: 'Expense added successfully',
              );
              context.navigatorPop(true);
            } else if (state is AddExpenseError) {
              context.showErrorSnackBar(message: state.message);
            } else if (state is AddExpenseLoaded &&
                state.errorMessage != null) {
              context.showErrorSnackBar(message: state.errorMessage!);
            }
          },
          builder: (context, state) {
            if (state is AddExpenseLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CurrencyDropdown(
                        selectedCurrency: state.currency,
                        onCurrencyChanged: (currency) {
                          context.read<AddExpenseBloc>().add(
                            AddExpenseCurrencyChanged(currency),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        label: context.l10n.amount,
                        hint: '\$50,000',
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        validator: Validators.validateAmount,
                        onChanged: (value) {
                          context.read<AddExpenseBloc>().add(
                            AddExpenseAmountChanged(value),
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                      CustomTextField(
                        label: context.l10n.date,
                        hint: date_utils.DateUtils.formatDate(DateTime.now()),
                        controller: _dateController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      const SizedBox(height: 24),

                      CustomTextField(
                        label: context.l10n.attachReceipt,
                        hint: context.l10n.uploadImage,
                        controller: TextEditingController(
                          text: state.receiptPath != null
                              ? 'Image selected'
                              : '',
                        ),
                        readOnly: true,
                        onTap: _pickImage,
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
                        onCategorySelected: (category) {
                          context.read<AddExpenseBloc>().add(
                            AddExpenseCategoryChanged(category),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: context.l10n.save,
                        onPressed: state.isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AddExpenseBloc>().add(
                                    const AddExpenseSubmitted(),
                                  );
                                }
                              },
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
    );
  }
}
