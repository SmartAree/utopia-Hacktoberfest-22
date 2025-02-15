import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/UserProfileScreen/user_profile_screen.dart';

class BoxForLikeNotification extends StatelessWidget {
  final String notifierDp;
  final String articleId;
  final String notifierName;
  final String notifierId;
  final Timestamp time;
  bool read;

  BoxForLikeNotification(
      {super.key,
      required this.notifierDp,
      required this.notifierName,
      required this.articleId,
      required this.notifierId,
      required this.read,
      required this.time});

  String myUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    RichText title = RichText(
        text: TextSpan(children: [
      TextSpan(
          text: notifierName,
          style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3)),
      const TextSpan(
          text: " liked your article",
          style: TextStyle(
              fontSize: 13.2, color: Colors.black54, letterSpacing: 0.35)),
    ]));
    String createdOn = timeago.format(time.toDate());
    List<String> initials = notifierName.split(" ");
    String firstLetter = "", lastLetter = "";

    if (initials.length == 1) {
      firstLetter = initials[0].characters.first;
    } else {
      firstLetter = initials[0].characters.first;
      lastLetter = initials[1].characters.first;
    }
    return ListTile(
      // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayArticleScreen(article: article, author: author),)),
      leading: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(userId: notifierId),
            )),
        child: (notifierDp.isEmpty)
            ? Container(
                height: 40,
                width: 35,
                color: authMaterialButtonColor,
                child: Center(
                  child: initials.length > 1
                      ? Text(
                          "$firstLetter.$lastLetter".toUpperCase(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )
                      : Text(
                          firstLetter.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                ),
              )
            : CachedNetworkImage(
                imageUrl: notifierDp,
                fit: BoxFit.fitWidth,
                height: 45,
                width: 40,
              ),
      ),
      title: Padding(
          padding: const EdgeInsets.only(bottom: 4.0, top: 4), child: title),
      subtitle: Row(
        children: [
          Text(
            createdOn,
            style: const TextStyle(
                fontSize: 11.5,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontFamily: "Open"),
          ),
          SizedBox(
            width: displayWidth(context) * 0.05,
          ),
          (!read)
              ? Image.asset(
                  newNotification,
                  height: 30,
                )
              : const SizedBox(),
        ],
      ),
      trailing: SizedBox(
        height: 25,
        width: 28,
        child: Consumer<MyArticlesController>(
          builder: (context, controller, child) {
            if (controller.fetchingMyArticleStatus == FetchingMyArticle.nil) {
              controller.fetchMyArticles(myUid);
            }
            switch (controller.fetchingMyArticleStatus) {
              case FetchingMyArticle.nil:
                return Image.asset(notificationLikeIcon,
                    height: 25, fit: BoxFit.cover);
              case FetchingMyArticle.fetching:
                return Image.asset(notificationLikeIcon,
                    height: 25, fit: BoxFit.cover);
              case FetchingMyArticle.fetched:
                Article thisArticle = controller.publishedArticles
                    .firstWhere((element) => element.articleId == articleId);
                String? imagePreview;

                imagePreview = thisArticle.body.firstWhere(
                    (element) => element['type'] == "image")['image'];
            
                return (imagePreview != null)
                    ? CachedNetworkImage(
                        imageUrl: imagePreview, height: 25, fit: BoxFit.cover)
                    : Image.asset(defaultArticleImage,
                        height: 25, fit: BoxFit.cover);
            }
          },
        ),
      ),
    );
  }
}
