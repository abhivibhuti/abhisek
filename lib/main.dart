import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const PortfolioApp());
}

// === Configure your public links here ===
const String resumeUrl = 'https://example.com/Abhisek_Vibhuti_Resume.pdf';
const String githubUrl = 'https://github.com/';
const String linkedinUrl = 'https://www.linkedin.com/';
const String emailAddress = 'youremail@example.com';
// ========================================

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio',
      theme: ThemeData(
        primaryColor: const Color(0xFF0F172A), // deep indigo/near-black
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          primary: const Color(0xFF7C3AED),
          background: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C3AED),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF0F172A),
            side: const BorderSide(color: Color(0xFF0F172A)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      home: const PortfolioHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PortfolioHome extends StatelessWidget {
  const PortfolioHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abhisek Vibhuti | Portfolio'),
        actions: [
          TextButton(
            onPressed: () => _scrollTo(context, 0),
            child: const Text('Home', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => _scrollTo(context, 1),
            child: const Text('Projects', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => _scrollTo(context, 2),
            child: const Text('Contact', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 24),
            HeroSection(),
            SizedBox(height: 40),
            ProjectsSection(),
            SizedBox(height: 40),
            ContactSection(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _scrollTo(BuildContext context, int section) {
    // placeholder: for a one-page app you could implement ScrollController and global keys
    // For now, this opens the projects or contact sections by simple JS behavior (not implemented)
  }
}

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _avatarOffset;
  late final Animation<Offset> _textOffset;
  late final Animation<double> _avatarOpacity;
  late final Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _avatarOffset = Tween(begin: const Offset(0, 0.12), end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)));
    _textOffset = Tween(begin: const Offset(0, 0.28), end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.2, 1.0, curve: Curves.easeOut)));
    _avatarOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.5)));
    _textOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.2, 1.0)));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    final avatarSize = isWide ? 220.0 : 160.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: isWide
          ? Row(
              children: [
                Expanded(child: _buildIntro(context)),
                const SizedBox(width: 24),
                _buildAnimatedAvatar(avatarSize),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnimatedAvatar(avatarSize),
                const SizedBox(height: 16),
                _buildIntro(context),
              ],
            ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.45;
    final gradient = LinearGradient(colors: const [Color(0xFF7C3AED), Color(0xFF06B6D4)]);

    return SlideTransition(
      position: _textOffset,
      child: FadeTransition(
        opacity: _textOpacity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, I\'m', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: const Color(0xFF0F172A), fontWeight: FontWeight.w400)),
            const SizedBox(height: 6),
            // Gradient text for name
            Builder(builder: (ctx) {
              final shader = gradient.createShader(Rect.fromLTWH(0, 0, width <= 0 ? 200 : width, 80));
              return Text('Abhisek Vibhuti', style: Theme.of(context).textTheme.displayLarge?.copyWith(foreground: Paint()..shader = shader, fontWeight: FontWeight.w800));
            }),
            const SizedBox(height: 12),
            Text(
              'Data Scientist · AI Architect · Gen AI Expert',
              style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => html.window.open(resumeUrl, '_blank'),
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Resume'),
                ),
                OutlinedButton(
                  onPressed: () => html.window.open(githubUrl, '_blank'),
                  child: const Text('GitHub'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedAvatar(double size) {
    // Prefer a local asset; fall back to the LinkedIn URL if asset isn't present.
    const localAsset = 'assets/abhisek_avatar.jpg';
    const imageUrl = 'https://media.licdn.com/dms/image/v2/C5603AQFG-Z_xSsb9Dw/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1651474724021?e=1759363200&v=beta&t=urqgRc5-mtSrBdB0o4iipdWg4fFKbczUpbRWXScDuk8';

    return SlideTransition(
      position: _avatarOffset,
      child: FadeTransition(
        opacity: _avatarOpacity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.asset(
                localAsset,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // If local asset missing, display network image with fallback handling
                  return Image.network(
                    imageUrl,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: size,
                        height: size,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        width: size,
                        height: size,
                        child: Container(
                          color: Colors.grey[200],
                          child: const Center(child: Icon(Icons.person, size: 48, color: Colors.grey)),
                        ),
                      );
                    },
                  );
                },
              ),
              // subtle gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF7C3AED).withOpacity(0.12),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = _sampleProjects();
    final crossAxis = MediaQuery.of(context).size.width > 1000 ? 3 : MediaQuery.of(context).size.width > 600 ? 2 : 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Projects', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          GridView.builder(
            itemCount: projects.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxis,
              mainAxisExtent: 220,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, i) => ProjectCard(project: projects[i]),
          ),
        ],
      ),
    );
  }

  List<Project> _sampleProjects() => [
        Project(
            title: 'Project A',
            description: 'An ML project that does interesting things.',
            url: 'https://github.com/'),
        Project(
            title: 'Project B',
            description: 'A web app for demonstrating UI and interactions.',
            url: 'https://example.com/'),
        Project(title: 'Project C', description: 'Research demo + paper.', url: 'https://arxiv.org/'),
      ];
}

class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => html.window.open(project.url, '_blank'),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(project.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Expanded(child: Text(project.description)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(Icons.open_in_new, size: 16),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contact', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Email: $emailAddress'),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                tooltip: 'GitHub',
                icon: const Icon(Icons.code),
                onPressed: () => html.window.open(githubUrl, '_blank'),
              ),
              IconButton(
                tooltip: 'LinkedIn',
                icon: const Icon(Icons.business),
                onPressed: () => html.window.open(linkedinUrl, '_blank'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Project {
  final String title;
  final String description;
  final String url;
  Project({required this.title, required this.description, required this.url});
}
