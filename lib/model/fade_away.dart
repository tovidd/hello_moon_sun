import 'dart:ui';

class FadeAway {
  final Offset offset;
  final double opacity;

  const FadeAway(this.offset, this.opacity);

  FadeAway operator *(double multiplier) => FadeAway(offset * multiplier, opacity * multiplier);

  FadeAway operator +(FadeAway other) => FadeAway(offset + other.offset, opacity + other.opacity);

  FadeAway operator -(FadeAway other) => FadeAway(offset - other.offset, opacity - other.opacity);
}
