import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movieappprj/Models/Movie.dart';
import 'package:movieappprj/Services/DatabaseService.dart';
import 'package:movieappprj/Utils/constants.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
List<Movie> nowShowing = [];
List<Movie> popular = [];

  @override
  void initState() {
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
  final dark = Util.isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: dark ? Colors.black : Colors.white,

        appBar: _AppBar_Widget(),

        body: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),

                _Title_showing_and_button_See_all(dark),

                const SizedBox(height: 10),

                _image_NowShowing(dark),

                const SizedBox(height: 10),

                _Title_Pupular_and_See_all(dark),

                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 30,
                      height: MediaQuery.of(context).size.height + 70,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              print("Tapped index : $index");
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              "assets/images/banner/movie_logo.png",
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Positioned(
                                    top: 0,
                                    left: 130,
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width -
                                          200, //
                                      child: Column(
                                        children: [
                                          Text(
                                            "Spiderman : No Way Home No Way Home No Way Home",
                                            style: TextStyle(
                                              color: dark ? Colors.white : Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              height: 1.2,
                                            ),
                                          ),

                                          Row(
                                            children: [
                                              Icon(
                                                Iconsax.star1,
                                                color: Colors.amber,
                                                size: 20,
                                              ),

                                              Text(
                                                "4.5/10",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: dark ? Colors.white : Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 10),

                                          Wrap(
                                            alignment: WrapAlignment.start,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.start,
                                            spacing: 6,
                                            runSpacing: 8,
                                            children: [
                                              _buildGenreChip("HORROR"),
                                              _buildGenreChip("MYSTERY"),
                                              _buildGenreChip("THRILLER"),
                                            ],
                                          ),

                                          const SizedBox(height: 8),

                                          Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                size: 20,
                                                color: dark ? Colors.white : Colors.grey[600],
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "1h 47m",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: dark ? Colors.white : Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenreChip(String genre) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        genre,
        style: TextStyle(color: Colors.blue[700], fontSize: 10),
      ),
    );
  }

  Row _Title_Pupular_and_See_all(bool dark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Popular",
          style: GoogleFonts.merriweather(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: dark ? Colors.white : Util.TitleColor,
          ),
        ),

        // ignore: sized_box_for_whitespace
        Container(
          height: 30,
          width: 90,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "See All",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Column _image_NowShowing(bool dark) {
    return Column(
      children: [
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print("Tapped index : $index");
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 230,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey,
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/banner/movie_logo.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: 140,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            "Spiderman : No Way Home",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: dark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Icon(Iconsax.star1, color: Colors.amber),
                          Text(
                            "4.5/10",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Row _Title_showing_and_button_See_all(bool dark) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Text(
          "Now Showing",
          style: GoogleFonts.merriweather(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: dark ? Colors.white : Util.TitleColor,
          ),
        ),

        // ignore: sized_box_for_whitespace
        Container(
          height: 30,
          width: 90,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "See All",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  AppBar _AppBar_Widget() {
    return AppBar(
      title: Text(
        'Home Page',
        style: GoogleFonts.merriweather(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Util.TitleColor,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          //  SimpleHiddenDrawerController.of(context).toggle();
        },
        icon: Icon(Iconsax.menu_board, color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Iconsax.notification, color: Colors.black),
        ),
      ],
    );
  }


}
