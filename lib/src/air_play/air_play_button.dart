part of flutter_cast_video;

final AirPlayPlatform _airPlayPlatform = AirPlayPlatform.instance;

/// Widget that displays the AirPlay button.
class AirPlayButton extends StatelessWidget {
  /// Creates a widget displaying a AirPlay button.
  AirPlayButton(
      {Key? key,
      this.size = 30.0,
      this.color = Colors.black,
      this.activeColor = Colors.white,
      this.onRoutesOpening,
      this.onRoutesClosed,
      this.onPlayerStateChanged})
      : super(key: key);

  /// The size of the button.
  final double size;

  /// The color of the button.
  final Color color;

  /// The color of the button when connected.
  final Color activeColor;

  /// Called while the AirPlay popup is opening.
  final VoidCallback? onRoutesOpening;

  /// Called when the AirPlay popup has closed.
  final VoidCallback? onRoutesClosed;

  final Function? onPlayerStateChanged;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = {
      'red': (color.r * 255.0).round(),
      'green': (color.g * 255.0).round(),
      'blue': (color.b * 255.0).round(),
      'alpha': (color.a * 255.0).round(),
      'activeRed': (activeColor.r * 255.0).round(),
      'activeGreen': (activeColor.g * 255.0).round(),
      'activeBlue': (activeColor.b * 255.0).round(),
      'activeAlpha': (activeColor.a * 255.0).round(),
    };
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return SizedBox(
        width: size,
        height: size,
        child: _airPlayPlatform.buildView(args, _onPlatformViewCreated),
      );
    }
    return SizedBox();
  }

  Future<void> _onPlatformViewCreated(int id) async {
    await _airPlayPlatform.init(id);
    if (onRoutesOpening != null) {
      _airPlayPlatform
          .onRoutesOpening(id: id)
          .listen((_) => onRoutesOpening!());
    }
    if (onRoutesClosed != null) {
      _airPlayPlatform
          .onRoutesClosed(id: id)
          .listen((event) => onRoutesClosed!());
    }
    if (onPlayerStateChanged != null) {
      _airPlayPlatform.isAirplayConnected(id: id).listen((event) {
        onPlayerStateChanged!.call(event.connected);
      });
    }
  }
}
