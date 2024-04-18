import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../components/Layout/Layout.dart';
import '../shared/SearchBar.dart' as custom;
import '../components/Image-Gallery/MasonryImagesGallery.dart';
import '../components/Testimonial/Testimonial.dart';
import '../shared/Newsletter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;
  late Timer _timer;
  int _currentPage = 0;
  final Color primaryColor =
      Color.fromARGB(255, 228, 89, 24); // Color principal

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/hero-video.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _currentPage = (_currentPage + 1) % 3;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      bodyContent: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: custom.SearchBar(),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                initialPage: _currentPage,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
              items: [
                Image.asset('assets/images/hero-img01.webp', fit: BoxFit.cover),
                VideoPlayerWidget(controller: _controller),
                Image.asset('assets/images/hero-img02.webp', fit: BoxFit.cover),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white, // Un fondo para destacar el texto
              child: Text(
                'Descubre el mundo con nosotros',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 28, // Tamaño más grande para más visibilidad
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8), // Espacio antes de las Testimonios
            Testimonials(),
            SizedBox(height: 8), // Espacio antes de Newsletter
            Newsletter(),
            SizedBox(height: 16), // Espacio antes de la galería de imágenes
            MasonryImagesGallery(),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoPlayerWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            )
          : Container(),
    );
  }
}
