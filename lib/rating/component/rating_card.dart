import 'package:codefactory/common/const/colors.dart';
import 'package:codefactory/rating/model/rating_model.dart';
import 'package:flutter/material.dart';

class RatingCard extends StatelessWidget {
  final String email;
  final int rating;
  final String content;
  final List<Image> images;
  final ImageProvider avatarImage;

  const RatingCard({
    required this.email,
    required this.rating,
    required this.content,
    required this.images,
    required this.avatarImage,
    super.key,
  });

  factory RatingCard.fromModel({required RatingModel model}) {
    return RatingCard(
      email: model.user.username,
      rating: model.rating,
      content: model.content,
      images: model.imgUrls.map((e) => Image.network(e)).toList(),
      avatarImage: NetworkImage(model.user.imageUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          email: email,
          avatarImage: avatarImage,
          rating: rating,
        ),
        const SizedBox(height: 8.0),
        _Body(
          content: content,
        ),
        const SizedBox(height: 8.0),
        if (images.isNotEmpty)
          SizedBox(
            height: 100,
            child: _Images(
              images: images,
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final String email;
  final int rating;
  final ImageProvider avatarImage;

  const _Header({
    required this.email,
    required this.rating,
    required this.avatarImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: avatarImage,
          radius: 12.0,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(
          5,
          (index) => Icon(
            index >= rating ? Icons.star_border : Icons.star,
            color: PRIMARY_COLOR,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: const TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images
          .asMap()
          .map(
            (index, element) => MapEntry(
              index,
              Padding(
                padding: EdgeInsets.only(
                    right: index == images.length - 1 ? 0 : 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: element,
                ),
              ),
            ),
          )
          .values
          .toList(),
    );
  }
}
