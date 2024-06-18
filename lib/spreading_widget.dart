import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import "dart:math";

/// A stack widget to spread its children as a set of cards and display them as scrollable row on tap.
///
/// The center of the spread can be specified by [centerOfSpread].
/// [spreadableCardWidth] and [spreadableCardHeight] are the width and height respectively of each child widget when aligning to be spread.
/// [spreadAngleBetweenConsecutiveWidgets] is the angle in radians from the positive x-axis in the clockwise direction, Negative angle values rotate the widgets anticlockwise.
/// The width and height of each card when displayed as a member of a row can be specified with [cardWidth] and [cardHeight] respectively.

class SpreadingWidget extends StatefulWidget {
  SpreadingWidget(
      {required this.children,
      required this.spreadAngleBetweenConsecutiveWidgets,
      required this.centerOfSpread,
      required this.spreadWidgetsCount,
      required this.spreadableCardHeight,
      required this.spreadableCardWidth,
      required this.cardHeight,
      required this.cardWidth,
      this.horizontalPadding = 10,
      this.originalRotationAngle = 0.0,
      this.maxRotationAngle,
      required super.key});

  final List<Widget> children;
  final double spreadAngleBetweenConsecutiveWidgets;
  final Alignment centerOfSpread;
  final int spreadWidgetsCount;
  final double spreadableCardHeight;
  final double spreadableCardWidth;
  final double cardWidth;
  final double cardHeight;
  final double originalRotationAngle;
  final double? maxRotationAngle;
  late final double horizontalPadding;

  @override
  State<SpreadingWidget> createState() => _SpreadingWidgetState();
}

class _SpreadingWidgetState extends State<SpreadingWidget>
    with TickerProviderStateMixin {
  late List<Widget> widgetsToBeSpread;
  late double spreadAngleBetweenConsecutiveWidgets;
  late Alignment centerOfSpread;
  late int spreadWidgetsCount;
  late double spreadableCardWidth;
  late double spreadableCardHeight;
  late double cardWidth;
  late double cardHeight;
  late double originalRotationAngle;
  late double maxRotationAngle;

  late AnimationController spreadAnimationController;
  late AnimationController dragAnimationController;
  bool areSpreadingWidgetsSpreadable = true;
  late double rotationAngle = originalRotationAngle;
  late double horizontalPadding;
  late double extraWidth;
  late double extraHeight;

  late double totalHeight;

  late double totalWidth;

  @override
  void initState() {
    spreadAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    dragAnimationController = AnimationController(
        duration: const Duration(milliseconds: 8), vsync: this);
    widgetsToBeSpread = widget.children;
    super.initState();
  }

  Offset deltaParallelComponent(Offset distance, Offset delta) {
    var data = Offset.fromDirection(distance.direction) *
        ((distance.dx * delta.dx + distance.dy * delta.dy) / distance.distance);
    return data;
  }

  Offset deltaPerpendicularComponent(Offset distance, Offset delta) {
    var data = delta - deltaParallelComponent(distance, delta);
    return data;
  }

  void increaseRotationAngle(Offset offsetFromRotationCenter, Offset delta) {
    double angle =
        deltaPerpendicularComponent(offsetFromRotationCenter, delta).distance /
            (offsetFromRotationCenter.distance) *
            (-deltaPerpendicularComponent(offsetFromRotationCenter, delta)
                .direction
                .sign);
    rotationAngle += angle;
  }

  void changeWidgetOrder() {
    widgetsToBeSpread.add(widgetsToBeSpread[0]);
    widgetsToBeSpread.removeAt(0);
  }

  void toggleSpreadable() {
    if (areSpreadingWidgetsSpreadable) {
      spreadAnimationController.reset();
    } else {
      spreadAnimationController.forward();
    }
    areSpreadingWidgetsSpreadable = !areSpreadingWidgetsSpreadable;
  }

  @override
  Widget build(BuildContext context) {
    spreadAngleBetweenConsecutiveWidgets =
        widget.spreadAngleBetweenConsecutiveWidgets;
    centerOfSpread = widget.centerOfSpread;
    spreadWidgetsCount = widget.spreadWidgetsCount;
    spreadableCardHeight = widget.spreadableCardHeight;
    spreadableCardWidth = widget.spreadableCardWidth;
    cardWidth = widget.cardWidth;
    cardHeight = widget.cardHeight;
    originalRotationAngle = widget.originalRotationAngle;
    maxRotationAngle = (widget.maxRotationAngle == null || maxRotationAngle < 0)
        ? spreadAngleBetweenConsecutiveWidgets
        : widget.maxRotationAngle!;
    horizontalPadding = widget.horizontalPadding;
    extraWidth = List.generate(
        spreadWidgetsCount,
        (i) =>
            sin(i * spreadAngleBetweenConsecutiveWidgets).abs() *
            spreadableCardHeight).reduce(max);
    extraHeight = List.generate(
        spreadWidgetsCount,
        (i) =>
            sin((i) * spreadAngleBetweenConsecutiveWidgets).abs() *
            spreadableCardWidth).reduce(max);

    totalHeight = areSpreadingWidgetsSpreadable
        ? extraHeight + spreadableCardHeight
        : cardHeight;

    totalWidth = areSpreadingWidgetsSpreadable
        ? extraWidth + spreadableCardWidth
        : widgetsToBeSpread.length * cardWidth +
            horizontalPadding * (widgetsToBeSpread.length - 1);
    return VisibilityDetector(
        key: const ValueKey('spreading widget'),
        onVisibilityChanged: (visibilityInfo) {
          if (!areSpreadingWidgetsSpreadable) {
            spreadAnimationController.reset();
            return;
          }
          bool hasReachedSpreadableVisibilityFraction =
              visibilityInfo.visibleFraction > 0.2;
          if (hasReachedSpreadableVisibilityFraction) {
            spreadAnimationController.forward();
          } else {
            spreadAnimationController.reset();
          }
        },
        child: SingleChildScrollView(
            physics: areSpreadingWidgetsSpreadable
                ? const NeverScrollableScrollPhysics()
                : const ScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    toggleSpreadable();
                  });
                },
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    color: Colors.transparent,
                    height: totalHeight,
                    width: totalWidth,
                    child: Stack(
                        children: List.generate(
                            widgetsToBeSpread.length,
                            (i) => AnimatedPositioned(
                                duration: const Duration(milliseconds: 500),
                                left: areSpreadingWidgetsSpreadable
                                    ? horizontalPadding
                                    : (widgetsToBeSpread.length - 1 - i) *
                                        (cardWidth + horizontalPadding),
                                child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width: areSpreadingWidgetsSpreadable
                                        ? spreadableCardWidth
                                        : cardWidth,
                                    height: areSpreadingWidgetsSpreadable
                                        ? spreadableCardHeight
                                        : cardHeight,
                                    child: RotationTransition(
                                        turns: Tween(
                                                begin: 0.0,
                                                end: i >
                                                        widgetsToBeSpread.length -
                                                            1 -
                                                            spreadWidgetsCount
                                                    ? (spreadAngleBetweenConsecutiveWidgets /
                                                            (2 * pi)) *
                                                        (widgetsToBeSpread
                                                                .length -
                                                            i -
                                                            1)
                                                    : (spreadWidgetsCount - 1) *
                                                        (spreadAngleBetweenConsecutiveWidgets /
                                                            (2 * pi)))
                                            .animate(spreadAnimationController),
                                        alignment: centerOfSpread,
                                        child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onPanUpdate: (details) {
                                              setState(() {
                                                Offset rotationCenterOffset =
                                                    Offset(centerOfSpread.x,
                                                        centerOfSpread.y);
                                                Offset
                                                    offsetFromRotationCenter =
                                                    details.localPosition -
                                                        rotationCenterOffset;
                                                increaseRotationAngle(
                                                    offsetFromRotationCenter,
                                                    details.delta);
                                              });
                                            },
                                            onPanEnd: (details) {
                                              setState(() {
                                                if (rotationAngle.abs() >=
                                                    maxRotationAngle.abs()) {
                                                  changeWidgetOrder();
                                                }
                                                rotationAngle = 0;
                                              });
                                            },
                                            child: AnimatedBuilder(
                                                animation:
                                                    dragAnimationController,
                                                child: widgetsToBeSpread[
                                                    (widgetsToBeSpread.length -
                                                        i -
                                                        1)],
                                                builder: (context, child) {
                                                  return Transform.rotate(
                                                      angle: i ==
                                                              widgetsToBeSpread
                                                                      .length -
                                                                  1
                                                          ? rotationAngle
                                                          : 0,
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: child);
                                                })))))))))));
  }
}
