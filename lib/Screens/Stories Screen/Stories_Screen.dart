import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../Classes ( New ) Section/Create_New_Stories_Class.dart';
import '../../Navigation Section/Home Page Section/Primary Components/Display User Stories/Display_User_Story_Img.dart';

class StoryScreen extends StatefulWidget {
  final String userid;
  final List<dynamic> storylist;

  const StoryScreen({
    super.key,
    required this.userid,
    required this.storylist,
  });

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late ChewieController _chewieController;
  late AnimationController _animationController;
  late VideoPlayerController _videoPlayerController;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    for (var element in widget.storylist) {
      element.onViewed(widget.userid);
    }

    _pageController = PageController();
    _animationController = AnimationController(vsync: this);

    final Stories firstStory = widget.storylist.first;
    _loadStory(story: firstStory, animateToPage: false);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _animationController.reset();
        setState(() {
          if (_currentIndex + 1 < widget.storylist.length) {
            _currentIndex += 1;
            _loadStory(story: widget.storylist[_currentIndex]);
          } else {
            Navigator.pop(context);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _animationController.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Stories storyfirst = widget.storylist[_currentIndex];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTapDown: (details) => _ontapDown(details, storyfirst),
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.storylist.length,
                itemBuilder: (context, i) {
                  final Stories story = widget.storylist[i];

                  switch (story.storyMediaType) {
                    case 'Image':
                      return PhotoDisplayScreen(
                          size: size, userId: widget.userid, story: story);

                    case 'Video':
                      _videoPlayerController = VideoPlayerController.networkUrl(
                        Uri.parse(story.storyMediaUrl),
                      );

                      if (_videoPlayerController.value.isInitialized) {
                        return FittedBox(
                          fit: BoxFit.cover,
                          child: Chewie(controller: _chewieController),
                        );
                      }
                  }
                  return const SizedBox.shrink();
                },
              ),
              Positioned(
                top: 10.0,
                left: 10.0,
                right: 10.0,
                child: Column(
                  children: [
                    Row(
                      children: widget.storylist
                          .asMap()
                          .map((i, e) {
                            return MapEntry(
                              i,
                              animatedBar(
                                animationController: _animationController,
                                position: i,
                                currentIndex: _currentIndex,
                              ),
                            );
                          })
                          .values
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ontapDown(TapDownDetails details, Stories story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          _loadStory(story: widget.storylist[_currentIndex]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < widget.storylist.length) {
          _currentIndex += 1;
          _loadStory(story: widget.storylist[_currentIndex]);
        } else {
          Navigator.pop(context);
        }
      });
    } else {
      if (story.storyMediaType == 'Video') {
        if (_videoPlayerController.value.isPlaying) {
          _videoPlayerController.pause();
          _animationController.stop();
        } else {
          _videoPlayerController.play();
          _animationController.forward();
        }
      }
    }
  }

  void _loadStory({required Stories story, bool animateToPage = true}) {
    _animationController.stop();
    _animationController.reset();

    switch (story.storyMediaType) {
      case 'Image':
        _animationController.duration = const Duration(seconds: 6);
        _animationController.forward();

        break;

      case 'Video':
        _videoPlayerController.dispose();

        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(story.storyMediaUrl),
        )..initialize();

        setState(() {});

        if (_videoPlayerController.value.isInitialized) {
          _animationController.duration = _videoPlayerController.value.duration;
          _videoPlayerController.play();
          _animationController.forward();
        }

        break;
    }

    if (animateToPage) {
      _pageController.animateToPage(_currentIndex,
          duration: const Duration(milliseconds: 1), curve: Curves.easeOut);
    }
  }
}

class animatedBar extends StatelessWidget {
  final AnimationController animationController;
  final int position;
  final int currentIndex;

  const animatedBar(
      {super.key,
      required this.animationController,
      required this.position,
      required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 1.5,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildcontainer(
                  double.infinity,
                  position < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                        animation: animationController,
                        builder: (context, child) {
                          return _buildcontainer(
                            constraints.maxWidth * animationController.value,
                            Colors.white,
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildcontainer(double width, Color color) {
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}
