import 'package:flutter/material.dart';

void main() {
  runApp(RanchoBlancoTourApp());
}

class RanchoBlancoTourApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TabNavigator(),
    );
  }
}

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _goToTab(int index) {
    if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _openPageDialog(String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text("This is a placeholder for the $title page."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Image.asset('assets/logo.png', height: 40),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => _goToTab(0),
          ),
          ListTile(
            leading: Icon(Icons.vrpano),
            title: Text('Virtual Tour'),
            onTap: () => _goToTab(1),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About Us'),
            onTap: () => _goToTab(2),
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text('Contact Us'),
            onTap: () => _openPageDialog("Contact Us"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isFirstTab = _currentIndex == 0;

    return Scaffold(
      drawer: isFirstTab ? null : _buildDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: !isFirstTab,
        iconTheme: IconThemeData(color: Colors.white),
        title: Image.asset('assets/logo.png', height: 40),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HowToNavigateScreen(onStartTour: () => _goToTab(1)),
          VirtualTourScreen(),
          AboutUsScreen(),
        ],
      ),
    );
  }
}

// ─────────────── How to Navigate Screen ───────────────
class HowToNavigateScreen extends StatelessWidget {
  final VoidCallback onStartTour;

  HowToNavigateScreen({required this.onStartTour});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InteractiveViewer(
          maxScale: 2.5,
          minScale: 1.0,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withAlpha(204), // 0.8 * 255 = ~204
                  BlendMode.darken,
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: 120),
                Text("How to Navigate",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 10),
                Text("Swipe to the left, right, up or down to\nlook around.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGestureColumn('assets/swipe_left.png', 'Swipe\nLeft'),
                    _buildGestureColumn('assets/swipe_right.png', 'Swipe\nRight'),
                  ],
                ),
                SizedBox(height: 30),
                Text("Use two fingers to enlarge or reduce\nthe size of the image on the screen.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGestureColumn('assets/zoom_in.png', 'Spread\nZoom In'),
                    _buildGestureColumn('assets/zoom_out.png', 'Pinch\nZoom Out'),
                  ],
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 102, 9, 9),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  onPressed: onStartTour,
                  child: Text('Start Tour', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGestureColumn(String imagePath, String label) {
    return Column(
      children: [
        Image.asset(imagePath, width: 60, height: 60),
        SizedBox(height: 10),
        Text(label, textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}

// ─────────────── Virtual Tour Screen ───────────────
class VirtualTourScreen extends StatefulWidget {
  @override
  _VirtualTourScreenState createState() => _VirtualTourScreenState();
}

class _VirtualTourScreenState extends State<VirtualTourScreen> {
  final List<Map<String, String>> thumbnails = [
    {'image': 'assets/place1.png', 'label': 'Capsule House Front'},
    {'image': 'assets/place2.png', 'label': 'Capsule House Side'},
    {'image': 'assets/place3.png', 'label': 'Gazebo Marina'},
  ];

  String selectedImage = 'assets/place1.png';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
            color: Colors.black.withAlpha(153), // 0.6 * 255 = 153
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      selectedImage,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[900],
                        child: Center(
                          child: Icon(Icons.broken_image, color: Colors.red, size: 60),
                        ),
                      ),
                    ),
                  ),
                  Positioned(top: 40, left: 20, child: _dot()),
                  Positioned(top: 40, right: 20, child: _dot()),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, color: Colors.white),
                SizedBox(width: 16),
                Icon(Icons.info_outline, color: Colors.white),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text("1/12", style: TextStyle(color: Colors.white)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: thumbnails.length,
                itemBuilder: (context, index) {
                  final item = thumbnails[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImage = item['image']!;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              item['image']!,
                              width: 120,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 120,
                                height: 60,
                                color: Colors.grey[800],
                                child: Center(
                                  child: Icon(Icons.broken_image, color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            item['label']!,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ],
    );
  }

  Widget _dot() => Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      );
}

// ─────────────── About Us Screen ───────────────
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/farm.jpg',
            fit: BoxFit.cover,
            color: Colors.black.withAlpha(76), // 0.3 * 255 = ~76
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/dates.jpg',
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 220,
                    color: Colors.black.withAlpha(102),
                  ),
                  const Text(
                    'About Us',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cursive',
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Rancho Blanco Event Center and Dates Farm is a scenic destination in Batangas City that offers a unique experience combining agriculture and leisure.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Originally established as a date palm farm, Rancho Blanco has evolved into a charming venue for events, tours, and farm-based learning activities.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'The ranch is home to Khalas date palms, one of the finest varieties known for their sweetness and rich taste. Visitors can learn about date cultivation and enjoy serene farm landscapes.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
