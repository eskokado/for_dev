import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:test/test.dart';

import 'package:fordev/data/http/http_client.dart';
import 'package:fordev/data/usecases/remote_authentication.dart';
import 'package:fordev/domain/usecases/authentication.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpsUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct value', () async {
    final params = AuthenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );
    await sut.auth(params);

    verify(await httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.secret},
    ));
  });
}
