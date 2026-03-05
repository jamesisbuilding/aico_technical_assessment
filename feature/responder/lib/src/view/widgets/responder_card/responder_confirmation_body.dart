import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class ConfirmationBody extends StatefulWidget {
  final VoidCallback onConfirmationComplete;
  const ConfirmationBody({super.key, required this.onConfirmationComplete});

  @override
  State<ConfirmationBody> createState() => _ConfirmationBodyState();
}

class _ConfirmationBodyState extends State<ConfirmationBody> {
  late VideoPlayerController _videoController;
  bool _isVideoPlayed = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
      'assets/video/home_link_tick.mp4',
      package: 'design_system',
    )..setLooping(false)
     ..initialize().then((_) {
        setState(() {}); // Refresh to show the first frame once initialized
        Future.delayed(const Duration(seconds: 1), () {
          // Play after 1 second delay
          if (mounted) {
            _videoController.play();
            setState(() {
              _isVideoPlayed = true;
            });
            // Listen for completion
            _videoController.addListener(_onVideoUpdate);
          }
        });
      });
  }

  void _onVideoUpdate() {
    if (_videoController.value.position >= _videoController.value.duration &&
        _isVideoPlayed) {
      _isVideoPlayed = false; // Prevent further calls
      _videoController.removeListener(_onVideoUpdate);
      widget.onConfirmationComplete();
    }
  }

  @override
  void dispose() {
    _videoController.removeListener(_onVideoUpdate);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Thank you for your update!',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(color: AppTheme.primary),
          ),

          ClipOval(
            child: SizedBox(
              height: 78,
              width: 78,
              child: _videoController.value.isInitialized
                  ? Container(
                      height: 78,
                      color: Colors.red,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Transform.scale(
                          scale: 1.17,
                          child: VideoPlayer(_videoController),
                        ),
                      ),
                    )
                  : Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
