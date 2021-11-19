import 'package:fastriver_dev_micro/fast_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shapeWidth = math.min(constraints.biggest.width / 6, 120.0);
        final shapeWWithOffset = shapeWidth * 1.2;
        final columnSize =
            ((constraints.biggest.width) / (shapeWWithOffset * 2)).ceil() * 2;
        final leftPosition = constraints.biggest.width / 2 -
            shapeWWithOffset * columnSize / 2 +
            shapeWidth / 10;
        final rowSize =
            ((constraints.biggest.height) / (shapeWWithOffset * 2)).ceil() * 2;
        final topPosition = constraints.biggest.height / 2 -
            shapeWWithOffset * rowSize / 2 +
            shapeWidth / 10;
        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            ...List.generate(columnSize * rowSize, (index) {
              final rowIndex = index ~/ columnSize;
              final columnIndex = index % columnSize;
              return Positioned(
                top: topPosition + shapeWWithOffset * rowIndex,
                left: leftPosition + shapeWWithOffset * columnIndex,
                child: SizedBox(
                  height: shapeWidth,
                  width: shapeWidth,
                  child: exactShape(rowIndex, columnIndex, rowSize, columnSize,
                      const Color(0xFF80C0E0)),
                ),
              );
            }),
            Align(
              alignment: Alignment(
                  0, -shapeWWithOffset / constraints.biggest.height * 3),
              child: Text(
                "Fastriver.dev",
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Align(
              alignment: Alignment(
                  0, shapeWWithOffset / constraints.biggest.height * 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                      onPressed: () {
                        context.go("/works");
                      },
                      child: const Text(
                        "Works",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  TextButton(
                      onPressed: () {
                        context.go("/profile");
                      },
                      child: const Text(
                        "Profile",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                  TextButton(
                    onPressed: () {
                      showLicensePage(context: context);
                    },
                    child: const Text(
                      "Licences",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("© 2021 fastriver_org"),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  final math.Random random = math.Random();
  Widget randomShape(Color color) {
    final rand = random.nextInt(4);
    final randomTurn = random.nextInt(4);
    switch (rand) {
      case 0:
      case 1:
        return Container(
          color: color,
        );
      case 2:
        return CustomPaint(
          painter: TopRightPainter(color),
        );
      default:
        return RotatedBox(
          quarterTurns: randomTurn,
          child: CustomPaint(
            painter: BottomRightPainter(color),
          ),
        );
    }
  }

  Widget exactShape(
      int row, int column, int rowSize, int columnSize, Color color) {
    final expectedConfirmed = (row == rowSize / 2 || row == rowSize / 2 - 1) &&
        (column == columnSize / 2 || column == columnSize / 2 - 1);
    if (expectedConfirmed) {
      return confirmedShape(
          color, row - rowSize ~/ 2 + 1, column - columnSize ~/ 2 + 1);
    }
    return Opacity(opacity: 0.3, child: randomShape(randomGoodColors()));
  }

  Widget confirmedShape(Color color, int row, int column) {
    assert(row == 0 || row == 1);
    assert(column == 0 || column == 1);
    if (column == 0) {
      return Container(
        color: color,
      );
    }
    if (row == 0) {
      return CustomPaint(
        painter: TopRightPainter(color),
      );
    }
    return CustomPaint(
      painter: BottomRightPainter(color),
    );
  }
}

class TopRightPainter extends CustomPainter {
  final Color color;
  TopRightPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        math.min(size.width / 2, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BottomRightPainter extends CustomPainter {
  final Color color;
  BottomRightPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    // const clipSize = 40.0;
    // final clipSize45 = clipSize / math.sqrt(2);
    // final path2 = Path()
    //   ..moveTo(size.width / 2, size.height / 2)
    //   ..lineTo(size.width - clipSize45, size.height - clipSize45)
    //   ..quadraticBezierTo(
    //       size.width, size.height, size.width - clipSize, size.height)
    //   ..lineTo(clipSize, size.height)
    //   ..quadraticBezierTo(0, size.height, 0, size.height - clipSize)
    //   ..lineTo(0, clipSize)
    //   ..quadraticBezierTo(0, 0, clipSize45, clipSize45)
    //   ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
