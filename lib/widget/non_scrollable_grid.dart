import 'package:flutter/material.dart';

/// Modified from https://github.com/edsulaiman/google_ui/blob/fd053fb1457b0c9bcd1066cc348bbd857f849ec5/lib/src/widgets/g_grid/g_grid.dart
class NonScrollableGrid extends StatelessWidget {
  const NonScrollableGrid({
    Key? key,
    required this.columnCount,
    required this.children,
  }) : super(key: key);

  /// Number of column.
  final int columnCount;

  /// The widgets below this widget in the tree.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(children: _buildRows());
  }

  List<Widget> _buildRows() {
    final List<Widget> rows = [];
    final childrenLength = children.length;
    final rowCount = (childrenLength / columnCount).ceil();

    for (int rowIndex = 0; rowIndex < rowCount; rowIndex++) {
      final List<Widget> columns = _buildRowCells(rowIndex);
      rows.add(Row(children: columns));
    }

    return rows;
  }

  List<Widget> _buildRowCells(int rowIndex) {
    final List<Widget> columns = [];
    final childrenLength = children.length;

    for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
      final cellIndex = rowIndex * columnCount + columnIndex;
      if (cellIndex <= childrenLength - 1) {
        columns.add(Expanded(child: children[cellIndex]));
      } else {
        columns.add(Expanded(child: Container()));
      }
    }

    return columns;
  }
}
