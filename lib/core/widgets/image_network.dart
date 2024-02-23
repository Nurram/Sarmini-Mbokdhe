import '../../core_imports.dart';

class CustomImageNetwork extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final double? radius;
  final BoxFit fit;

  const CustomImageNetwork({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.radius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width ?? 115,
        height: height ?? 115,
        fit: fit,
        placeholder: (context, url) => const SizedBox(
          width: 40,
          height: 40,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
