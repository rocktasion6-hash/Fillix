import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final SplashController _splashController;

  @override
  void initState() {
    super.initState();
    _splashController = Get.find<SplashController>();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8600),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _splashController.goToLogin();
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _part(double start, double end, Curve curve) {
    final raw = ((_controller.value - start) / (end - start)).clamp(0.0, 1.0);
    return curve.transform(raw);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final v = _controller.value;

          final appear = _part(0.00, 0.38, Curves.easeOutCubic);
          final hold = _part(0.30, 0.52, Curves.easeInOut);
          // Zoom dibuat pelan. Saat zoom mulai berjalan, garis atas F
          // hilang dari kanan ke kiri, lalu disusul garis tengah F.
          final zoom = _part(0.44, 0.82, Curves.easeInOutCubic);
          final fLineExit = _part(0.44, 0.70, Curves.easeInOutCubic);
          final tunnel = _part(0.50, 0.97, Curves.easeOutCubic);
          final finalFade = _part(0.90, 1.00, Curves.easeIn);

          // Batang F tetap kelihatan saat awal zoom, lalu pelan-pelan
          // melebur mengikuti garis warna-warni.
          final logoOpacity = v < 0.66
              ? 1.0
              : (1 - _part(0.66, 0.82, Curves.easeIn)).clamp(0.0, 1.0);
          final size = MediaQuery.sizeOf(context);
          final logoPaintWidth = math.min(size.width * 0.28, 170).toDouble();
          // Titik zoom harus masuk ke batang utama F, bukan ke tengah huruf F.
          // Batang F berada sekitar 30.5% dari lebar logo.
          final stemZoomX = (size.width / 2) - (logoPaintWidth * 0.195);
          final stemAlignment = const Alignment(-0.39, 0);

          return Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: Colors.black),

              // Cahaya merah tipis di belakang logo, seperti awal intro.
              if (appear > 0)
                CustomPaint(
                  painter: _RedAtmospherePainter(
                    progress: appear,
                    pulse: math.sin(hold * math.pi),
                  ),
                ),

              // Efek masuk ke dalam logo: garis merah melebar dari tengah.
              if (zoom > 0)
                CustomPaint(
                  painter: _RedZoomGatePainter(progress: zoom, centerX: stemZoomX),
                ),

              // Bagian paling mirip intro Netflix: lorong garis warna-warni.
              if (tunnel > 0)
                CustomPaint(
                  painter: _NetflixLikeTunnelPainter(
                    progress: tunnel,
                    fade: finalFade,
                    anchorX: stemZoomX / size.width,
                  ),
                ),

              Center(
                child: Opacity(
                  opacity: logoOpacity,
                  child: Transform.scale(
                    alignment: stemAlignment,
                    scale: 0.60 + (appear * 0.42) + (zoom * 30),
                    child: Transform.translate(
                      offset: Offset(0, -10 * (1 - appear)),
                      child: CustomPaint(
                        size: Size(
                          logoPaintWidth,
                          math.min(size.height * 0.50, 250),
                        ),
                        painter: _FillixNetflixFLogoPainter(
                          progress: appear,
                          glow: hold,
                          lineExit: fLineExit,
                          zoom: zoom,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Fade hitam di akhir supaya perpindahan ke login halus.
              if (finalFade > 0)
                Opacity(
                  opacity: finalFade,
                  child: const ColoredBox(color: Colors.black),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _FillixNetflixFLogoPainter extends CustomPainter {
  final double progress;
  final double glow;
  final double lineExit;
  final double zoom;

  _FillixNetflixFLogoPainter({
    required this.progress,
    required this.glow,
    required this.lineExit,
    required this.zoom,
  });

  double _range(double start, double end) {
    final raw = ((progress - start) / (end - start)).clamp(0.0, 1.0);
    return Curves.easeOutCubic.transform(raw);
  }

  double _zoomRange(double start, double end, Curve curve) {
    final raw = ((zoom - start) / (end - start)).clamp(0.0, 1.0);
    return curve.transform(raw);
  }

  double _lineExitRange(double start, double end, Curve curve) {
    final raw = ((lineExit - start) / (end - start)).clamp(0.0, 1.0);
    return curve.transform(raw);
  }

  void _drawRevealedPath(
    Canvas canvas,
    Path path,
    Rect bounds,
    Paint paint,
    double reveal, {
    bool vertical = false,
  }) {
    if (reveal <= 0) return;
    canvas.save();
    if (vertical) {
      canvas.clipRect(Rect.fromLTWH(
        bounds.left - 20,
        bounds.top - 20,
        bounds.width + 40,
        (bounds.height + 40) * reveal,
      ));
    } else {
      canvas.clipRect(Rect.fromLTWH(
        bounds.left - 20,
        bounds.top - 20,
        (bounds.width + 40) * reveal,
        bounds.height + 40,
      ));
    }
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Rect.fromLTWH(0, 0, w, h);

    // Dibangun satu per satu seperti intro Netflix:
    // 1) batang utama turun, 2) garis atas ke kanan, 3) garis tengah ke kanan.
    final verticalReveal = _range(0.00, 0.46);
    final topReveal = _range(0.28, 0.72);
    final midReveal = _range(0.56, 1.00);

    // Saat kamera mulai masuk/zoom, garis atas dan tengah
    // tidak langsung hilang. Keduanya disapu perlahan dari kanan
    // ke kiri sambil batang utama F mulai membesar.
    final topExit = _lineExitRange(0.00, 0.48, Curves.easeInOutCubic);
    final midExit = _lineExitRange(0.28, 0.82, Curves.easeInOutCubic);
    final topVisible = topReveal * (1 - topExit);
    final midVisible = midReveal * (1 - midExit);
    final meshProgress = _zoomRange(0.00, 0.48, Curves.easeOutCubic);

    final stem = Path()
      ..moveTo(w * 0.18, h * 0.04)
      ..lineTo(w * 0.43, h * 0.18)
      ..lineTo(w * 0.43, h * 0.92)
      ..lineTo(w * 0.18, h * 0.99)
      ..close();

    final topBar = Path()
      ..moveTo(w * 0.22, h * 0.04)
      ..lineTo(w * 0.94, h * 0.04)
      ..lineTo(w * 0.84, h * 0.22)
      ..lineTo(w * 0.42, h * 0.22)
      ..lineTo(w * 0.18, h * 0.04)
      ..close();

    final middleBar = Path()
      ..moveTo(w * 0.42, h * 0.40)
      ..lineTo(w * 0.78, h * 0.40)
      ..lineTo(w * 0.68, h * 0.57)
      ..lineTo(w * 0.42, h * 0.57)
      ..close();

    final visibleLogo = Path();
    if (verticalReveal > 0) visibleLogo.addPath(stem, Offset.zero);
    if (topVisible > 0) visibleLogo.addPath(topBar, Offset.zero);
    if (midVisible > 0) visibleLogo.addPath(middleBar, Offset.zero);

    final shadow = Paint()
      ..color = const Color(0xFFE50914).withOpacity(0.35 + 0.20 * progress)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 18 + glow * 26);

    // Glow juga ikut muncul mengikuti bagian yang sudah terbentuk.
    if (progress > 0) {
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(0, 0, w, h));
      _drawRevealedPath(
        canvas,
        stem,
        Rect.fromLTWH(w * 0.12, h * 0.02, w * 0.38, h * 0.98),
        shadow,
        verticalReveal,
        vertical: true,
      );
      _drawRevealedPath(
        canvas,
        topBar,
        Rect.fromLTWH(w * 0.15, h * 0.00, w * 0.83, h * 0.25),
        shadow,
        topVisible,
      );
      _drawRevealedPath(
        canvas,
        middleBar,
        Rect.fromLTWH(w * 0.38, h * 0.36, w * 0.45, h * 0.26),
        shadow,
        midVisible,
      );
      canvas.restore();
    }

    final main = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFF1D25),
          Color(0xFFE50914),
          Color(0xFFB00610),
          Color(0xFFFF0712),
        ],
        stops: [0.0, 0.35, 0.72, 1.0],
      ).createShader(rect);

    _drawRevealedPath(
      canvas,
      stem,
      Rect.fromLTWH(w * 0.12, h * 0.02, w * 0.38, h * 0.98),
      main,
      verticalReveal,
      vertical: true,
    );
    _drawRevealedPath(
      canvas,
      topBar,
      Rect.fromLTWH(w * 0.15, h * 0.00, w * 0.83, h * 0.25),
      main,
      topVisible,
    );
    _drawRevealedPath(
      canvas,
      middleBar,
      Rect.fromLTWH(w * 0.38, h * 0.36, w * 0.45, h * 0.26),
      main,
      midVisible,
    );

    // Bayangan lipatan, ikut direveal supaya huruf F terasa terbentuk bertahap.
    final foldPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF620006).withOpacity(0.88),
          const Color(0xFFE50914).withOpacity(0.10),
        ],
      ).createShader(rect);

    final stemFold = Path()
      ..moveTo(w * 0.18, h * 0.04)
      ..lineTo(w * 0.43, h * 0.18)
      ..lineTo(w * 0.43, h * 0.48)
      ..lineTo(w * 0.18, h * 0.30)
      ..close();
    _drawRevealedPath(
      canvas,
      stemFold,
      Rect.fromLTWH(w * 0.14, h * 0.02, w * 0.34, h * 0.50),
      foldPaint,
      verticalReveal,
      vertical: true,
    );

    final midFold = Path()
      ..moveTo(w * 0.42, h * 0.40)
      ..lineTo(w * 0.78, h * 0.40)
      ..lineTo(w * 0.68, h * 0.57)
      ..lineTo(w * 0.42, h * 0.57)
      ..close();
    _drawRevealedPath(
      canvas,
      midFold,
      Rect.fromLTWH(w * 0.38, h * 0.36, w * 0.45, h * 0.26),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFF6F0007).withOpacity(0.52),
            const Color(0xFFFF1822).withOpacity(0.16),
          ],
        ).createShader(rect),
      midVisible,
    );

    // Saat batang F mulai di-zoom, isi batang berubah menjadi garis-garis
    // vertikal rapat seperti potongan cahaya pada intro Netflix.
    if (meshProgress > 0) {
      canvas.save();
      canvas.clipPath(stem);

      final darkGap = Paint()
        ..color = Colors.black.withOpacity(0.20 + 0.46 * meshProgress)
        ..strokeCap = StrokeCap.square;

      final lightColors = [
        const Color(0xFFFF101A),
        const Color(0xFFFF5A00),
        const Color(0xFFFFB000),
        const Color(0xFFFF2D75),
        const Color(0xFF8B22FF),
      ];

      for (int i = 0; i < 30; i++) {
        final t = i / 29.0;
        final x = w * (0.15 + t * 0.34) + math.sin(i * 1.7) * w * 0.008;
        final width = (0.9 + (i % 4) * 0.55) * meshProgress;
        canvas.drawLine(
          Offset(x, h * -0.08),
          Offset(x + w * 0.03 * meshProgress, h * 1.08),
          Paint()
            ..color = lightColors[i % lightColors.length]
                .withOpacity(0.10 + 0.38 * meshProgress)
            ..strokeWidth = width
            ..strokeCap = StrokeCap.square
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.0 + 2.5 * meshProgress),
        );
      }

      for (int i = 0; i < 22; i++) {
        final t = i / 21.0;
        final x = w * (0.15 + t * 0.35);
        darkGap.strokeWidth = 0.9 + (i % 3) * 0.8 + 1.8 * meshProgress;
        canvas.drawLine(
          Offset(x, h * -0.04),
          Offset(x + w * 0.018 * meshProgress, h * 1.04),
          darkGap,
        );
      }

      canvas.restore();
    }

    // Garis kilau merah kecil saat tiap bagian sedang terbentuk.
    final sparkle = Paint()
      ..color = Colors.white.withOpacity(0.09)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    if (verticalReveal > 0 && verticalReveal < 1) {
      final y = h * (0.04 + 0.90 * verticalReveal);
      canvas.drawLine(Offset(w * 0.18, y), Offset(w * 0.43, y - h * 0.04), sparkle);
    }
    if (topReveal > 0 && topReveal < 1 && topExit == 0) {
      final x = w * (0.18 + 0.76 * topReveal);
      canvas.drawLine(Offset(x, h * 0.04), Offset(x - w * 0.05, h * 0.20), sparkle);
    }
    if (midReveal > 0 && midReveal < 1 && midExit == 0) {
      final x = w * (0.42 + 0.36 * midReveal);
      canvas.drawLine(Offset(x, h * 0.40), Offset(x - w * 0.04, h * 0.57), sparkle);
    }

    // Setelah semua bagian selesai, beri highlight halus pada logo penuh.
    if (progress > 0.92) {
      final done = ((progress - 0.92) / 0.08).clamp(0.0, 1.0);
      canvas.drawPath(
        visibleLogo,
        Paint()
          ..color = Colors.white.withOpacity(0.035 * done)
          ..blendMode = BlendMode.plus,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FillixNetflixFLogoPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.glow != glow ||
        oldDelegate.lineExit != lineExit ||
        oldDelegate.zoom != zoom;
  }
}

class _RedAtmospherePainter extends CustomPainter {
  final double progress;
  final double pulse;

  _RedAtmospherePainter({required this.progress, required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: size.width * 0.55);

    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF320004).withOpacity(0.55 * progress),
            const Color(0xFF090000).withOpacity(0.25 * progress),
            Colors.black,
          ],
          stops: const [0.0, 0.34, 1.0],
        ).createShader(rect),
    );

    final glowWidth = 14 + pulse * 28;
    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.16),
      Offset(size.width * 0.50, size.height * 0.84),
      Paint()
        ..color = const Color(0xFFE50914).withOpacity(0.14 * progress)
        ..strokeWidth = glowWidth
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28),
    );
  }

  @override
  bool shouldRepaint(covariant _RedAtmospherePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.pulse != pulse;
  }
}

class _RedZoomGatePainter extends CustomPainter {
  final double progress;
  final double centerX;

  _RedZoomGatePainter({required this.progress, required this.centerX});

  @override
  void paint(Canvas canvas, Size size) {
    final maxWidth = size.width * 1.4;
    final width = 8 + maxWidth * progress;
    final opacity = (1 - progress).clamp(0.0, 1.0);

    final rect = Rect.fromCenter(
      center: Offset(centerX, size.height / 2),
      width: width,
      height: size.height * 1.2,
    );

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            const Color(0xFF410004).withOpacity(0.48 * opacity),
            const Color(0xFFE50914).withOpacity(0.96 * opacity),
            const Color(0xFFFF101A).withOpacity(0.96 * opacity),
            const Color(0xFF410004).withOpacity(0.48 * opacity),
            Colors.transparent,
          ],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _RedZoomGatePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.centerX != centerX;
  }
}

class _NetflixLikeTunnelPainter extends CustomPainter {
  final double progress;
  final double fade;
  final double anchorX;

  _NetflixLikeTunnelPainter({
    required this.progress,
    required this.fade,
    required this.anchorX,
  });

  static const _warmPalette = <Color>[
    Color(0xFFE50914),
    Color(0xFFFF1A1F),
    Color(0xFFFF6400),
    Color(0xFFFFB400),
    Color(0xFFFFD86B),
    Color(0xFFB12A12),
    Color(0xFF7B0010),
    Color(0xFFFF2D75),
    Color(0xFF8A18D6),
  ];

  static const _fullPalette = <Color>[
    Color(0xFFFFF0B0),
    Color(0xFFFF9448),
    Color(0xFFE50914),
    Color(0xFFFF6A00),
    Color(0xFFFFCC66),
    Color(0xFFFF2D75),
    Color(0xFF7E57FF),
    Color(0xFF4FB2FF),
    Color(0xFFFFA05A),
    Color(0xFF8B3F32),
    Color(0xFFE50914),
  ];

  static const _coolPalette = <Color>[
    Color(0xFFE50914),
    Color(0xFFFF2E24),
    Color(0xFFFFB35A),
    Color(0xFFFF7C39),
    Color(0xFFFF6AA7),
    Color(0xFFC9B5D8),
    Color(0xFF4960FF),
    Color(0xFF2D7BFF),
    Color(0xFF33A6FF),
    Color(0xFF67D9FF),
  ];

  double _phase(double start, double end, [Curve curve = Curves.easeOutCubic]) {
    final raw = ((progress - start) / (end - start)).clamp(0.0, 1.0);
    return curve.transform(raw);
  }

  void _drawStripeField(
    Canvas canvas,
    Rect rect, {
    required List<Color> palette,
    required int count,
    required double opacity,
    required double blurBase,
    required double driftSeed,
    double thicknessMin = 1.0,
    double thicknessMax = 6.0,
    double blackGapStrength = 0.0,
  }) {
    final w = rect.width;
    final h = rect.height;

    for (int i = 0; i < count; i++) {
      final t = i / (count - 1);
      final drift = math.sin((progress * 7.0) + i * driftSeed) * w * 0.008;
      final x = rect.left + w * t + drift;
      final thickMix = ((i % 7) / 6.0);
      final lineWidth = thicknessMin + (thicknessMax - thicknessMin) * thickMix;
      final color = palette[i % palette.length];
      final isBright = i % 5 == 0 || i % 9 == 0;
      final alpha = opacity * (isBright ? 0.92 : 0.46);

      canvas.drawLine(
        Offset(x, rect.top),
        Offset(x + math.sin(i * 0.33) * w * 0.01, rect.bottom),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withOpacity(alpha * 0.85),
              color.withOpacity(alpha),
              color.withOpacity(alpha * 0.75),
            ],
          ).createShader(Rect.fromLTWH(x - lineWidth, rect.top, lineWidth * 2, h))
          ..strokeWidth = lineWidth
          ..strokeCap = StrokeCap.square
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            blurBase + (isBright ? 1.8 : 0.5),
          ),
      );
    }

    if (blackGapStrength > 0) {
      final gapCount = math.max(8, count ~/ 3);
      for (int i = 0; i < gapCount; i++) {
        final t = i / (gapCount - 1);
        final x = rect.left + w * t;
        canvas.drawLine(
          Offset(x, rect.top),
          Offset(x, rect.bottom),
          Paint()
            ..color = Colors.black.withOpacity(blackGapStrength * (0.32 + (i % 4) * 0.09))
            ..strokeWidth = 1.0 + (i % 3) * 1.2
            ..strokeCap = StrokeCap.square,
        );
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final fadeOut = (1 - fade).clamp(0.0, 1.0);
    final p1 = _phase(0.00, 0.20);
    final p2 = _phase(0.18, 0.44);
    final p3 = _phase(0.42, 0.70);
    final p4 = _phase(0.68, 0.92, Curves.easeInCubic);
    final endBlack = _phase(0.88, 1.00, Curves.easeIn);

    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);

    // Phase 1: bidang garis vertikal hangat masih sempit, sisi tetap hitam.
    if (progress < 0.28) {
      final bandWidth = w * (0.08 + 0.40 * p1);
      final bandRect = Rect.fromCenter(
        center: Offset(w * anchorX, h * 0.5),
        width: bandWidth,
        height: h * 1.10,
      );
      canvas.save();
      canvas.clipRect(bandRect);
      canvas.drawRect(
        bandRect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withOpacity(0.9),
              const Color(0xFF4B0008).withOpacity(0.95 * fadeOut),
              const Color(0xFFAA0914).withOpacity(0.98 * fadeOut),
              const Color(0xFF4B0008).withOpacity(0.95 * fadeOut),
              Colors.black.withOpacity(0.9),
            ],
            stops: const [0.0, 0.18, 0.5, 0.82, 1.0],
          ).createShader(bandRect),
      );
      _drawStripeField(
        canvas,
        bandRect,
        palette: _warmPalette,
        count: 72,
        opacity: 1.00 * fadeOut,
        blurBase: 1.4,
        driftSeed: 0.73,
        thicknessMin: 1.0,
        thicknessMax: 5.8,
        blackGapStrength: 0.70,
      );
      canvas.restore();
    }

    // Phase 2: band membesar sampai hampir memenuhi layar seperti gambar kedua.
    if (progress >= 0.18 && progress < 0.58) {
      final expand = p2;
      final bandWidth = w * (0.34 + 0.82 * expand);
      final bandRect = Rect.fromCenter(
        center: Offset(w * (anchorX + 0.01 * math.sin(progress * 8)), h * 0.5),
        width: bandWidth,
        height: h * 1.10,
      );

      canvas.save();
      canvas.clipRect(bandRect);
      canvas.drawRect(
        bandRect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withOpacity(0.95),
              const Color(0xFF3A0005).withOpacity(0.92 * fadeOut),
              const Color(0xFF90220F).withOpacity(0.95 * fadeOut),
              const Color(0xFF5C1A12).withOpacity(0.95 * fadeOut),
              const Color(0xFF310006).withOpacity(0.92 * fadeOut),
              Colors.black.withOpacity(0.95),
            ],
            stops: const [0.0, 0.10, 0.34, 0.68, 0.90, 1.0],
          ).createShader(bandRect),
      );
      _drawStripeField(
        canvas,
        bandRect,
        palette: _fullPalette,
        count: 132,
        opacity: 0.90 * fadeOut,
        blurBase: 1.6,
        driftSeed: 0.57,
        thicknessMin: 1.1,
        thicknessMax: 8.2,
        blackGapStrength: 0.42,
      );
      canvas.restore();
    }

    // Phase 3: komposisi mulai berubah jadi merah/oranye di kiri dan biru di kanan.
    if (progress >= 0.42 && progress < 0.84) {
      final fullRect = Rect.fromLTWH(-w * 0.02, -h * 0.04, w * 1.04, h * 1.08);
      final blend = p3;
      canvas.save();
      canvas.clipRect(fullRect);

      canvas.drawRect(
        fullRect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black,
              const Color(0xFF180002).withOpacity(0.95 * fadeOut),
              const Color(0xFF250103).withOpacity(0.95 * fadeOut),
              const Color(0xFF0D1029).withOpacity(0.96 * fadeOut),
              const Color(0xFF071730).withOpacity(0.96 * fadeOut),
              Colors.black,
            ],
            stops: const [0.0, 0.14, 0.42, 0.62, 0.86, 1.0],
          ).createShader(fullRect),
      );

      final leftRect = Rect.fromLTWH(-w * 0.01, -h * 0.04, w * (0.52 + 0.05 * (1 - blend)), h * 1.08);
      final rightRect = Rect.fromLTWH(w * 0.48, -h * 0.04, w * 0.54, h * 1.08);

      _drawStripeField(
        canvas,
        leftRect,
        palette: const [
          Color(0xFFE50914),
          Color(0xFFFF301A),
          Color(0xFFFF8A3D),
          Color(0xFFFFD8A8),
          Color(0xFFFF5B5B),
          Color(0xFFB00020),
        ],
        count: 58,
        opacity: 0.88 * fadeOut,
        blurBase: 1.8,
        driftSeed: 0.49,
        thicknessMin: 1.2,
        thicknessMax: 10.0,
        blackGapStrength: 0.66,
      );
      _drawStripeField(
        canvas,
        rightRect,
        palette: const [
          Color(0xFFB8C6FF),
          Color(0xFF4A62FF),
          Color(0xFF2C78FF),
          Color(0xFF39AFFF),
          Color(0xFF60E2FF),
          Color(0xFF8595FF),
        ],
        count: 44,
        opacity: 0.92 * fadeOut,
        blurBase: 2.2,
        driftSeed: 0.61,
        thicknessMin: 1.4,
        thicknessMax: 13.5,
        blackGapStrength: 0.72,
      );

      // Sedikit pendar di area tengah seperti frame referensi.
      canvas.drawRect(
        fullRect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.center,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              const Color(0xFFFF3A29).withOpacity(0.08 * fadeOut),
              const Color(0xFFFFFFFF).withOpacity(0.06 * fadeOut),
              const Color(0xFF59B8FF).withOpacity(0.08 * fadeOut),
              Colors.transparent,
            ],
            stops: const [0.0, 0.35, 0.55, 0.78, 1.0],
          ).createShader(fullRect)
          ..blendMode = BlendMode.plus
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
      );

      canvas.restore();
    }

    // Phase 4: semua garis runtuh menjadi satu batang cahaya merah tipis di tengah.
    if (progress >= 0.70) {
      final collapse = p4;
      final lineWidth = w * (0.24 * (1 - collapse) + 0.018);
      final lineRect = Rect.fromCenter(
        center: Offset(w * anchorX, h * 0.50),
        width: lineWidth,
        height: h * 1.08,
      );

      // Semakin masuk ke akhir, tutup layar jadi hitam kecuali garis tengah merah.
      final sideMaskOpacity = (0.30 + 0.70 * collapse) * fadeOut;
      canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withOpacity(sideMaskOpacity),
              Colors.black.withOpacity(sideMaskOpacity),
              Colors.transparent,
              Colors.black.withOpacity(sideMaskOpacity),
              Colors.black.withOpacity(sideMaskOpacity),
            ],
            stops: const [0.0, 0.42, 0.50, 0.58, 1.0],
          ).createShader(Offset.zero & size),
      );

      canvas.save();
      canvas.clipRect(lineRect);
      canvas.drawRect(
        lineRect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withOpacity(0.0),
              const Color(0xFF5D0006).withOpacity(0.90 * fadeOut),
              const Color(0xFFFF1A1F).withOpacity(0.98 * fadeOut),
              const Color(0xFF5D0006).withOpacity(0.90 * fadeOut),
              Colors.black.withOpacity(0.0),
            ],
            stops: const [0.0, 0.20, 0.50, 0.80, 1.0],
          ).createShader(lineRect),
      );
      _drawStripeField(
        canvas,
        lineRect,
        palette: const [
          Color(0xFFFF101A),
          Color(0xFFFF6152),
          Color(0xFFFFC4B7),
          Color(0xFFE50914),
        ],
        count: 18,
        opacity: (1.0 - collapse * 0.15) * fadeOut,
        blurBase: 1.6,
        driftSeed: 0.41,
        thicknessMin: 1.0,
        thicknessMax: 4.2,
        blackGapStrength: 0.22,
      );
      canvas.restore();
    }

    // Vignette dan penutup jadi full hitam di akhir.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.95,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.08 + 0.12 * progress),
            Colors.black.withOpacity(0.76),
          ],
          stops: const [0.0, 0.72, 1.0],
        ).createShader(Offset.zero & size),
    );

    if (endBlack > 0) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = Colors.black.withOpacity(endBlack),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NetflixLikeTunnelPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.fade != fade ||
        oldDelegate.anchorX != anchorX;
  }
}
