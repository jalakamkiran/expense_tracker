import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FormState extends Equatable {
  final String name;
  final Color color;
  final IconData icon;
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;

  const FormState({
    required this.name,
    required this.color,
    required this.icon,
    required this.isSubmitting,
    required this.isSuccess,
    this.error,
  });

  factory FormState.initial() => const FormState(
    name: '',
    color: Colors.blue,
    icon: Icons.category,
    isSubmitting: false,
    isSuccess: false,
    error: null,
  );

  FormState copyWith({
    String? name,
    Color? color,
    IconData? icon,
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
  }) {
    return FormState(
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }

  @override
  List<Object?> get props => [name, color, icon, isSubmitting, isSuccess, error];
}