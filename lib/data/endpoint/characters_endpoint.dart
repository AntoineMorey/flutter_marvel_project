import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:marvel_app/data/client/dio_client.dart';
import 'package:marvel_app/data/dto/response_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'characters_endpoint.g.dart';

@RestApi(parser: Parser.JsonSerializable)
@injectable
abstract class CharacterEndpoint {
  @factoryMethod
  factory CharacterEndpoint(DioClient dio) {
    return _CharacterEndpoint(dio);
  }

  @GET("/characters")
  Future<ResponseDto> getCharacters({@Query("offset") int offset = 0, @Query("limit") int limit = 20});

  @GET("/characters/{id}")
  Future<ResponseDto> getCharacterById(@Path("id") int id);

  @GET("/characters/{id}/comics")
  Future<ResponseDto> getCharacterComics(@Path("id") int id);
}
