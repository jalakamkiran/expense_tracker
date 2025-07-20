import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectionWidget<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final List<T> selectedItems;
  final Function(List<T>) onSelectionChanged;
  final Widget Function(T item, bool isSelected) itemBuilder;

  const SelectionWidget({
    Key? key,
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  State<SelectionWidget<T>> createState() => _SelectionWidgetState<T>();
}

class _SelectionWidgetState<T> extends State<SelectionWidget<T>> {
  String _searchQuery = '';
  bool _isExpanded = false;

  List<T> get _filteredItems {
    if (_searchQuery.isEmpty) return widget.items;

    return widget.items.where((item) {
      String name = '';
      if (item is Category) {
        name = (item as Category).name.toLowerCase();
      } else if (item is Label) {
        name = (item as Label).name.toLowerCase();
      }
      return name.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _toggleSelection(T item) {
    final newSelection = List<T>.from(widget.selectedItems);
    if (newSelection.contains(item)) {
      newSelection.remove(item);
    } else {
      newSelection.add(item);
    }
    widget.onSelectionChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowSearch = widget.items.length > 8;
    final itemsToShow = _isExpanded ? _filteredItems : _filteredItems.take(6).toList();
    final hasMoreItems = _filteredItems.length > 6 && !_isExpanded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and selection count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Choose ${widget.title}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '${widget.selectedItems.length} Selected',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        if (shouldShowSearch) ...[
          SizedBox(height: 12.h),
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search ${widget.title.toLowerCase()}...',
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20.sp),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
              ),
            ),
          ),
        ],

        SizedBox(height: 12.h),

        // Items grid
        if (itemsToShow.isNotEmpty)
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: itemsToShow.map((item) {
              final isSelected = widget.selectedItems.contains(item);
              return GestureDetector(
                onTap: () => _toggleSelection(item),
                child: widget.itemBuilder(item, isSelected),
              );
            }).toList(),
          )
        else
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Icon(Icons.search_off, color: Colors.grey.shade400, size: 32.sp),
                SizedBox(height: 8.h),
                Text(
                  'No ${widget.title.toLowerCase()} found',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),

        // Show more/less button
        if (widget.items.length > 6) ...[
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isExpanded
                        ? 'Show Less'
                        : 'Show ${_filteredItems.length - 6} More',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey.shade700,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}