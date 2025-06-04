import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Varsha B S - Portfolio',
      theme: ThemeData(
        primaryColor: Color(0xFF2D3436),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF2D3436),
          secondary: Color(0xFF0984E3),
          surface: Colors.white,
          background: Color(0xFFF5F6FA),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: PortfolioScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PortfolioScreen extends StatefulWidget {
  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    children: [
                      _buildHeader(constraints.maxWidth),
                      _buildAboutSection(),
                      _buildSkillsSection(),
                      _buildExperienceSection(),
                      _buildProjectsSection(),
                      _buildEducationSection(),
                      _buildContactSection(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double maxWidth) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: maxWidth,
      child: Stack(
        children: [
          // Floating elements
          Positioned(
            top: 50,
            right: 30,
            child: _buildFloatingIcon(Icons.flutter_dash, 60),
          ),
          Positioned(
            top: 120,
            left: 40,
            child: _buildFloatingIcon(Icons.phone_android, 40),
          ),
          Positioned(
            bottom: 100,
            right: 60,
            child: _buildFloatingIcon(Icons.code, 50),
          ),
          // Main content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MouseRegion(
                      onEnter: (_) => setState(() => isHovered = true),
                      onExit: (_) => setState(() => isHovered = false),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        transform: Matrix4.identity()
                          ..scale(isHovered ? 1.1 : 1.0),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/Varsha_passportsize1.jpg'),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Varsha B S',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Mobile Application Enthusiast',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildContactButton(Icons.phone, '9497578746'),
                        SizedBox(width: 20),
                        _buildContactButton(Icons.email, 'varshabahuleyan@gmail.com'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(IconData icon, double size) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 10 * _animationController.value),
          child: Icon(
            icon,
            size: size,
            color: Colors.white.withOpacity(0.1),
          ),
        );
      },
    );
  }

  Widget _buildContactButton(IconData icon, String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          if (icon == Icons.phone) {
            final Uri phoneUri = Uri(scheme: 'tel', path: text);
            if (await canLaunchUrl(phoneUri)) {
              await launchUrl(phoneUri);
            }
          } else if (icon == Icons.email) {
            final Uri emailUri = Uri(scheme: 'mailto', path: text);
            if (await canLaunchUrl(emailUri)) {
              await launchUrl(emailUri);
            }
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text(
                text.length > 20 ? '${text.substring(0, 15)}...' : text,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Me',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667eea),
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Passionate Flutter Developer with hands-on experience in building user-focused, responsive mobile applications. Proficient in Flutter/Dart, Android SDK, RESTful APIs, and Firebase services. Experienced in delivering pixel-perfect UIs, integrating backend services, and ensuring high app performance across devices.',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technical Skills',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          _buildSkillCategory('Languages', ['Dart', 'Kotlin']),
          SizedBox(height: 15),
          _buildSkillCategory('Mobile Development', ['Flutter', 'Android SDK']),
          SizedBox(height: 15),
          _buildSkillCategory('Backend & APIs', ['RESTful API', 'Firebase', 'MongoDB']),
          SizedBox(height: 15),
          _buildSkillCategory('Tools', ['Android Studio', 'Git', 'Figma']),
        ],
      ),
    );
  }

  Widget _buildSkillCategory(String title, List<String> skills) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667eea),
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) => _buildSkillChip(skill)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        skill,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildExperienceSection() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Experience',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          _buildExperienceCard(
            'Flutter Developer Intern',
            'Reubro International',
            'Jan - May 2025',
            [
              'Developed EasyLoan app with full UI/UX, Firebase backend',
              'Implemented real-time Firestore DB and Firebase Storage',
              'Integrated Firebase Auth for seamless authentication',
              'Created EMI Calculator and dynamic loan workflows',
            ],
          ),
          SizedBox(height: 15),
          _buildExperienceCard(
            'Flutter Developer Intern',
            'Weberfox Technologies Pvt Ltd',
            'May - July 2024',
            [
              'Built Orddar app end-to-end with Flutter frontend',
              'Strengthened skills in widget-based UI development',
              'Focused on API integration and state management',
              'Ensured cross-device compatibility',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(String title, String company, String duration, List<String> achievements) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667eea),
            ),
          ),
          SizedBox(height: 5),
          Text(
            company,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 5),
          Text(
            duration,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 15),
          ...achievements.map((achievement) => Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: Color(0xFF667eea), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    achievement,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Projects',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          _buildProjectCard(
            'EasyLoan App',
            'The Loan Application is a mobile-based solution developed using Flutter that aims to streamline the process of applying for various types of loans. It provides a clean and user-friendly interface for customers to submit loan requests and enables administrators to manage and process those requests efficiently. The application is divided into two main modules – User Module and Admin Module.',
            ['Flutter', 'Firebase', 'Firestore', 'Authentication'],
            Icons.account_balance,
          ),
          SizedBox(height: 15),
          _buildProjectCard(
            'News App',
            'A modern news application that keeps you updated with the latest headlines. Features include a personalized news feed, article bookmarking, and dark mode support. Users can search for specific topics, save articles for later reading, and enjoy a clean, intuitive interface that works seamlessly across different themes.',
            ['Flutter', 'REST API', 'Getx', 'Shared Preferences', 'Dark Mode'],
            Icons.newspaper,
          ),
          SizedBox(height: 15),
          _buildProjectCard(
            'Orddar App',
            'Orddar is a dynamic and efficient delivery boy application designed to streamline the delivery process, ensuring timely and accurate deliveries. application is completely built in MVC pattern. ',
            ['Flutter', 'REST API', 'Provider', 'Figma'],
            Icons.shopping_cart,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String title, String description, List<String> technologies, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF667eea),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: technologies.map((tech) => Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF667eea).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tech,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF667eea),
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationSection() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Education',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          _buildEducationCard(
            'M.Voc in Software Application Development',
            'Cochin University of Science & Technology',
            '2023 - 2025',
            Icons.school,
          ),
          SizedBox(height: 15),
          _buildEducationCard(
            'B.Voc in Software Application Development',
            'KSMDB College, Sasthamcotta',
            '2020 - 2023',
            Icons.school,
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard(String degree, String institution, String duration, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  degree,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF667eea),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  institution,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  duration,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Let\'s Connect!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667eea),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildContactIcon(Icons.phone, '9497578746'),
              _buildContactIcon(Icons.email, 'varshabahuleyan@gmail.com'),
              _buildContactIcon(Icons.link, 'LinkedIn Profile'),
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showContactDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF667eea),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Get In Touch',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactIcon(IconData icon, String label) {
    return GestureDetector(
      onTap: () => _copyToClipboard(label),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(height: 8),
          Text(
            label.length > 10 ? '${label.substring(0, 8)}...' : label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard!'),
        backgroundColor: Color(0xFF667eea),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phone: 9497578746'),
              SizedBox(height: 10),
              Text('Email: varshabahuleyan@gmail.com'),
              SizedBox(height: 10),
              Text('LinkedIn: linkedin.com/in/varshabahuleyan'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}