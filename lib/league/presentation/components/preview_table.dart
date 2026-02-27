import 'package:flutter/material.dart';
import 'package:greenie/app/core/theme/sizes.dart';

enum PreviewCellStyle {
  /// Primary color, bold — used for rank numbers.
  rank,

  /// Bold when the row is highlighted, overflow ellipsis — used for names.
  name,

  /// Outline color, normal weight — used for secondary info like W-L-T.
  secondary,

  /// Bold, normal color — used for the key numeric value (score, handicap, pts).
  value,
}

class PreviewColumn {
  /// Creates a column. Provide [flex] for an expanding column or [width] for
  /// a fixed-width column. Exactly one must be non-null.
  const PreviewColumn({
    required this.label,
    required this.style,
    this.flex,
    this.width,
    this.alignment = TextAlign.start,
  }) : assert(
         (flex == null) != (width == null),
         'Provide exactly one of flex or width',
       );

  final String label;
  final PreviewCellStyle style;
  final int? flex;
  final double? width;
  final TextAlign alignment;
}

class PreviewRow {
  const PreviewRow({
    required this.cells,
    this.isHighlighted = false,
    this.onTap,
  });

  final List<String> cells;
  final bool isHighlighted;
  final VoidCallback? onTap;
}

/// A card-based table used for compact inline previews on the league home
/// screen. Renders column headers, data rows with optional row highlighting,
/// and a tappable "view all" footer.
class PreviewTable extends StatelessWidget {
  const PreviewTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.viewAllLabel,
    required this.onViewAll,
  });

  final List<PreviewColumn> columns;
  final List<PreviewRow> rows;
  final String viewAllLabel;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: GreenieSizes.large),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GreenieSizes.large,
                vertical: GreenieSizes.small,
              ),
              child: _buildRowLayout(
                columns.map((c) => c.label).toList(),
                isHighlighted: false,
                isHeader: true,
                theme: theme,
              ),
            ),
            const Divider(height: 1),
            ...rows.map((row) {
              final content = Container(
                color: row.isHighlighted
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
                    : null,
                padding: const EdgeInsets.symmetric(
                  horizontal: GreenieSizes.large,
                  vertical: GreenieSizes.medium,
                ),
                child: _buildRowLayout(
                  row.cells,
                  isHighlighted: row.isHighlighted,
                  isHeader: false,
                  theme: theme,
                ),
              );
              return row.onTap != null
                  ? InkWell(onTap: row.onTap, child: content)
                  : content;
            }),
            const Divider(height: 1),
            InkWell(
              onTap: onViewAll,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: GreenieSizes.large,
                  vertical: GreenieSizes.medium,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      viewAllLabel,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: GreenieSizes.large,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowLayout(
    List<String> cells, {
    required bool isHighlighted,
    required bool isHeader,
    required ThemeData theme,
  }) {
    return Row(
      children: List.generate(columns.length, (i) {
        final col = columns[i];
        final cell = i < cells.length ? cells[i] : '';

        final textWidget = Text(
          cell,
          textAlign: col.alignment,
          overflow: col.style == PreviewCellStyle.name
              ? TextOverflow.ellipsis
              : null,
          style: isHeader
              ? theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outline,
                )
              : _cellStyle(theme, col.style, isHighlighted),
        );

        return col.flex != null
            ? Expanded(flex: col.flex!, child: textWidget)
            : SizedBox(width: col.width!, child: textWidget);
      }),
    );
  }

  TextStyle? _cellStyle(
    ThemeData theme,
    PreviewCellStyle style,
    bool isHighlighted,
  ) {
    return switch (style) {
      PreviewCellStyle.rank => theme.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
      PreviewCellStyle.name => theme.textTheme.bodyMedium?.copyWith(
        fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
      ),
      PreviewCellStyle.secondary => theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.outline,
      ),
      PreviewCellStyle.value => theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    };
  }
}
