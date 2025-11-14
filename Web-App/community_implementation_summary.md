# Resumen de la Implementación del Servicio de Comunidad (Flutter)

## Arquitectura por Capas

| Capa | Responsabilidad | Elementos Clave |
| --- | --- | --- |
| **Presentation** | Controladores Riverpod + estados inmutables para orquestar casos de uso y exponer datos listos para UI. | `CommunityController`, `PostController`, `FeedController`, `ReactionController`, `SubscriptionController` y estados asociados. |
| **Application** | Casos de uso que encapsulan reglas de negocio y orquestan repositorios. | 20+ use cases (`GetAllCommunitiesUseCase`, `CreatePostUseCase`, `GetUserFeedUseCase`, etc.). |
| **Domain** | Entidades puras, contratos de repositorio y objetos de request/paginación. | `Community`, `Post`, `FeedEntry`, `Reaction`, `Subscription`, `PaginatedResult`, `CreatePostRequest`, `PaginationQuery`, etc. |
| **Infrastructure** | Data sources HTTP y repositorios REST que transforman JSON ↔️ entidades. | `CommunityRemoteDataSource`, `PostRemoteDataSource`, `PaginatedResponseDto`, `RestPostRepository`, etc. |
| **Shared** | Utilidades comunes para networking y errores. | `BaseService`, `ApiException`, `Environment`. |

Esta separación sigue SOLID (repositorios dependen de interfaces, controladores dependen de abstracciones) y facilita pruebas unitarias o reemplazo por data sources locales cuando sea necesario.

## Conexión a Servicios/BD

La comunicación con la API de comunidad (equivalente a la BD) se centraliza en los *remote data sources*, cada uno heredando de `BaseService`:

```dart
final response = await client.get(
  buildUri(Environment.postsEndpoint, queryParameters: {'page': '0'}),
  headers: authorizedHeaders(token),
);
ensureSuccess(response);
```

- `BaseService.buildUri` acepta query params para soportar paginación y filtros.
- `authorizedHeaders` añade `Bearer token` + `Content-Type` homogéneo.
- `ensureSuccess` lanza `ApiException` con status y body para diagnósticos.

Cada data source convierte el JSON crudo en DTOs tipados (`CommunityDto`, `PostDto`, `PaginatedResponseDto`) antes de proyectarlo al dominio, garantizando que cualquier cambio en la estructura HTTP quede aislado.

## Estructura de Requests

Para estandarizar payloads se definieron objetos de request en `lib/community/domain/requests/`:

- `CreateCommunityRequest`, `UpdateCommunityRequest` → nombre, descripción, imagen.
- `CreatePostRequest` → `communityId`, `content`, `imageUrl?`.
- `CommunityPostsQuery`, `FeedPostsQuery`, `UserFeedQuery` → wrappers para parámetros paginados/offset.
- `CreateReactionRequest` → `userId`, `postId`, `ReactionType`.
- `CreateSubscriptionRequest`, `SubscriptionByUserQuery`.
- `PaginationQuery` (page/size) y `OffsetQuery` (limit/offset).

Los repositorios reciben estos objetos en lugar de mapas dinámicos, forzando payloads válidos y testeables. Ejemplo de flujo al crear un post:

1. UI llama `PostController.createPost(CreatePostRequest(...))`.
2. El `CreatePostUseCase` reenvía el request al `PostRepository`.
3. `RestPostRepository` delega en `PostRemoteDataSource.createPost`, que serializa el DTO y realiza el `POST /api/v1/posts`.

## Endpoints Cubiertos

| Dominio | Use Cases / Métodos | Endpoint REST |
| --- | --- | --- |
| Comunidades | Crear, listar, detalle, por creador, actualizar, eliminar. | `POST/GET/PUT/DELETE /api/v1/communities`, `/communities/creator/{id}` |
| Posts | Todos, por comunidad (paginado), por usuario, feed (offset), crear, eliminar. | `/api/v1/posts`, `/posts/community/{id}`, `/posts/feed/{userId}` |
| Feed enriquecido | `FeedController` consume `/api/v1/feed/{userId}` → `FeedEntry` con comunidad + reacciones agregadas. | `/feed/{userId}` |
| Reacciones | Crear (like default), listar por post, eliminar. | `/reactions/user/{userId}/post/{postId}`, `/reactions/post/{postId}` |
| Suscripciones | Crear, eliminar, listar por comunidad, listar por usuario (paginado), helper `user+community`. | `/subscriptions`, `/subscriptions/{id}`, `/subscriptions/community/{id}`, `/subscriptions/user/{userId}` |

Cada respuesta se normaliza vía DTOs y `PaginatedResponseDto` para manejar APIs que devuelvan `items`, `content` o `data`.

## Controladores Riverpod

- **CommunityController**: maneja loading vs processing, sincroniza listas globales y del creador, y permite invalidar `selectedCommunity` al eliminar.
- **PostController**: soporta múltiples contextos (todos, comunidad, usuario, feed) y mantiene un `PaginatedResult` para reutilizar la paginación en UI.
- **Feed/Reaction/Subscription controllers**: proveen cachés por `postId` o `communityId`, exponen helpers como `checkUserSubscriptionForCommunity` y encapsulan lógica de error.

Todos consumen `authControllerProvider` para derivar token/usuario, evitando que la capa UI pase credenciales explícitamente.

## Buenas Prácticas Aplicadas

1. **SRP y DIP**: los controllers sólo orquestan use cases; los repositorios dependen de interfaces y se inyectan vía providers.
2. **DTOs + Entities**: separación clara entre estructuras HTTP y objetos de dominio para asegurar type-safety.
3. **Error Handling**: `ApiException` centraliza mensajes y status codes, mejorando la trazabilidad entre UI y backend.
4. **Inmutabilidad**: estados (`CommunityState`, `PostState`, etc.) son inmutables y exponen `copyWith` con overrides para limpiar secciones específicas.
5. **Extensibilidad**: al añadir otro backend (p.ej. WebSocket), basta con crear un nuevo data source y proveerlo en los repositorios sin tocar presentation.
6. **Request Builders**: todos los endpoints usan objetos de request/quey que documentan los campos requeridos/opcionales (incluyendo `PaginationQuery` y `OffsetQuery`).

## Próximos Pasos Recomendados

- Añadir pruebas unitarias para cada use case y controller usando `ProviderContainer` + `http.Client` mockeado.
- Integrar perfiles reales para obtener `ownerProfileId` desde el servicio de perfiles.
- Exponer mecanismos de *cache-first* en controladores si el backend soporta ETags/If-None-Match.
- Añadir logging estructurado (e.g., interceptores) al `http.Client` compartido.

Con esta estructura, el módulo de comunidad en Flutter replica la funcionalidad descrita para la Web-App, manteniendo una conexión robusta con la API (BD) y asegurando que cada request siga un contrato tipado y reutilizable.
