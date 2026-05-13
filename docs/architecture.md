# Architecture — Functions & Widgets

This document is a structural map of the **Yummy** Flutter application. It is
derived from the actual source under `lib/` and is intended to be read as the
counterpart of the ER diagram from the previous assignment: every entity in the
ER diagram appears here as a Dart class, and the widget tree shows where each
entity is rendered.

All diagrams below are written in [Mermaid](https://mermaid.live) — GitHub
renders them automatically in the file preview, and you can also paste any of
them into <https://mermaid.live> to export PNG/SVG.

---

## 1. Layered overview

```mermaid
flowchart LR
    subgraph Domain["Domain models (ER entities)"]
        direction TB
        Restaurant
        Item
        FoodCategory
        Post
        User
        CartItem
        Order
        Message
        Recipe
        Ingredient
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
        RecipeList
        LibraryPage
        MyOrdersPage
        AccountPage
        ChatPage
        RestaurantPage
        CheckoutPage
        BookDetailsPage
        RecipeDetails
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

    class Restaurant {
        +String id
        +String name
        +String address
        +String attributes
        +String imageUrl
        +double distance
        +double rating
        +List~Item~ items
        +getRatingAndDistance() String
    }

    class Item {
        +String name
        +String description
        +double price
        +String imageUrl
    }

    class FoodCategory {
        +String name
        +int numberOfRestaurants
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

    class Recipe {
        +int id
        +String sourceId
        +String label
        +String image
        +String description
        +bool bookmarked
        +List~Ingredient~ ingredients
        +copyWith(...) Recipe
    }

    class Ingredient {
        +int id
        +int recipeId
        +String name
        +double amount
        +copyWith(...) Ingredient
    }

    Restaurant "1" *-- "many" Item : owns
    Order "1" *-- "many" CartItem : line items
    Recipe "1" *-- "many" Ingredient : composed of
    Ingredient "many" --> "1" Recipe : recipeId
    User "1" --> "many" Post : authors
    User "1" --> "many" Message : sends
    User "1" --> "many" Order : places
    Restaurant "many" --> "1" FoodCategory : classified by
```

> **Mapping to the ER diagram**
>
> | ER entity        | Dart class                |
> | ---------------- | ------------------------- |
> | Restaurant       | `Restaurant`              |
> | Menu Item / Dish | `Item`                    |
> | Category         | `FoodCategory`            |
> | User             | `User` + `UserDao` record |
> | Post / Feed item | `Post`                    |
> | Cart line        | `CartItem`                |
> | Order            | `Order`                   |
> | Chat message     | `Message`                 |
> | Recipe           | `Recipe`                  |
> | Ingredient       | `Ingredient`              |

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
        +findAllRecipes() Future~List~Recipe~~
        +watchAllRecipes() Stream~List~Recipe~~
        +watchAllIngredients() Stream~List~Ingredient~~
        +insertRecipe(recipe) Future~int~
        +insertIngredients(ingredients) Future~List~int~~
        +deleteRecipe(recipe) Future~void~
        +findRecipeIngredients(recipeId) Future~List~Ingredient~~
        +init() Future
        +close() void
    }

    class MockYummyService {
        +getExploreData() Future~ExploreData~
        -_getRestaurants() Future~List~Restaurant~~
        -_getCategories() Future~List~FoodCategory~~
        -_getFriendFeed() Future~List~Post~~
    }

    class ExploreData {
        +List~Restaurant~ restaurants
        +List~FoodCategory~ categories
        +List~Post~ friendPosts
    }

    YummyAuth o-- AppCache
    MessageDao o-- UserDao
    MessageDao ..> Message : produces
    MemoryRepository ..> Recipe : CRUD
    MemoryRepository ..> Ingredient : CRUD
    CartManager *-- CartItem
    OrderManager *-- Order
    MockYummyService ..> ExploreData : returns
    ExploreData o-- Restaurant
    ExploreData o-- FoodCategory
    ExploreData o-- Post
```

---

## 4. Network layer (Chopper)

```mermaid
classDiagram
    direction LR

    class ServiceInterface {
        <<abstract>>
        +queryRecipes(query, offset, number) Future~RecipeResponse~
        +queryRecipe(id) Future~RecipeDetailsResponse~
    }

    class GoogleBooksService {
        <<ChopperApi>>
        +queryRecipes(...)
        +queryRecipe(...)
        +create() GoogleBooksService
    }

    class SpoonacularService {
        <<ChopperApi>>
        +queryRecipes(...)
        +queryRecipe(...)
        +create() SpoonacularService
    }

    GoogleBooksService ..|> ServiceInterface
    SpoonacularService ..|> ServiceInterface
    ServiceInterface ..> Recipe : returns
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
    GoRouter -. /:tab/restaurant/:id .-> RestaurantPage

    LoginPage --> LoginForm

    Home -->|tab 0| ExplorePage
    Home -->|tab 1| RecipeList
    Home -->|tab 2| LibraryPage
    Home -->|tab 3| MyOrdersPage
    Home -->|tab 4| AccountPage
    Home -->|tab 5| ChatPage
    Home --> ThemeButton
    Home --> ColorButton

    ExplorePage --> RestaurantSection
    ExplorePage --> PostSection
    ExplorePage --> CategorySection
    RestaurantSection --> RestaurantLandscapeCard
    RestaurantSection --> RestaurantItem
    PostSection --> PostCard
    CategorySection --> CategoryCard

    RestaurantPage --> ItemDetails
    RestaurantPage --> CartControl
    RestaurantPage -. push .-> CheckoutPage

    CategoryCard -. push .-> BookDetailsPage

    ChatPage --> Login
    ChatPage --> MessageList
    MessageList --> MessageWidget

    RecipeList -. push .-> RecipeDetails
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
