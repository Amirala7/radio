import 'package:flutter/material.dart';

/// A pixelated heart drawn from a 7×6 grid. CustomPaint rather than an
/// asset so it stays crisp at any cellSize and matches the LCD pixel
/// aesthetic without pulling in flutter_svg.
class PixelHeart extends StatelessWidget {
  const PixelHeart({
    super.key,
    required this.filled,
    required this.color,
    required this.cellSize,
  });

  final bool filled;
  final Color color;
  final double cellSize;

  // 7 columns × 6 rows. Outer cells are the same; only the interior
  // differs between filled and outline.
  // .##.##.
  // #######
  // #######
  // .#####.
  // ..###..
  // ...#...
  static const _filledGrid = <List<int>>[
    [0, 1, 1, 0, 1, 1, 0],
    [1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1],
    [0, 1, 1, 1, 1, 1, 0],
    [0, 0, 1, 1, 1, 0, 0],
    [0, 0, 0, 1, 0, 0, 0],
  ];
  static const _outlineGrid = <List<int>>[
    [0, 1, 1, 0, 1, 1, 0],
    [1, 0, 0, 1, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 1],
    [0, 1, 0, 0, 0, 1, 0],
    [0, 0, 1, 0, 1, 0, 0],
    [0, 0, 0, 1, 0, 0, 0],
  ];

  static const _cols = 7;
  static const _rows = 6;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cellSize * _cols,
      height: cellSize * _rows,
      child: CustomPaint(
        painter: _PixelHeartPainter(
          grid: filled ? _filledGrid : _outlineGrid,
          color: color,
        ),
      ),
    );
  }
}

class _PixelHeartPainter extends CustomPainter {
  _PixelHeartPainter({required this.grid, required this.color});

  final List<List<int>> grid;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cols = grid[0].length;
    final rows = grid.length;
    final cellW = size.width / cols;
    final cellH = size.height / rows;
    final paint = Paint()..color = color;
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        if (grid[r][c] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(c * cellW, r * cellH, cellW, cellH),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PixelHeartPainter old) =>
      old.grid != grid || old.color != color;
}
