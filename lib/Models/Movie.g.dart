// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Movie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieAdapter extends TypeAdapter<Movie> {
  @override
  final int typeId = 0;

  @override
  Movie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movie(
      movieId: fields[0] as int,
      title: fields[1] as String,
      rating: fields[2] as double,
      overview: fields[3] as String,
      genres: fields[4] as String,
      status: fields[5] as String,
      studio: fields[6] as String,
      director: fields[7] as String,
      movieCast: (fields[8] as List).cast<String>(),
      releaseYear: fields[9] as int,
      imageUrl: fields[10] as String,
      videoUrl: fields[11] as String?,
      duration: fields[13] as int,
      backdropUrl: fields[12] as String,
      trailerUrl: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.movieId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.overview)
      ..writeByte(4)
      ..write(obj.genres)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.studio)
      ..writeByte(7)
      ..write(obj.director)
      ..writeByte(8)
      ..write(obj.movieCast)
      ..writeByte(9)
      ..write(obj.releaseYear)
      ..writeByte(10)
      ..write(obj.imageUrl)
      ..writeByte(11)
      ..write(obj.videoUrl)
      ..writeByte(12)
      ..write(obj.backdropUrl)
      ..writeByte(13)
      ..write(obj.duration)
      ..writeByte(14)
      ..write(obj.trailerUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
