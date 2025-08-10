# BattleQuest Log API

This API provides a backend for processing and analyzing game logs from the BattleQuest game. It tracks players' data such as their stats, items, and combat statistics.

## System Requirements

- Ruby 3.3.6
- Rails 7.2.2.1
- PostgreSQL 15+

## Getting Started

### Using Docker (Recommended)

1. Clone the repository:

   ```bash
   https://github.com/leon-siqueira/battlequest_log_api.git
   cd battlequest_log_api
   ```

2. Set up environment variables:

   ```bash
   cp .env.example .env
   # Edit .env with your settings

   # [ === IMPORTANT === ]

   # .env.example sets by default to rails db:seed w/ the full log
   # Change the AUTO_IMPORT_LOG_FILE to opt for a smaller data set or no seeding at all
   # 1 - Small | 2 - Medium | 3 - Large | 4 - Full log | 999 - No seeding
   ```

3. Build and run the Docker containers:

   ```bash
   docker compose build
   docker compose up

   # If any permission denied error occur, try to run: sudo docker compose up --build
   ```

4. The API will be available at [http://localhost:3000](http://localhost:3000)

### Manual Setup

1. Install Ruby 3.3.6 (using rbenv, asdf, or RVM)
2. Install PostgreSQL
3. Install dependencies:

   ```bash
   bundle install
   ```

4. Set up the database:

   ```bash
   rails db:reset
   ```

5. Start the server:

   ```bash
   rails server
   ```

## Database Structure

The application uses PostgreSQL with the following main models:

- `Player`: Represents game players with stats like XP, gold, HP
- `Quest`: Game missions that players can complete
- `PlayerQuest`: Join model tracking quest status for players
- `Item`: Game items that players can collect
- `PlayerItem`: Join model tracking item quantities owned by players
- `LoggedEvent`: Raw event logs imported from game server

## Event Processing

The system processes game logs through a pipeline:

1. Log files are imported via `LoggedEvent::Import` service
2. Events are parsed and categorized (player joins, quest starts, boss defeats, etc.)
3. Appropriate handlers in `EventHandler` namespace process each event type
4. Data is stored in structured format in the database

## API Endpoints

### Players

- `GET /players` - List all players
  - **Filters**:
    - `name`: Filter by player name (partial match)
    - `min_level`: Minimum player level
    - `max_level`: Maximum player level
    - `min_score`: Minimum player score
    - `min_kills`: Minimum kills count
  - **Pagination**:
    - `page`: Page number (default: 1)
    - `per_page`: Items per page (default: 5, max: 100)
  - **Example**: `/players?name=dragon&min_level=20&page=2&per_page=10`

- `GET /players/:id/stats` - Get detailed stats for a player
  - **Example**: `/players/42/stats`

- `GET /leaderboard` - Get top players ranked by score
  - **Filters**:
    - `name`: Filter by player name (partial match)
    - `min_level`: Minimum player level
    - `max_level`: Maximum player level
    - `min_score`: Minimum player score
    - `min_kills`: Minimum kills count
  - **Pagination**:
    - `page`: Page number (default: 1)
    - `per_page`: Items per page (default: 5, max: 100)
  - **Example**: `/leaderboard?min_level=30&min_kills=50&per_page=20`

### Items

- `GET /items/top` - List the top looted items
  - **Filters**
    - `name`: Filter by by item name (partial match)
    - `gt`: Total quantity greater than X
    - `gte`: Total quantity greater than or equal to X
    - `lt`: Total quantity less than X
    - `lte`: Total quantity less than or equal to X
    - `eq`: Total quantity equal to X
  - **Pagination**:
    - `page`: Page number (default: 1)
    - `per_page`: Items per page (default: 5, max: 100)
  - **Example**: `/items/top?name=potion&gte=100&page=1&per_page=15`

### Events

- `GET /events` - List the last logged events
  - **Pagintaion**
    - `page`: Page number (default: 1)
    - `per_page`: Items per page (default: 25, max: 200)
  - **Example**: `/events?page=3&per_page=50`

## Testing

Run the test suite with:

```bash
bundle exec rspec
```

For specific test files:

```bash
bundle exec rspec spec/models/player_spec.rb
```

## Development

### Code Organization

- `app/models/concerns/event_handler` - Event processing logic
- `app/models/concerns/query` - Complex database queries

### Adding New Event Types

1. Create a handler in `app/models/concerns/event_handler/your_event.rb`
2. Name the handler class according to the event name. In this case, it should be `EventHandler::YourEvent`
3. Implement the `run` method to process the event data
4. The system will automatically route events to your handler
