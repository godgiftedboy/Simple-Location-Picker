class StepItemEntity {
  final String label;
  final bool isCompleted;
  StepItemEntity({
    required this.label,
    required this.isCompleted,
  });

  StepItemEntity copyWith({
    String? label,
    bool? isCompleted,
  }) {
    return StepItemEntity(
      label: label ?? this.label,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
