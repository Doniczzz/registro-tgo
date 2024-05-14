import 'package:flutter/material.dart';

// Asumiendo que estas son las definiciones de colores, ajusta según tu configuración real.
const primaryColor = Color(0xFF32519E);
const Color disableColor = Colors.grey;
const Color enableColor = Colors.white;

// ignore: must_be_immutable
class MainButtons extends StatefulWidget {
  final String title;
  final Function()? onTap;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  bool loading;
  bool enabled;
  final bool underlined;
  final bool filled;
  final bool link;
  final bool small;
  final bool fullWidth;

  MainButtons({
    super.key,
    required this.title,
    this.onTap,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.loading = false,
    this.enabled = true,
    this.underlined = false,
    this.filled = true,
    this.link = false,
    this.small = false,
    this.fullWidth = false,
  });

  @override
  State<MainButtons> createState() => _MainButtonsState();
}

class _MainButtonsState extends State<MainButtons> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.enabled && widget.onTap != null) {
          setState(() {
            widget.loading = true;
            widget.enabled = false;
          });

          await widget.onTap!();

          setState(() {
            widget.loading = false;
            widget.enabled = true;
          });
        }
      },
      child: FittedBox(
        fit: BoxFit.none,
        child: AnimatedContainer(
          width:
              widget.fullWidth ? MediaQuery.of(context).size.width - 20 : null,
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12.0),
          decoration: BoxDecoration(
            color: widget.enabled
                ? (widget.filled
                    ? widget.backgroundColor ?? primaryColor
                    : Colors.transparent)
                : (widget.filled
                    ? widget.backgroundColor ?? disableColor
                    : Colors.transparent),
            borderRadius:
                widget.underlined ? null : BorderRadius.circular(10.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: widget.icon,
                ),
              Text(
                widget.loading ? '' : widget.title,
                style: TextStyle(
                  color: widget.enabled
                      ? widget.textColor ?? Colors.white
                      : Colors.white, // Text color for disabled state
                  fontWeight: FontWeight.bold,
                  fontSize: widget.small ? 14 : 18,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.loading)
                AnimatedContainer(
                  height: 15,
                  width: 15,
                  margin: const EdgeInsets.only(left: 12.0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: widget.loading ? 1 : 0,
                    curve: Curves.easeInOut,
                    child: const CircularProgressIndicator(
                        color: primaryColor, strokeWidth: 3.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final bool enabled;
  final bool fullWidth;
  final bool small;
  final Color? backgroundColor;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.title,
    this.onTap,
    this.enabled = true,
    this.fullWidth = false,
    this.small = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return MainButtons(
      title: title,
      enabled: enabled,
      onTap: onTap,
      fullWidth: fullWidth,
      small: small,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }
}
