import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/playlist_page.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'buildRow.dart';

class BuildList extends StatelessWidget {
  final bool showProgress;
  final Color colorRowIcon;

  //The lisToShow might be causing error. See constructor.

  BuildList({
    this.showProgress,
    this.colorRowIcon: Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Color(0xFF54BEE6),
      ),
      color: Colors.white,
      opacity: 1,
      inAsyncCall: showProgress,
      child: listToShow.length > 0
          ? ListView.builder(
              itemCount: listToShow.length + 1,
              itemBuilder: (context, i) {
                return i != 0
                    ? BuildRow(
                        currentSong: listToShow[i - 1],
                        color: colorRowIcon,
                      )
                    : CarouselSlider(
                        options: CarouselOptions(
                          height: 100,
                          viewportFraction: 0.9,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                        ),
                        items: playlistList.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlaylistPage(i),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black,
                                        i.color,
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      i.title,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Pacifico',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      );
              })
          : Container(
              padding: EdgeInsets.only(
                top: 30,
                left: 10,
              ),
              child: Text(
                'No Songs Available for the filter. Apply other filter or search something else.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
    );
  }
}
