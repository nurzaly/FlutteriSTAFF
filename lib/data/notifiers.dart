//ValueNotifier: hold the data
//ValueListenableBuilder: listen to the changes

import 'package:flutter/material.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(3);
ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(true);