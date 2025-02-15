import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/profile_detail_box.dart';
import 'package:utopia/view/screens/FollowersScreen/followers_screen.dart';
import 'package:utopia/view/screens/FollowingScreen/following_screen.dart';
import 'package:utopia/view/screens/ProfileScreen/components/edit_profile_dialogbox.dart';

class ProfileOverView extends StatelessWidget {
  final space = const SizedBox(height: 10);
  final verticalSpace = VerticalDivider(
    indent: 12,
    endIndent: 12,
    thickness: 0.5,
    color: Colors.grey.shade400,
    width: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, controller, child) {
        return Column(
          children: [
            Text(
              controller.user!.name,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: "Fira",
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              controller.user!.email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12.5,

                  // fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
            space,
            controller.user!.bio.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Text(
                      controller.user!.bio,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54),
                    ),
                  )
                : const SizedBox(),
            controller.user!.bio.isNotEmpty ? space : const SizedBox(),
            SizedBox(
              width: displayWidth(context) * 0.35,
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(6),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
                  backgroundColor: MaterialStateProperty.all(authBackground),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return EditProfileDialogbox(
                          currentName: controller.user!.name,
                          currentBio: controller.user!.bio);
                    },
                  );
                },
                child: Text(
                  "Edit Profile",
                  style: TextStyle(
                      fontFamily: "",
                      letterSpacing: 0.4,
                      color: Colors.white.withOpacity(0.85)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: displayHeight(context) * 0.1,
              // color: Colors.blue.shade100,
              width: displayWidth(context),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileDetailBox(
                      value: controller.user!.following.length,
                      label: "Following",
                      callback: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FollowingScreen(user: controller.user!),
                          ))),
                  verticalSpace,
                  ProfileDetailBox(
                      value: controller.user!.followers.length,
                      label: "Followers",
                      callback: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FollowersScreen(user: controller.user!),
                          ))),
                  verticalSpace,
                  ProfileDetailBox(
                      value: 0, label: "Articles", callback: () => null),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
