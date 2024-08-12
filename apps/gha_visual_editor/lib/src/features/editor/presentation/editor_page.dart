import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:signals/signals_flutter.dart';

final borderColor = signal(AppColors.borderBlack);
final secondBorderColor = signal(Colors.transparent);
final isFocused = signal(false);

class SemicircleBorderPainter extends CustomPainter {
  final Color borderColor;
  final Color outerBorderColor;

  SemicircleBorderPainter({
    required this.borderColor,
    required this.outerBorderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.firstStepDarkGray
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 最も外側のボーダーを描画
    final Paint outerBorderPaint = Paint()
      ..color = outerBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final outerRect = Rect.fromCircle(
      center: center,
      radius: radius + 2.3, // 元の円より外側に
    );

    canvas.drawArc(
      outerRect,
      0,
      pi,
      false,
      outerBorderPaint,
    );

    // 内側のボーダーを描画（元の円の外側）
    final Paint innerBorderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final innerRect = Rect.fromCircle(
      center: center,
      radius: radius + 0.5, // 最も外側のボーダーより少し内側
    );

    canvas.drawArc(
      innerRect,
      0,
      pi,
      false,
      innerBorderPaint,
    );

    // 元の円を描画
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SingleBorderPainter extends CustomPainter {
  SingleBorderPainter(this.borderColor);
  final Color borderColor;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.firstStepDarkGray
      ..style = PaintingStyle.fill;

    // 円全体を描画
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);

    // 下半分のボーダーを描画
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    canvas.drawArc(
      rect,
      0, // 開始角度（ラジアン）
      pi, // 終了角度（ラジアン、πは半円）
      false,
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SemicircleBorderWidget extends StatelessWidget {
  const SemicircleBorderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) => SizedBox(
        width: 22,
        height: 22,
        child: CustomPaint(
          painter: isFocused.value
              ? SemicircleBorderPainter(
                  borderColor: borderColor.value,
                  outerBorderColor: secondBorderColor.value,
                )
              : SingleBorderPainter(borderColor.value),
          child: Center(
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.bluePoint,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DraggableArrowPainter extends CustomPainter {
  final Offset start;
  final Offset end;

  DraggableArrowPainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // 矢印の本体を描画
    canvas.drawLine(start, end, paint);

    // 矢印の先端を描画
    const arrowSize = 15.0;
    final angle = atan2(end.dy - start.dy, end.dx - start.dx);
    final path = Path();
    path.moveTo(end.dx, end.dy);
    path.lineTo(
      end.dx - arrowSize * cos(angle - pi / 6),
      end.dy - arrowSize * sin(angle - pi / 6),
    );
    path.moveTo(end.dx, end.dy);
    path.lineTo(
      end.dx - arrowSize * cos(angle + pi / 6),
      end.dy - arrowSize * sin(angle + pi / 6),
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class DraggableArrowWidget extends StatefulWidget {
  const DraggableArrowWidget({super.key});

  @override
  _DraggableArrowWidgetState createState() => _DraggableArrowWidgetState();
}

class _DraggableArrowWidgetState extends State<DraggableArrowWidget> {
  Offset _start = Offset.zero;
  Offset _end = Offset.zero;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _start = details.localPosition;
          _end = details.localPosition;
          _isDragging = true;
        });
      },
      onPanUpdate: (details) {
        if (_isDragging) {
          setState(() {
            _end = details.localPosition;
          });
        }
      },
      onPanEnd: (_) {
        setState(() {
          _isDragging = false;
        });
      },
      child: CustomPaint(
        painter: DraggableArrowPainter(start: _start, end: _end),
        child: Container(),
      ),
    );
  }
}
