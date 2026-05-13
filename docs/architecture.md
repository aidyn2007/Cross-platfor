# Architecture — Functions & Widgets

This document is a structural map of the **Yummy** Flutter application (an
online bookstore). It is derived from the actual source under `lib/` and is
intended to be read as the counterpart of the ER diagram from the previous
assignment: every entity in the ER diagram appears here as a Dart class, and
the widget tree shows where each entity is rendered.

All diagrams below are written in [Mermaid](https://mermaid.live) — GitHub
renders them automatically in the file preview, and you can also paste any of
them into <https://mermaid.live> to export PNG/SVG.

---

## 1. Layered overview

```mermaid
flowchart LR
    subgraph Domain["Domain models (ER entities)"]
        direction TB
        Bookstore
        Book
        BookCategory
        Post
        User
        CartItem
        Order
        Message
        CatalogBook["Book (catalog)"]
        BookTag
    end

    subgraph State["State / managers / DAOs"]
        direction TB
        CartManager
        OrderManager
        YummyAuth
        AppCache
        UserDao
        MessageDao
        MemoryRepository
        MockYummyService
    end

    subgraph Network["Network (Chopper services)"]
        direction TB
        ServiceInterface
        GoogleBooksService
        SpoonacularService
    end

    subgraph UI["UI (widgets / screens)"]
        direction TB
        Yummy
        LoginPage
        Home
        ExplorePage
        BookList
        LibraryPage
        MyOrdersPage
        AccountPage
        ChatPage
        BookstorePage
        CheckoutPage
        BookDetailsPage
        BookView
        Bookmarks
        GroceryList
    end

    UI --> State
    State --> Domain
    UI --> Network
    Network --> Domain
```

---

## 2. Entity-relationship class diagram

This is the Dart-class translation of the ER diagram. Multiplicities mirror the
ER relationships (1 — N, N — M).

```mermaid
classDiagram
    direction LR

    class Bookstore {
        +String id
        +String name
        +String address
        +String attributes
        +String imageUrl
        +double distance
        +double rating
        +List~Book~ items
        +getRatingAndDistance() String
    }

    class Book {
        +String name
        +String description
        +double price
        +String imageUrl
    }

    class BookCategory {
        +String name
        +int numberOfBookstores
        +String imageUrl
    }

    class Post {
        +String id
        +String profileImageUrl
        +String comment
        +String timestamp
    }

    class User {
        +String firstName
        +String lastName
        +String role
        +String profileImageUrl
        +int points
        +bool darkMode
    }

    class CartItem {
        +String id
        +String name
        +double price
        +int quantity
        +totalCost() double
    }

    class Order {
        +Set~int~ selectedSegment
        +TimeOfDay selectedTime
        +DateTime selectedDate
        +String name
        +List~CartItem~ items
        +totalPrice() double
        +getFormattedSegment() String
        +getFormattedTime() String
        +getFormattedDate() String
        +getFormattedOrderInfo() String
    }

    class Message {
        +DateTime date
        +String email
        +String text
        +DocumentReference reference
        +fromJson(Map) Message
        +toJson() Map
        +fromSnapshot(DocumentSnapshot) Message
    }

    class CatalogBook["Book (catalog)"] {
        +int id
        +String sourceId
        +String label
        +String image
        +String description
        +bool bookmarked
        +List~BookTag~ tags
        +copyWith(...) Book
    }

    class BookTag {
        +int id
        +int bookId
        +String name
        +double amount
        +copyWith(...) BookTag
    }

    Bookstore "1" *-- "many" Book : sells
    Order "1" *-- "many" CartItem : line items
    CatalogBook "1" *-- "many" BookTag : tagged with
    BookTag "many" --> "1" CatalogBook : bookId
    User "1" --> "many" Post : authors
    User "1" --> "many" Message : sends
    User "1" --> "many" Order : places
    Bookstore "many" --> "1" BookCategory : classified by
```

> **Mapping to the ER diagram**
>
> | ER entity         | Dart class                              |
> | ----------------- | --------------------------------------- |
> | Bookstore         | `Bookstore` (`lib/models/bookstore.dart`)|
> | Catalog item      | `Book` (`lib/models/bookstore.dart`)    |
> | Genre / Category  | `BookCategory`                          |
> | User              | `User` + `UserDao` record               |
> | Post / Feed item  | `Post`                                  |
> | Cart line         | `CartItem`                              |
> | Order             | `Order`                                 |
> | Chat message      | `Message`                               |
> | Book (library)    | `Book` (`lib/data/models/book.dart`)    |
> | Tag               | `BookTag`                               |

Note: there are two `Book` classes in the codebase that live in different
namespaces — `lib/models/bookstore.dart` defines the lightweight catalog item
shown inside a bookstore, while `lib/data/models/book.dart` defines the richer
entity returned by the Google Books / Spoonacular search APIs and persisted in
the in-memory library. They are intentionally separated because they have
different fields (`price`/`imageUrl` vs `sourceId`/`bookmarked`/`tags`).

---

## 3. State, services and DAOs

These classes own application state and mediate between widgets and the data
sources (Firebase, in-memory mock, Chopper REST services, SharedPreferences).

```mermaid
classDiagram
    direction TB

    class YummyAuth {
        -bool _loggedIn
        -AppCache _appCache
        +loggedIn Future~bool~
        +signIn(username, password) Future~bool~
        +signOut() Future~void~
    }

    class AppCache {
        +invalidate() Future~void~
        +cacheUser() Future~void~
        +isUserLoggedIn() Future~bool~
    }

    class UserDao {
        -FirebaseAuth auth
        +isLoggedIn() bool
        +userId() String
        +email() String
        +signup(email, password) Future~String~
        +login(email, password) Future~String~
        +logout() void
    }

    class MessageDao {
        +UserDao userDao
        +CollectionReference collection
        +sendMessage(text) void
        +getMessageStream() Stream~List~Message~~
    }

    class CartManager {
        -List~CartItem~ _items
        -DeliveryMode _mode
        -DateTime _timeOfPickupOrDelivery
        +addItem(item) void
        +removeItem(id) void
        +resetCart() void
        +itemAt(index) CartItem
        +totalCost double
        +setMode(mode) void
        +setTime(time) void
    }

    class OrderManager {
        -List~Order~ _orders
        +addOrder(order) void
        +removeOrder(order) void
        +totalOrders int
    }

    class MemoryRepository {
        +findAllBooks() Future~List~Book~~
        +watchAllBooks() Stream~List~Book~~
        +watchAllTags() Stream~List~BookTag~~
        +insertBook(book) Future~int~
        +insertTags(tags) Future~List~int~~
        +deleteBook(book) Future~void~
        +findBookTags(bookId) Future~List~BookTag~~
        +init() Future
        +close() void
    }

    class MockYummyService {
        +getExploreData() Future~ExploreData~
        -_getBookstores() Future~List~Bookstore~~
        -_getCategories() Future~List~BookCategory~~
        -_getFriendFeed() Future~List~Post~~
    }

    class ExploreData {
        +List~Bookstore~ bookstores
        +List~BookCategory~ categories
        +List~Post~ friendPosts
    }

    YummyAuth o-- AppCache
    MessageDao o-- UserDao
    MessageDao ..> Message : produces
    MemoryRepository ..> Book : CRUD
    MemoryRepository ..> BookTag : CRUD
    CartManager *-- CartItem
    OrderManager *-- Order
    MockYummyService ..> ExploreData : returns
    ExploreData o-- Bookstore
    ExploreData o-- BookCategory
    ExploreData o-- Post
```

---

## 4. Network layer (Chopper)

```mermaid
classDiagram
    direction LR

    class ServiceInterface {
        <<abstract>>
        +queryBooks(query, offset, number) Future~BookResponse~
        +queryBook(id) Future~BookDetailsResponse~
    }

    class GoogleBooksService {
        <<ChopperApi>>
        +queryBooks(...)
        +queryBook(...)
        +create() GoogleBooksService
    }

    class SpoonacularService {
        <<ChopperApi>>
        +queryBooks(...)
        +queryBook(...)
        +create() SpoonacularService
    }

    GoogleBooksService ..|> ServiceInterface
    SpoonacularService ..|> ServiceInterface
    ServiceInterface ..> Book : returns
```

---

## 5. Widget tree

This flowchart shows how widgets are composed at runtime, starting from `main()`
and `Yummy` (the root `MaterialApp.router`). Solid arrows mean *renders a
child*; dashed arrows mean *navigates to* (via `GoRouter`).

```mermaid
flowchart TD
    main([main]) --> ProviderScope
    ProviderScope --> Yummy
    Yummy --> GoRouter

    GoRouter -. /login .-> LoginPage
    GoRouter -. /:tab .-> Home
    GoRouter -. /:tab/bookstore/:id .-> BookstorePage

    LoginPage --> LoginForm

    Home -->|tab 0| ExplorePage
    Home -->|tab 1| BookList
    Home -->|tab 2| LibraryPage
    Home -->|tab 3| MyOrdersPage
    Home -->|tab 4| AccountPage
    Home -->|tab 5| ChatPage
    Home --> ThemeButton
    Home --> ColorButton

    ExplorePage --> BookstoreSection
    ExplorePage --> PostSection
    ExplorePage --> CategorySection
    BookstoreSection --> BookstoreLandscapeCard
    BookstoreSection --> BookstoreItem
    PostSection --> PostCard
    CategorySection --> CategoryCard

    BookstorePage --> ItemDetails
    BookstorePage --> CartControl
    BookstorePage -. push .-> CheckoutPage

    CategoryCard -. push .-> BookDetailsPage

    ChatPage --> Login
    ChatPage --> MessageList
    MessageList --> MessageWidget

    BookList -. push .-> BookView
    LibraryPage --> Bookmarks
    LibraryPage --> GroceryList

    MyOrdersPage --> OrderTile
```

---

## 6. End-to-end data flow for the "Chat" feature

A concrete example of how the layers interact for a single user action
(sending a chat message):

```mermaid
sequenceDiagram
    actor User
    participant ChatPage
    participant MessageList
    participant MessageDao
    participant UserDao
    participant Firestore as Cloud Firestore

    User->>ChatPage: open Chat tab
    ChatPage->>UserDao: isLoggedIn()
    alt not logged in
        ChatPage-->>User: show Login form
        User->>UserDao: signup(email, password)
        UserDao->>Firestore: createUserWithEmailAndPassword
        Firestore-->>UserDao: User
        UserDao-->>ChatPage: notifyListeners()
    end
    ChatPage->>MessageList: render
    MessageList->>MessageDao: getMessageStream()
    MessageDao->>Firestore: collection('messages').snapshots()
    Firestore-->>MessageList: Stream~List~Message~~
    User->>MessageList: enter text and tap Send
    MessageList->>MessageDao: sendMessage(text)
    MessageDao->>Firestore: collection('messages').add(message.toJson())
```

---

## How to update this document

If a new model, manager, or screen is added:

1. Add the class to the relevant Mermaid block above.
2. Draw an arrow to the closest collaborator (avoid hub-and-spoke spaghetti —
   prefer one or two strong relationships per class).
3. Open the file on GitHub to verify the diagram still renders, or paste each
   ` ```mermaid` block into <https://mermaid.live>.
