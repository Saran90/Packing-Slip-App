import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:packing_slip_app/features/users/users_controller.dart';
import 'package:packing_slip_app/features/users/widgets/user_item_widget.dart';
import '../../../utils/colors.dart';
import '../../core/widgets/app_button.dart';

class UsersScreen extends StatelessWidget {
  UsersScreen({super.key});

  final _controller = Get.find<UsersController>();
  final textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [appColorGradient1, appColorGradient2],
            begin: Alignment.topLeft,
            stops: [0.5, 1],
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              fit: StackFit.loose,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () => _controller.onBackClicked(),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                'Users',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => _controller.onAddClicked(),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: Obx(
                          () => ListView.builder(
                            itemCount: _controller.users.length,
                            itemBuilder:
                                (context, index) => InkWell(
                                  onTap:
                                      () => _controller.onUserClicked(
                                        _controller.users[index],
                                      ),
                                  child: UserItemWidget(
                                    user: _controller.users[index],
                                    onDeleteClicked:
                                        () => _controller.onItemDeleteClicked(
                                          _controller.users[index],
                                        ),
                                    onAllotClicked:
                                        (user) => _controller
                                            .onAllotSeriesClicked(user),
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: _controller.isLoading.value,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
