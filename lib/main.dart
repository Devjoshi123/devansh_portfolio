// lib/main.dart
// Devansh Joshi — Portfolio (Final, corrected)
// Responsive + animations + hero (no right-space)
// Uses asset: assets/image/profile.jpg
//
// Pubspec dependencies:
//   google_fonts: ^6.0.0
//   url_launcher: ^6.1.7
//
// Add to pubspec.yaml:
// flutter:
//   assets:
//     - assets/image/profile.jpg

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const DevanshApp());
}

class DevanshApp extends StatelessWidget {
  const DevanshApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFEF4444);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Devansh Joshi - Portfolio",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: PortfolioHome(primary: primary),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  final Color primary;
  const PortfolioHome({super.key, required this.primary});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with TickerProviderStateMixin {
  final ScrollController _scroll = ScrollController();

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();

  final List<String> typingLines = [
    "Machine Learning Enthusiast",
    "Aspiring Data Scientist",
    "Python & ML Practitioner",
  ];
  int typingIndex = 0;
  String currentTyped = "";

  late final AnimationController pulseCtrl;
  late final AnimationController auraCtrl;
  late final AnimationController fadeCtrl;
  late final AnimationController floatTextCtrl;

  @override
  void initState() {
    super.initState();

    pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    auraCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
    floatTextCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);

    _startTyping();
  }

  void _startTyping() {
    Timer.periodic(const Duration(milliseconds: 120), (timer) {
      final full = typingLines[typingIndex];
      if (currentTyped.length < full.length) {
        setState(() => currentTyped = full.substring(0, currentTyped.length + 1));
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            currentTyped = "";
            typingIndex = (typingIndex + 1) % typingLines.length;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    pulseCtrl.dispose();
    auraCtrl.dispose();
    fadeCtrl.dispose();
    floatTextCtrl.dispose();
    super.dispose();
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
    await _scroll.animateTo(_scroll.offset + pos.dy - 80, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
  }

  Future<void> _openUrl(String link) async {
    final uri = Uri.parse(link);
    if (!await launchUrl(uri)) {
      // ignore
    }
  }

  Future<void> _openMail() async {
    final uri = Uri(scheme: 'mailto', path: 'joshidevansh211@gmail.com', queryParameters: {'subject': 'Portfolio Inquiry'});
    await launchUrl(uri);
  }

  Future<void> _openResume() async {
    await _openUrl('https://drive.google.com/file/d/1K6MAMrJFoaW642Kt-lyZlEeYUwBHs15D/view?usp=drivesdk');
  }

  Future<void> _openGitHub() async {
    await _openUrl('https://github.com/Devjoshi123');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 820;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(widget.primary),
      body: FadeTransition(
        opacity: fadeCtrl.drive(CurveTween(curve: Curves.easeIn)),
        child: SingleChildScrollView(
          controller: _scroll,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                child: isMobile ? _heroMobile(widget.primary) : _heroDesktop(widget.primary),
              ),
              const SizedBox(height: 40),
              _aboutSection(),
              const SizedBox(height: 40),
              _projectsSection(),
              const SizedBox(height: 60),
              Text('© ${DateTime.now().year} Devansh Joshi', style: const TextStyle(color: Colors.white54)),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Color primary) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          Container(width: 34, height: 34, decoration: BoxDecoration(color: primary, shape: BoxShape.circle), child: const Center(child: Text('D', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          const SizedBox(width: 10),
          const Text('Devansh', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => _scrollTo(_homeKey), child: const Text('Home', style: TextStyle(color: Colors.white70))),
        TextButton(onPressed: () => _scrollTo(_aboutKey), child: const Text('About', style: TextStyle(color: Colors.white70))),
        TextButton(onPressed: () => _scrollTo(_projectsKey), child: const Text('Projects', style: TextStyle(color: Colors.white70))),
        const SizedBox(width: 12),
        ElevatedButton(onPressed: _openMail, style: ElevatedButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(horizontal: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Contact')),
        const SizedBox(width: 20),
      ],
    );
  }

  // HERO (DESKTOP) — fixed full width, flex 4:6
  Widget _heroDesktop(Color primary) {
    return Container(
      key: _homeKey,
      width: double.infinity, // fill width -> removes right gap
      child: Row(
        children: [
          Expanded(flex: 4, child: _heroText(primary)),
          const SizedBox(width: 30),
          Expanded(flex: 6, child: _heroImage(primary)),
        ],
      ),
    );
  }

  Widget _heroText(Color primary) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Hi, I'm", style: TextStyle(color: Colors.white70, fontSize: 20)),
      const SizedBox(height: 10),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "D", style: const TextStyle(fontSize: 75, fontWeight: FontWeight.w900, color: Colors.white, height: 0.9)),
            TextSpan(text: "EVANSH", style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
          ],
        ),
      ),
      const SizedBox(height: 15),
      Text("Machine Learning & Data Science", style: TextStyle(color: primary, fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 18),
      const SizedBox(width: 520, child: Text("I build machine learning models, data pipelines and visualizations. I love turning messy data into meaningful insights and deployable solutions.", style: TextStyle(color: Colors.white70, fontSize: 16))),
      const SizedBox(height: 18),
      AnimatedBuilder(
        animation: floatTextCtrl,
        builder: (_, child) {
          final dy = sin(floatTextCtrl.value * 2 * pi) * 6;
          return Transform.translate(offset: Offset(0, dy), child: child);
        },
        child: Text(currentTyped, style: TextStyle(fontSize: 18, color: primary, fontWeight: FontWeight.w600)),
      ),
      const SizedBox(height: 25),
      Row(children: [
        ElevatedButton.icon(onPressed: _openMail, icon: const Icon(Icons.mail), label: const Text("Hire me"), style: ElevatedButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
        const SizedBox(width: 16),
        ElevatedButton.icon(onPressed: _openResume, icon: const Icon(Icons.download), label: const Text("Resume"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white24, padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
      ]),
      const SizedBox(height: 20),
      Row(children: [IconButton(onPressed: _openGitHub, icon: const Icon(Icons.code, color: Colors.white70))])
    ]);
  }

  Widget _heroImage(Color primary) {
    return Stack(alignment: Alignment.center, clipBehavior: Clip.none, children: [
      // waves
      Positioned.fill(child: CustomPaint(painter: WavePainter(color: Colors.red.shade900.withOpacity(0.15)))),
      // pulse circle
      AnimatedBuilder(
        animation: pulseCtrl,
        builder: (_, __) {
          final scale = 1.0 + pulseCtrl.value * 0.06;
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                gradient: RadialGradient(colors: [Color.lerp(widget.primary, Colors.black, 0.3)!, widget.primary], center: const Alignment(-0.3, -0.2)),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
      // aura glow
      AnimatedBuilder(
        animation: auraCtrl,
        builder: (_, __) {
          final glow = 1.0 + auraCtrl.value * 0.12;
          return Transform.scale(scale: glow, child: Container(width: 460, height: 460, decoration: BoxDecoration(color: widget.primary.withOpacity(0.08), shape: BoxShape.circle)));
        },
      ),
      // floating small bubbles
      Positioned(top: -40, right: -20, child: _bubble(90, 0.10)),
      Positioned(bottom: -50, left: -30, child: _bubble(120, 0.08)),
      Positioned(top: 40, right: 80, child: _bubble(60, 0.12)),
      // clipped profile
      ClipOval(child: Image.asset("assets/image/profile.jpg", width: 300, height: 300, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 80, color: Colors.white24))),
    ]);
  }

  Widget _bubble(double size, double opacity) {
    return AnimatedBuilder(
      animation: auraCtrl,
      builder: (_, __) {
        final dx = sin(auraCtrl.value * 2 * pi) * 6;
        final dy = cos(auraCtrl.value * 2 * pi) * 6;
        return Transform.translate(offset: Offset(dx, dy), child: Container(width: size, height: size, decoration: BoxDecoration(color: Colors.red.withOpacity(opacity), shape: BoxShape.circle)));
      },
    );
  }

  // MOBILE HERO — stacked with same big-D feel (responsive)
  Widget _heroMobile(Color primary) {
    return Container(
      key: _homeKey,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // pulse + aura + clipped image
          Stack(alignment: Alignment.center, children: [
            AnimatedBuilder(
              animation: pulseCtrl,
              builder: (_, __) {
                final scale = 1.0 + pulseCtrl.value * 0.06;
                return Transform.scale(
                  scale: scale,
                  child: Container(width: 220, height: 220, decoration: BoxDecoration(gradient: RadialGradient(colors: [Color.lerp(widget.primary, Colors.black, 0.3)!, widget.primary], center: const Alignment(-0.3, -0.2)), shape: BoxShape.circle)),
                );
              },
            ),
            AnimatedBuilder(
              animation: auraCtrl,
              builder: (_, __) {
                final glow = 1.0 + auraCtrl.value * 0.12;
                return Transform.scale(scale: glow, child: Container(width: 300, height: 300, decoration: BoxDecoration(color: widget.primary.withOpacity(0.06), shape: BoxShape.circle)));
              },
            ),
            ClipOval(child: Image.asset("assets/image/profile.jpg", width: 170, height: 170, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 80, color: Colors.white24))),
          ]),
          const SizedBox(height: 14),
          RichText(text: TextSpan(children: [
            TextSpan(text: "D", style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: Colors.white)),
            TextSpan(text: "EVANSH", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
          ])),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: floatTextCtrl,
            builder: (_, child) {
              final dy = sin(floatTextCtrl.value * 2 * pi) * 6;
              return Transform.translate(offset: Offset(0, dy), child: child);
            },
            child: Text(currentTyped, style: TextStyle(color: widget.primary, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 12),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 18), child: Text("I build ML models and data visualizations that help solve real problems.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70))),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton.icon(onPressed: _openMail, icon: const Icon(Icons.mail), label: const Text("Hire me"), style: ElevatedButton.styleFrom(backgroundColor: widget.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
            const SizedBox(width: 10),
            ElevatedButton.icon(onPressed: _openResume, icon: const Icon(Icons.download), label: const Text("Resume"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white24, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
          ]),
        ],
      ),
    );
  }

  Widget _aboutSection() {
    return Container(
      key: _aboutKey,
      padding: const EdgeInsets.all(25),
      constraints: const BoxConstraints(maxWidth: 1000),
      decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(14)),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("About Me", style: TextStyle(fontSize: 22, color: Colors.redAccent, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Text("Aspiring Data Scientist focused on building ML models, data analysis pipelines and visualizations. Skilled with Python, Pandas, Scikit-learn, SQL, Tableau.", style: TextStyle(color: Colors.white70)),
      ]),
    );
  }

  Widget _projectsSection() {
    final projects = [
      {'t': 'Heart Disease Prediction', 'd': 'ML model for predicting heart disease risk.'},
      {'t': "Doctor's Handwritten Text Detection", 'd': 'OCR model to extract text from messy prescriptions.'},
      {'t': 'Urban Tree Density Analysis', 'd': 'Satellite image model estimating tree coverage.'},
      {'t': 'Helpdesk Ticketing System', 'd': 'Automated ticket classification & workflow.'},
    ];

    return Container(
      key: _projectsKey,
      constraints: const BoxConstraints(maxWidth: 1000),
      padding: const EdgeInsets.all(25),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Projects', style: TextStyle(color: Colors.redAccent, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          final cross = width > 900 ? 2 : (width > 600 ? 1 : 1);
          return Wrap(spacing: 20, runSpacing: 20, children: List.generate(projects.length, (i) {
            final p = projects[i];
            return MouseRegion(
              onEnter: (_) => setState(() {}),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: (width / cross) - 20,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.18), blurRadius: 12, offset: const Offset(0, 10))]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p['t']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(p['d']!, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [TextButton(onPressed: () {}, child: const Text('View', style: TextStyle(color: Colors.redAccent)))])
                ]),
              ),
            );
          }));
        }),
      ]),
    );
  }
}

// Custom painter for hero waves
class WavePainter extends CustomPainter {
  final Color color;
  WavePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.55, size.width * 0.5, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.85, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
