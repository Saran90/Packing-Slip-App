import 'package:flutter/material.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/icon_text_field.dart';
import '../../../utils/colors.dart';
import '../models/user.dart';
import 'allot_series_controller.dart';

class AllotSeriesWidget extends StatefulWidget {
  AllotSeriesWidget({super.key, this.user});

  final User? user;

  @override
  State<AllotSeriesWidget> createState() => _AllotSeriesWidgetState();
}

class _AllotSeriesWidgetState extends State<AllotSeriesWidget> {
  final controller = AllotSeriesController();

  @override
  void initState() {
    controller.setUser(widget.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          gradient: LinearGradient(
            colors: [appColorGradient1, appColorGradient2],
            begin: Alignment.topLeft,
            stops: [0.5, 1],
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        height: 500,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Allot Series',
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                IconTextField(
                  controller: controller.nameController,
                  hint: 'Enter name',
                  textInputType: TextInputType.text,
                  whiteBackground: false,
                  label: 'Name',
                  isEnabled: false,
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => controller.onBillDateClicked(context),
                  child: IconTextField(
                    controller: controller.billDateController,
                    hint: 'Enter bill date',
                    textInputType: TextInputType.text,
                    whiteBackground: false,
                    label: 'Bill Date',
                    isEnabled: false,
                    suffixIcon: 'assets/icons/ic_calendar.png',
                  ),
                ),
                const SizedBox(height: 10),
                IconTextField(
                  controller: controller.seriesController,
                  hint: 'ABC, PQR,..',
                  textInputType: TextInputType.text,
                  whiteBackground: false,
                  label: 'Series',
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: AppButton(
                  label: 'Save',
                  onSubmit: controller.onSaveClicked,
                  startColor: appColorGradient1,
                  endColor: appColorGradient2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
