import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:tripin/controllers/friend_controller.dart';

class AppFriend extends StatelessWidget {
  const AppFriend({
    Key? key,
    required this.future,
    required this.image,
    required this.nickName,
    required this.message,
    required this.color,
    required this.style,
  }) : super(key: key);

  final Future<String?> future;
  final Image image;
  final String nickName;
  final String message;
  final Color color;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: FutureBuilder<String?>(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // 로딩 중 처리
                        return CircularProgressIndicator(); // 예시로 로딩 스피너 표시
                      } else if (snapshot.hasError) {
                        return Text('오류 발생: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Image(image: AssetImage('assets/icons/chat_default.png'))),
                          ));
                      } else {
                        return AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey,
                              ),
                              child: image,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(nickName, style: style,),
                ),
              ],
            ),
          ),
          Visibility(
            visible: message.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              Container(
                width: MediaQuery.of(context).size.width / 2.5,
                height: MediaQuery.of(context).size.height / 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(80),
                    bottom: Radius.circular(80),
                  ),
                  border: Border.all(color: color),
                ),
                child: Center(
                  child: Text(message, style: TextStyle(color: color),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
