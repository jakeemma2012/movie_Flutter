import 'package:flutter/material.dart';
import 'package:movieappprj/Screen/Login_Screen.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<String> _bannerImages = [];
  PageController? _pageController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            if (_pageController != null && _bannerImages.isNotEmpty)
              Positioned.fill(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: _bannerImages.length,
                  itemBuilder: (context, index) {
                    return Image.asset(_bannerImages[index], fit: BoxFit.cover);
                  },
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: _button_login_register(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initAnimationController();
    _loadBannerImages();
    _animationController.repeat(reverse: true);
  }

  void _initAnimationController() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _button_login_register(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text(
              'Đăng nhập / Đăng ký',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadBannerImages() async {
    try {
      final manifestContent = await DefaultAssetBundle.of(
        context,
      ).loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      _bannerImages =
          manifestMap.keys
              .where((String key) => key.contains('assets/images/banner/'))
              .where((String key) {
                final extension = key.toLowerCase();
                return extension.endsWith('.jpg') ||
                    extension.endsWith('.png') ||
                    extension.endsWith('.webp');
              })
              .toList();

      setState(() {
        _initPageController();
      });
    } catch (e) {
      print('Error loading banner images: $e');
    }
  }

  void _initPageController() {
    if (_pageController != null) {
      _pageController?.dispose();
    }
    _pageController = PageController();
    _startImageSlideshow();
  }

  void _startImageSlideshow() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _pageController != null && _bannerImages.isNotEmpty) {
        if (_currentIndex == _bannerImages.length - 1) {
          _pageController!.animateToPage(
            0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController!.nextPage(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
          );
        }
        _startImageSlideshow();
      }
    });
  }
}
