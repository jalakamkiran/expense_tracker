import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum FormType { category, label }

abstract class FormEvent extends Equatable {
  const FormEvent();

  @override
  List<Object?> get props => [];
}


class NameChanged extends FormEvent {
  final String name;
  const NameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class ColorChanged extends FormEvent {
  final Color color;
  const ColorChanged(this.color);

  @override
  List<Object?> get props => [color];
}

class IconChanged extends FormEvent {
  final IconData icon;
  const IconChanged(this.icon);

  @override
  List<Object?> get props => [icon];
}

class SubmitForm extends FormEvent {
  const SubmitForm();
}
