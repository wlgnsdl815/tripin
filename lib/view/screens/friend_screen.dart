import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/friend_controller.dart';

class FriendScreen extends GetView<FriendController> {
  const FriendScreen({super.key});
  static const route = '/friend';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AspectRatio(
                        aspectRatio: 1/1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(37),
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      Text(controller.editProfileController.nickNameController.text,),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 18,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(80),
                            bottom: Radius.circular(80)),
                        border: Border.all(color: Colors.black)),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Text('친구'),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  color: Colors.lightBlue,
                  height: MediaQuery.of(context).size.height / 3,
                  child: Column(
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Icon(Icons.close),
                          ),
                          Text('친구 추가'),
                        ],
                      ),
                      TextField(
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {}, icon: Icon(Icons.search)),
                            filled: true,
                            hintText: '이메일로 친구 검색',
                            contentPadding: EdgeInsets.all(10),
                            border: InputBorder.none),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

