import 'package:flutter/material.dart';
import 'package:shule_direct_chat_app/core/constants/app_colors.dart';

class ScoreGaugeWidget extends StatefulWidget {
  final double score;
  final double minScore;
  final double maxScore;
  final double size;

  const ScoreGaugeWidget({
    super.key,
    required this.score,
    this.minScore = 300,
    this.maxScore = 900,
    this.size = 200,
  });

  @override
  State<ScoreGaugeWidget> createState() => _ScoreGaugeWidgetState();
}

class _ScoreGaugeWidgetState extends State<ScoreGaugeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.score,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _GaugePainter(
              ratio: 1,
              color: const Color.fromRGBO(239, 248, 255, 1),
              gradient: null,
              strokeWidth: 22.0,
            ),
          ),
          // Background Arc (Bottom/Remaining Part)
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _GaugePainter(
              ratio: 0.65,
              color: const Color.fromRGBO(239, 248, 255, 1),
              strokeWidth: 22.0,
              startAngle: 0.9096, // ~30 degrees
              sweepAngle: 2.0944,
            ),
          ),

          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              double currentScore = _animation.value;
              double range = widget.maxScore - widget.minScore;
              double ratio = 0.0;

              if (range > 0) {
                ratio = ((currentScore - widget.minScore) / range).clamp(
                  0.0,
                  1.0,
                );
              }

              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _GaugePainter(
                  ratio: ratio,
                  color: null,
                  strokeWidth: 6.0,
                  gradient: const SweepGradient(
                    colors: AppColors.scoreGradient,
                    stops: [0.0, 0.167, 0.333, 0.5, 0.667],
                    transform: GradientRotation(2.61799),
                  ),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_upward,
                        size: 20,
                        color: Color.fromARGB(255, 29, 151, 39),
                      ),
                      Text(
                        '7',
                        style: TextStyle(
                          color: Color.fromARGB(255, 29, 151, 39),
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _animation.value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              );
            },
          ),

          Positioned(
            left: -30,
            bottom: widget.size * 0.09,
            child: Text(
              '${widget.minScore.toInt()}',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            right: -30,
            bottom: widget.size * 0.09,
            child: Text(
              '${widget.maxScore.toInt()}',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double ratio;
  final Color? color;
  final Gradient? gradient;
  final double strokeWidth;
  final double startAngle;
  final double sweepAngle;

  _GaugePainter({
    required this.ratio,
    this.color,
    this.gradient,
    this.strokeWidth = 15.0,
    this.startAngle = 2.61799,
    this.sweepAngle = 4.18879,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    if (color != null) {
      paint.color = color!;
    }

    if (gradient != null) {
      paint.shader = gradient!.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

      final shadowPaint =
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      shadowPaint.shader = gradient!.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle * ratio,
        false,
        shadowPaint,
      );
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      sweepAngle * ratio,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.ratio != ratio;
  }
}
