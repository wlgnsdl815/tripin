import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';

class FriendScreen extends GetView<AuthController> {
  const FriendScreen({super.key});
  static const route = '/friend';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구'),
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
                            hintText: '닉네임/이메일로 친구 검색',
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
