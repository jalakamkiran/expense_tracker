import 'package:expense_tracker_clean/application/blocs/transaction_list/transaction_list_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/transaction_list/transaction_list_event.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/domain/entities/transaction_entity.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/transactions/widgets/filter_bottom_sheet/selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterTransactionBottomSheet extends StatefulWidget {
  final List<Category> categories;
  final List<Label> labels;
  final Function(FilterData) onApply;
  final FilterData? initialFilter;

  const FilterTransactionBottomSheet({
    Key? key,
    required this.categories,
    required this.labels,
    required this.onApply,
    this.initialFilter,
  }) : super(key: key);

  @override
  State<FilterTransactionBottomSheet> createState() =>
      _FilterTransactionBottomSheetState();
}

enum SortType { highest, lowest, newest, oldest }

class FilterData {
  final TransactionType? transactionType;
  final SortType? sortType;
  final List<Category> selectedCategories;
  final List<Label> selectedLabels;

  FilterData({
    this.transactionType,
    this.sortType,
    this.selectedCategories = const [],
    this.selectedLabels = const [],
  });

  FilterData copyWith({
    TransactionType? transactionType,
    SortType? sortType,
    List<Category>? selectedCategories,
    List<Label>? selectedLabels,
  }) {
    return FilterData(
      transactionType: transactionType ?? this.transactionType,
      sortType: sortType ?? this.sortType,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedLabels: selectedLabels ?? this.selectedLabels,
    );
  }
}

class _FilterTransactionBottomSheetState
    extends State<FilterTransactionBottomSheet> {
  late FilterData _currentFilter;

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter ?? FilterData();
  }

  void _updateFilter(FilterData newFilter) {
    setState(() {
      _currentFilter = newFilter;
    });
  }

  void _reset(BuildContext context) {
    setState(() {
      _currentFilter = FilterData();
    });
    context.read<TransactionListBloc>().add(const ResetTransactions());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Transaction',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => _reset(context),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E5FF),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        color: Color(0xFF7C3AED),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter By Section
                  Text(
                    'Filter By',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      _buildTransactionTypeChip(
                          'Income', TransactionType.income),
                      SizedBox(width: 12.w),
                      _buildTransactionTypeChip(
                          'Expense', TransactionType.expense),
                      SizedBox(width: 12.w),
                      _buildTransactionTypeChip(
                          'Transfer', TransactionType.transfer),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Sort By Section
                  Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 8.h,
                    children: [
                      _buildSortTypeChip('Highest', SortType.highest),
                      _buildSortTypeChip('Lowest', SortType.lowest),
                      _buildSortTypeChip('Newest', SortType.newest),
                      _buildSortTypeChip('Oldest', SortType.oldest),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Category Section
                  SelectionWidget<Category>(
                    title: 'Category',
                    items: widget.categories,
                    selectedItems: _currentFilter.selectedCategories,
                    onSelectionChanged: (categories) {
                      _updateFilter(_currentFilter.copyWith(
                          selectedCategories: categories));
                    },
                    itemBuilder: (category, isSelected) =>
                        _buildCategoryItem(category, isSelected),
                  ),

                  SizedBox(height: 24.h),

                  // Label Section
                  SelectionWidget<Label>(
                    title: 'Label',
                    items: widget.labels,
                    selectedItems: _currentFilter.selectedLabels,
                    onSelectionChanged: (labels) {
                      _updateFilter(
                          _currentFilter.copyWith(selectedLabels: labels));
                    },
                    itemBuilder: (label, isSelected) =>
                        _buildLabelItem(label, isSelected),
                  ),

                  SizedBox(height: 100.h), // Space for bottom button
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_currentFilter);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Apply',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTypeChip(String label, TransactionType type) {
    final isSelected = _currentFilter.transactionType == type;
    return GestureDetector(
      onTap: () {
        _updateFilter(_currentFilter.copyWith(
          transactionType: isSelected ? null : type,
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8E5FF) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF7C3AED) : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildSortTypeChip(String label, SortType type) {
    final isSelected = _currentFilter.sortType == type;
    return GestureDetector(
      onTap: () {
        _updateFilter(_currentFilter.copyWith(
          sortType: isSelected ? null : type,
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8E5FF) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF7C3AED) : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Category category, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected
            ? Color(category.color).withOpacity(0.2)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? Color(category.color) : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            IconData(category.iconCode, fontFamily: 'MaterialIcons'),
            color: Color(category.color),
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            category.name,
            style: TextStyle(
              color: isSelected ? Color(category.color) : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelItem(Label label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected
            ? Color(label.color).withOpacity(0.2)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? Color(label.color) : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            IconData(label.iconCode, fontFamily: 'MaterialIcons'),
            color: Color(label.color),
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            label.name,
            style: TextStyle(
              color: isSelected ? Color(label.color) : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
