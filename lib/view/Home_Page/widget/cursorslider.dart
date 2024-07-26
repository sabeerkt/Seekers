import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSliderComponent extends StatelessWidget {
  final Function(String, int) onImageTap;

  ImageSliderComponent({Key? key, required this.onImageTap}) : super(key: key);

  final List<String> homeData = [
    "https://cdn.pixabay.com/photo/2015/06/19/21/24/avenue-815297_640.jpg",
    "https://www.w3schools.com/howto/img_5terre.jpg",
    "https://d38b044pevnwc9.cloudfront.net/cutout-nuxt/enhancer/2.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png",
  ];

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController();

    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CarouselSlider(
                carouselController: carouselController,
                items: homeData.asMap().entries.map(
                  (entry) {
                    int index = entry.key;
                    String imagePath = entry.value;
                    return GestureDetector(
                      onTap: () => onImageTap(imagePath, index),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return Image.asset("assets/logo.png");
                          },
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ).toList(),
                options: CarouselOptions(
                  viewportFraction: 1,
                  height: MediaQuery.of(context).size.height * 0.48,
                  autoPlay: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      carouselController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(.5),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      carouselController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(.5),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}