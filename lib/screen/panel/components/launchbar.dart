import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:kitshell/etc/component/custom_inkwell.dart';
import 'package:kitshell/etc/component/panel_enum.dart';
import 'package:kitshell/etc/component/text_icon.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/appmenu/appmenu_bloc.dart';
import 'package:kitshell/logic/screen_manager/screen_manager_bloc.dart';
import 'package:kitshell/screen/panel/panel.dart';
import 'package:kitshell/screen/screen_manager.dart';

class LaunchBar extends HookWidget {
  const LaunchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      get<AppmenuBloc>().add(AppmenuLoad(t.locale));
      return () {};
    }, []);

    return Row(
      children: [AppmenuButton()],
    );
  }
}

class AppmenuButton extends HookWidget {
  const AppmenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    return CustomInkwell(
      onTap: () {
        get<ScreenManagerBloc>().add(
          ScreenManagerEventOpenPopup(
            popupToShow: PopupWidget.appMenu,
            position: InheritedAlignment.of(context).position,
          ),
        );
        get<AppmenuBloc>().add(AppmenuLoad(t.locale));
      },
      onPointerEnter: (_) => isHovered.value = true,
      onPointerExit: (_) => isHovered.value = false,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Iconify(
        Bi.box_seam,
        color: isHovered.value
            ? context.colorScheme.primary
            : context.colorScheme.onSurface,
      ),
    );
  }
}
