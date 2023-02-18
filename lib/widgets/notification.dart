import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';

void showElegantNotification(String title, String description, IconData icon, Color color, BuildContext context) {
  return ElegantNotification(
    title: Text(title),
    description: Text(description),
    icon: Icon(
      icon,
      color: color,
    ),
    progressIndicatorColor: color,
  ).show(context);
}
