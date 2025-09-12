part of flutter_cast_video;

/// Callback method for when the button is ready to be used.
///
/// Pass to [ChromeCastButton.onButtonCreated] to receive a [ChromeCastController]
/// when the button is created.
typedef OnButtonCreated = void Function(ChromeCastController controller);

typedef OnPlayerStatusUpdated = void Function(int statusCode);

/// Callback method for when a request has failed.
typedef void OnRequestFailed(String? error);

/// Widget that displays the ChromeCast button.
class ChromeCastButton extends StatelessWidget {
  /// Creates a widget displaying a ChromeCast button.
  ChromeCastButton({
    Key? key,
    this.size = 70.0,
    this.color = Colors.black,
    this.onButtonCreated,
    this.onSessionStarted,
    this.onSessionEnded,
    this.onRequestCompleted,
    this.onRequestFailed,
    this.onPlayerStatusUpdated,
  })  : assert(
            defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android,
            '$defaultTargetPlatform is not supported by this plugin'),
        super(key: key);

  /// The size of the button.
  final double size;

  /// The color of the button.
  /// This is only supported on iOS at the moment.
  final Color color;

  /// Callback method for when the button is ready to be used.
  ///
  /// Used to receive a [ChromeCastController] for this [ChromeCastButton].
  final OnButtonCreated? onButtonCreated;

  /// Called when a cast session has started.
  final VoidCallback? onSessionStarted;

  /// Called when a cast session has ended.
  final VoidCallback? onSessionEnded;

  /// Called when a cast request has successfully completed.
  final VoidCallback? onRequestCompleted;

  /// Called when a cast request has failed.
  final OnRequestFailed? onRequestFailed;

  /// Called when player status updated
  final OnPlayerStatusUpdated? onPlayerStatusUpdated;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = {
      'red': (color.r * 255.0).round(),
      'green': (color.g * 255.0).round(),
      'blue': (color.b * 255.0).round(),
      'alpha': (color.a * 255.0).round()
    };
    return SizedBox(
      width: size,
      height: size,
      child: _chromeCastPlatform.buildViewHybrid(args, _onPlatformViewCreated),
    );
  }

  Future<void> _onPlatformViewCreated(int id) async {
    final ChromeCastController controller = await ChromeCastController.init(id);

    onButtonCreated?.call(controller);

    _chromeCastPlatform.onSessionStarted(id: id).listen((_) {
      onSessionStarted?.call();
    });

    _chromeCastPlatform.onSessionEnded(id: id).listen((_) {
      onSessionEnded?.call();
    });

    _chromeCastPlatform.onRequestCompleted(id: id).listen((_) {
      onRequestCompleted?.call();
    });

    _chromeCastPlatform.onRequestFailed(id: id).listen((event) {
      onRequestFailed?.call(event.error);
    });

    _chromeCastPlatform.onPlayerStatusUpdated(id: id).listen((event) {
      onPlayerStatusUpdated?.call(event.status);
    });
  }
}
