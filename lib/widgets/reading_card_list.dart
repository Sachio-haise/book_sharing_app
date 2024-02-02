import 'package:book_sharing_app/widgets/book_rating.dart';
import 'package:book_sharing_app/widgets/consttants.dart';
import 'package:book_sharing_app/widgets/two_side_rounded_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ReadingListCard extends StatelessWidget {
  final String image;
  final String title;
  final String auth;
  final int rating;
  final Function pressDetails;
  final Function pressRead;

  const ReadingListCard({
    Key? key,
    required this.image,
    required this.title,
    required this.auth,
    required this.rating,
    required this.pressDetails,
    required this.pressRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        margin: const EdgeInsets.only(left: 24, bottom: 40),
        height: 245,
        width: 202,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,

              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(29),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 10),
                      blurRadius: 33,
                      color: kShadowColor,
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
              child: CachedNetworkImage(
                imageUrl: image,
                width: 202,
                height: 150, // Set the height to match the container
                fit: BoxFit.cover, // Adjust the fit property as needed
                errorWidget: (_, __, ___) {
                  return const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 160,
              child: SizedBox(
                height: 85,
                width: 202,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: RichText(
                        maxLines: 2,
                        text: TextSpan(
                          style: const TextStyle(color: kBlackColor),
                          children: [
                            TextSpan(
                              text: "$title\n",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: auth,
                              style: const TextStyle(
                                color: kLightBlackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: pressDetails as void Function()?,
                          child: Container(
                            width: 101,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            // child: const Text("Details"),
                          ),
                        ),
                        Expanded(
                          child: TwoSideRoundedButton(
                            text: "Details",
                            press: pressDetails as void Function(),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  }
}
