import 'package:flutter/material.dart';
import 'package:simple_location_picker/multistep-form/step_item.dart';
import 'package:simple_location_picker/multistep-form/step_item_entity.dart';

class MultiStepForm extends StatefulWidget {
  const MultiStepForm({super.key});

  @override
  State<MultiStepForm> createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  int currentStep = 0;
  final ScrollController _scrollController = ScrollController();
  double stepWidth = 65;

  List<StepItemEntity> steps = [
    StepItemEntity(label: "General", isCompleted: false),
    StepItemEntity(label: "Personal", isCompleted: false),
    StepItemEntity(label: "Family", isCompleted: false),
    StepItemEntity(label: "Address", isCompleted: false),
    StepItemEntity(label: "Bank", isCompleted: false),
    StepItemEntity(label: "Occupation", isCompleted: false),
    StepItemEntity(label: "Nominee", isCompleted: false),
    StepItemEntity(label: "AML", isCompleted: false),
    StepItemEntity(label: "Documents", isCompleted: false),
    StepItemEntity(label: "Agreement", isCompleted: false),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToStep(int index, {bool isForward = false}) {
    ///To maintain the currently selected index/step to center
    if (isForward) {
      if (index <= 2) return;
    }

    // Calculate absolute target offset
    final targetOffset = (index - 2) * stepWidth;

    // Clamp to scroll range
    final clampedOffset = targetOffset.clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  ///Logic to Goto to next step
  void gotoNextStep() {
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
      });
      _scrollToStep(currentStep, isForward: true);
    }
  }

  ///Logic to Goto to next step
  void gotoPrevStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _scrollToStep(currentStep);
    }
  }

  void markComplete(int index) {
    ///Logic to complete the step (State comparision required for checking completion)
    setState(() {
      steps[index] = steps[index].copyWith(isCompleted: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 50, // fixed height for step row
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    final e = steps[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentStep = index;
                        });
                        _scrollToStep(index);
                      },
                      child: SizedBox(
                        width: stepWidth,
                        child: StepItem(
                          label: e.label,
                          isCompleted: e.isCompleted,
                          isCurrent: index == currentStep,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text("Step $currentStep"),
              ),
              ElevatedButton(
                onPressed: gotoNextStep,
                child: const Text("Next Step"),
              ),
              ElevatedButton(
                onPressed: gotoPrevStep,
                child: const Text("Prev Step"),
              ),

              ///Mark current step as completed - Demo implementation for markComplete function.
              ElevatedButton(
                onPressed: () {
                  markComplete(currentStep);
                },
                child: const Text("Complete Current Step"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
