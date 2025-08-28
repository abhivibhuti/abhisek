import 'dart:html' as html;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const PortfolioApp());
}
// === Configure your public links here ===
const String resumeUrl = 'https://drive.google.com/file/d/19_7cTTi3l85p2j6KWC5KUDfOsI9RdFzY/view';
const String githubUrl = 'https://github.com/abhivibhuti/';
const String linkedinUrl = 'https://www.linkedin.com/in/abhisek-vibhuti/';
const String emailAddress = 'abhi_vibhuti@hotmail.com';
// ========================================
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abhisek Vibhuti — Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  bool _showAbout = false;
  bool _showProjects = false;
  bool _showContact = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Abhisek Vibhuti | Portfolio'),
        actions: [
          TextButton.icon(
            onPressed: () => setState(() {
              _showProjects = false;
              _showContact = false;
            }),
            icon: const Icon(Icons.home, color: Colors.white),
            label: const Text('Home', style: TextStyle(color: Colors.white)),
          ),
          // Replace Projects in AppBar with GitHub link
          TextButton.icon(
            onPressed: () => html.window.open(githubUrl, '_blank'),
            icon: const Icon(Icons.code, color: Colors.white),
            label: const Text('GitHub', style: TextStyle(color: Colors.white)),
          ),
          // Resume button moved next to Projects in the AppBar
          TextButton.icon(
            onPressed: () => html.window.open(resumeUrl, '_blank'),
            icon: const Icon(Icons.description, color: Colors.white),
            label: const Text('Resume', style: TextStyle(color: Colors.white)),
          ),
          TextButton.icon(
            onPressed: () => setState(() {
              _showContact = true;
              _showProjects = false;
            }),
            icon: const Icon(Icons.mail, color: Colors.white),
            label: const Text('Contact', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            HeroSection(
              onAbout: () => setState(() {
                _showAbout = !_showAbout;
                if (_showAbout) {
                  _showProjects = false;
                  _showContact = false;
                }
              }),
              onProjects: () => setState(() {
                _showProjects = true;
                _showAbout = false;
                _showContact = false;
              }),
            ),
            const SizedBox(height: 20),
            if (!_showAbout && !_showProjects && !_showContact) ...[
              const SizedBox(height: 8),
              const TechCloud(),
              const SizedBox(height: 24),
            ] else
              const SizedBox.shrink(),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: const AboutSection(),
              crossFadeState: _showAbout ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 400),
            ),
            const SizedBox(height: 24),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: const ProjectsSection(),
              crossFadeState: _showProjects ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 400),
            ),
            const SizedBox(height: 40),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: const ContactSection(),
              crossFadeState: _showContact ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 400),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}


class HeroSection extends StatefulWidget {
  final VoidCallback? onAbout;
  final VoidCallback? onProjects;
  const HeroSection({super.key, this.onAbout, this.onProjects});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _avatarOffset;
  late final Animation<Offset> _textOffset;
  late final Animation<double> _avatarOpacity;
  late final Animation<double> _textOpacity;
  bool _avatarHover = false;

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
      padding: const EdgeInsets.fromLTRB(24.0, 48.0, 24.0, 0), // increased top padding to match example
      child: isWide
          ? Row(
              children: [
                Expanded(child: _buildIntro(context)),
                const SizedBox(width: 16), // slightly tighter gap to avatar on wide screens
                _buildAnimatedAvatar(avatarSize),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnimatedAvatar(avatarSize),
                const SizedBox(height: 12),
                _buildIntro(context),
              ],
            ),
    );
  }

  Widget _buildIntro(BuildContext context) {

    return SlideTransition(
      position: _textOffset,
      child: FadeTransition(
        opacity: _textOpacity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, I\'m', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            // Plain white name text
            Builder(builder: (ctx) {
              final isWideName = MediaQuery.of(ctx).size.width > 800;
              final nameFontSize = isWideName ? 48.0 : 36.0;
              return Text(
                'Abhisek Vibhuti',
                style: TextStyle(
                  fontSize: nameFontSize,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  color: Colors.white,
                ),
              );
            }),
            const SizedBox(height: 14),
            Text(
              'Data Scientist · AI Architect · Gen AI Expert',
              style: const TextStyle(fontSize: 18, height: 1.4, color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Text(
              'Strategic Data Leader | 22+ yrs in BI, AI/ML & Cloud Data Engineering | Driving business impact with Agentic AI & Generative AI | Delivered \$15M+ value via predictive analytics',
              style: const TextStyle(fontSize: 16, height: 1.4, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Turning Data into Direction, Insights into Impact',
              style: const TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w400, color: Colors.white70, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => widget.onAbout?.call(),
                  icon: const Icon(Icons.person),
                  label: const Text('About me'),
                ),
                OutlinedButton.icon(
                  onPressed: () => widget.onProjects?.call(),
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Projects'),
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
        child: MouseRegion(
          onEnter: (_) => setState(() => _avatarHover = true),
          onExit: (_) => setState(() => _avatarHover = false),
          cursor: SystemMouseCursors.click,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: _avatarHover ? 1.04 : 1.0),
            duration: const Duration(milliseconds: 220),
            builder: (context, scale, child) => Transform.scale(
              scale: scale,
              child: child,
            ),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.03),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Stack(
                  children: [
                    Image.asset(
                      localAsset,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
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
                                color: Colors.grey[900],
                                child: const Center(child: Icon(Icons.person, size: 48, color: Colors.white24)),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    // soft inner vignette for depth
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [Colors.transparent, Colors.white.withOpacity(0.02)],
                            stops: const [0.7, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
          Text('Projects', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
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
        Text(project.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
        Expanded(child: Text(project.description, style: const TextStyle(color: Colors.white70))),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
          Icon(Icons.open_in_new, size: 16, color: Colors.white70),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _sendMail() {
    if (!_formKey.currentState!.validate()) return;

    final to = emailAddress;
    final subject = Uri.encodeComponent(_subjectCtrl.text);
    final bodyText = 'Name: ${_nameCtrl.text}\nEmail: ${_emailCtrl.text}\n\n${_messageCtrl.text}';
    final body = Uri.encodeComponent(bodyText);
    final mailto = 'mailto:$to?subject=$subject&body=$body';

    // Open user's mail client with prefilled message
    html.window.open(mailto, '_self');

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening mail client...')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contact', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => html.window.open('mailto:$emailAddress', '_self'),
            icon: const Icon(Icons.email, color: Colors.white70),
            label: Text(emailAddress, style: const TextStyle(color: Colors.white70)),
          ),
          const SizedBox(height: 12),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Your name (optional)'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'Your email (optional)'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _subjectCtrl,
                  decoration: const InputDecoration(labelText: 'Subject'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a subject' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _messageCtrl,
                  decoration: const InputDecoration(labelText: 'Message'),
                  maxLines: 6,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a message' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _sendMail,
                      icon: const Icon(Icons.send_outlined),
                      label: const Text('Send via email'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                        _nameCtrl.clear();
                        _emailCtrl.clear();
                        _subjectCtrl.clear();
                        _messageCtrl.clear();
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
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

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 2.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('About Me', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
              const SizedBox(height: 14),
              // Lead bold summary (slightly larger, tighter line-height)
              Text(
                'Dynamic and results-driven Sr. Manager – Data & Analytics / Data Science with 22+ years of experience delivering actionable insights, enterprise-scale analytics, and strategic guidance across multi-disciplinary teams.',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, height: 1.34),
              ),
              const SizedBox(height: 16),
              // Proven expertise heading
              Text('Proven expertise in:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 10),
              // Bulleted list
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBullet(context, 'Designing and implementing ', 'enterprise-grade BI solutions', ' (Power BI, SQL-based data pipelines).'),
                  const SizedBox(height: 10),
                  _buildBulletPlain(context, 'Driving adoption of modern data platforms to enable fact-based decision-making.'),
                  const SizedBox(height: 10),
                  _buildBullet(context, 'Leading, mentoring, and developing ', 'high-performing data & AI teams', ' while collaborating with executive stakeholders to shape and execute enterprise data strategies.'),
                ],
              ),
              const SizedBox(height: 18),
              // Paragraph emphasizing data science experience
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white70, height: 1.6, fontSize: 15),
                  children: [
                    const TextSpan(text: 'In addition to analytics, I bring extensive hands-on experience in '),
                    TextSpan(text: 'Data Science and AI/ML practices', style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                    const TextSpan(text: ', having delivered impactful AI projects in predictive modeling, NLP, computer vision, and intelligent automation. My work includes building AI-powered solutions that improve forecasting accuracy, enhance operational efficiency, and unlock new revenue opportunities.'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Agentic AI and Generative AI paragraph
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white70, height: 1.6, fontSize: 15),
                  children: [
                    const TextSpan(text: 'Recently, my focus has extended to '),
                    TextSpan(text: 'Agentic AI systems', style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                    const TextSpan(text: '—autonomous AI agents that optimize workflows and augment human decision-making—and '),
                    TextSpan(text: 'Generative AI innovations', style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                    const TextSpan(text: ', where I actively explore applications in text, image, and code generation to transform business processes and accelerate innovation.'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Closing passionate line
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white70, height: 1.6, fontSize: 15),
                  children: [
                    const TextSpan(text: 'I am passionate about '),
                    TextSpan(text: 'bridging traditional analytics with advanced AI capabilities', style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                    const TextSpan(text: ', continuously exploring how AI and GenAI can elevate user experience, streamline operations, and deliver measurable business impact.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// A more dynamic cloud: absolute-positioned nodes with gentle floating animation
class TechCloud extends StatefulWidget {
  const TechCloud({super.key});

  static const _techs = [
    'Power BI', 'MS Fabric', 'SQL Server', 'Synapse', 'Snowflake', 'Jira', 'AI Models', 'Python', 'PySpark',
    'Power Apps', 'Power Automate', 'Excel', 'Copilot Studio', 'Agentic AI', 'Generative AI', 'SAP',
    'Data Lake', 'MS Dynamics', 'Azure', 'Angular', 'Big Data', 'Data Mining'
  ];

  static const Map<String, String> _assetNameMap = {
    'Power BI': 'powerbi.svg',
    'MS Fabric': 'msfabric.svg',
    'SQL Server': 'sqlserver.svg',
    'Synapse': 'synapse.svg',
    'Snowflake': 'snowflake.svg',
    'Jira': 'jira.svg',
    'AI Models': 'agenticai.svg',
    'Python': 'python.svg',
    'PySpark': 'pyspark.svg',
    'Power Apps': 'powerapps.svg',
    'Power Automate': 'powerautomate.svg',
    'Excel': 'excel.svg',
    'Copilot Studio': 'copilotstudio.svg',
    'Agentic AI': 'agenticai.svg',
    'Generative AI': 'generativeai.svg',
    'SAP': 'sap.svg',
    'Data Lake': 'datalake.svg',
    'MS Dynamics': 'msdynamics.svg',
    'Azure': 'azure.svg',
    'Angular': 'angular.svg',
    'Big Data': 'bigdata.svg',
    'Data Mining': 'datamining.svg',
  };

  // icons are provided via SVG assets in assets/tech/

  @override
  State<TechCloud> createState() => _TechCloudState();
}

class _TechCloudState extends State<TechCloud> with SingleTickerProviderStateMixin {
  final _random = math.Random(1234);
  final _positions = <Offset>[]; // pixel positions
  late final AnimationController _floatController;
  final GlobalKey _key = GlobalKey();
  List<String> _missing = [];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
    // initial positions will be assigned after layout
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializePositions());
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  void _initializePositions() {
    final ctx = _key.currentContext;
    if (ctx == null) return;
    final size = ctx.size ?? Size(800, 320);
    final w = size.width;
    final h = size.height;
    _positions.clear();
    for (var i = 0; i < TechCloud._techs.length; i++) {
      final dx = 0.08 + _random.nextDouble() * 0.84;
      final dy = 0.08 + _random.nextDouble() * 0.84;
      _positions.add(Offset(dx * w, dy * h));
    }
  // run a few relaxation iterations to reduce overlap
  _relaxPositions(w, h);
    // run preflight asset check
    _checkAssets();
  }

  Future<void> _checkAssets() async {
    final missing = <String>[];
    for (var label in TechCloud._techs) {
  final file = 'assets/tech/${TechCloud._assetNameMap[label] ?? label.toLowerCase().replaceAll(' ', '') + '.svg'}';
      try {
        final data = await rootBundle.loadString(file);
        if (data.trim().isEmpty) missing.add(file);
      } catch (_) {
        missing.add(file);
      }
    }
    setState(() {
      _missing = missing;
    });
  }

  void _relaxPositions(double w, double h, {int iterations = 40}) {
    final n = _positions.length;
  final minDist = 82.0; // desired min pixel distance (increased to reduce overlap)
  for (var it = 0; it < iterations; it++) {
      final forces = List.generate(n, (_) => Offset.zero);
      for (var i = 0; i < n; i++) {
        for (var j = i + 1; j < n; j++) {
          final diff = _positions[i] - _positions[j];
          var dist = diff.distance;
          if (dist < 1) dist = 1;
          final overlap = (minDist - dist) / dist;
          if (overlap > 0) {
            final push = diff * (overlap * 0.5);
            forces[i] = forces[i] + push;
            forces[j] = forces[j] - push;
          }
        }
      }
      // apply forces and keep within bounds
      for (var i = 0; i < n; i++) {
        var p = _positions[i] + forces[i] * 0.1; // step (slightly larger)
        p = Offset(p.dx.clamp(8.0, w - 8.0), p.dy.clamp(8.0, h - 8.0));
        // slight pull to center
        final center = Offset(w / 2, h / 2);
  p = Offset(p.dx + (center.dx - p.dx) * 0.0035, p.dy + (center.dy - p.dy) * 0.0035);
        _positions[i] = p;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = 320.0;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),

              // Cloud area — fill remaining vertical space
              Expanded(
                child: Container(
                  key: _key,
                  child: Stack(
                    children: List.generate(TechCloud._techs.length, (i) {
                      final label = TechCloud._techs[i];
                      final assetName = 'assets/tech/${TechCloud._assetNameMap[label] ?? label.toLowerCase().replaceAll(' ', '') + '.svg'}';
                      final pos = i < _positions.length ? _positions[i] : Offset(50.0 + i * 20, 50.0 + i * 8);
                      return Positioned(
                        left: pos.dx,
                        top: pos.dy,
                        child: TechNodeWidget(label: label, assetName: assetName, index: i, float: _floatController),
                      );
                    }),
                  ),
                ),
              ),

              // show missing assets if any
              if (_missing.isNotEmpty) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.06), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.withOpacity(0.18))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Missing assets detected:', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        for (var m in _missing) Text(m, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class TechNodeWidget extends StatefulWidget {
  final String label;
  final String assetName;
  final int index;
  final AnimationController float;
  const TechNodeWidget({super.key, required this.label, required this.assetName, required this.index, required this.float});

  @override
  State<TechNodeWidget> createState() => _TechNodeWidgetState();
}

class _TechNodeWidgetState extends State<TechNodeWidget> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.float.value;
    final phase = (widget.index % 5) + 1;
    final dx = math.sin(2 * math.pi * (t * phase)) * 6.0;
    final dy = math.cos(2 * math.pi * (t * (phase + 0.7))) * 4.0;
    final scale = _hover ? 1.18 : 1.0; // slightly larger hover scale
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: Transform.translate(
        offset: Offset(dx, dy),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 180),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 8, offset: const Offset(0, 3)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // try to load an SVG asset for the tech logo, fall back to a generic icon
                SizedBox(
                  width: 18,
                  height: 18,
                  child: Builder(builder: (ctx) {
                    try {
                      return SvgPicture.asset(
                        widget.assetName,
                        width: 22,
                        height: 22,
                        fit: BoxFit.contain,
                        semanticsLabel: widget.label,
                        placeholderBuilder: (ctx) => const Icon(Icons.bubble_chart, size: 16, color: Colors.white70),
                                                 // colorFilter removed as monochrome handling is dropped
                      );
                    } catch (_) {
                      return const Icon(Icons.bubble_chart, size: 16, color: Colors.white70);
                    }
                  }),
                ),
                const SizedBox(width: 8),
                Text(widget.label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper to build a bullet item with a bold segment in-line
Widget _buildBullet(BuildContext context, String pre, String boldPart, String post) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(top: 2.0, right: 6.0),
        child: Text('•', style: TextStyle(color: Colors.white70, fontSize: 14)),
      ),
      Expanded(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white70, height: 1.45, fontSize: 15),
            children: [
              TextSpan(text: pre),
              TextSpan(text: boldPart, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
              TextSpan(text: post),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildBulletPlain(BuildContext context, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(top: 2.0, right: 6.0),
        child: Text('•', style: TextStyle(color: Colors.white70, fontSize: 14)),
      ),
      Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, height: 1.45, fontSize: 15))),
    ],
  );
}
