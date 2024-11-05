# WeatherForecastApp

This Ruby on Rails application retrieves weather forecast data based on a provided address or ZIP code, displaying the current temperature, high/low temperatures, and an extended forecast. It includes caching for efficiency and demonstrates production-level coding practices .

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Running Tests](#running-tests)
- [Caching](#caching)
- [API Details](#api-details)
- [Project Structure and Design](#project-structure-and-design)

## Installation

Follow these steps to get the app running on your local machine.

### 1. Clone the Repository

Start by cloning the repository to your local machine:

```bash
git clone https://github.com/taylor_od/WeatherForecastApp.git
cd WeatherForecastApp
```

### 2. Install Dependencies

Run `bundle install` to install all the required gems.

```bash
bundle install
```

### 3. Set Up Environment Variables

The app requires a weather API key to retrieve forecast data. You can get your own here: <www.weatherapi.com> Use `dotenv` or add your API key directly to the environment:

1. Create a `.env` file in the root of your project:
   ```plaintext
   WEATHER_API_KEY=your_actual_api_key_here
   ```

2. Restart your server after adding environment variables to ensure they load properly.

### 4. Start Redis for Caching

This application uses Redis for caching weather data to minimize API calls. You’ll need Redis installed and running:

- If you don’t have Redis, install it (on macOS, for example):
  ```bash
  brew install redis
  ```

- Start the Redis server:
  ```bash
  redis-server
  ```

### 5. Run the Rails Server

Now, start your Rails server in a separate terminal tab:

```bash
rails server
```

### 6. Visit the Application

Navigate to the following URL to use the app:

```
http://localhost:3000/weather
```

On this page, you can enter an address or ZIP code to retrieve the current and extended weather forecast.

## Usage

1. **Enter an Address**: On the `/weather` page, enter an address or ZIP code in the form provided.
2. **View the Forecast**: The app will display the current temperature, high and low temperatures, and an extended forecast for the next few days.
3. **Cache Notification**: If the data is served from the cache, a message will indicate that it is cached. Data is cached for 30 minutes per ZIP code.

## Running Tests

This app includes unit tests for the `WeatherService` class and functional tests for the `WeatherController`.

1. **Install RSpec** (if not already done):

   ```bash
   rails generate rspec:install
   ```

2. **Run Tests**:

   Execute the following command to run the test suite:

   ```bash
   rspec
   ```

   This command will run all tests, ensuring the API call logic, caching, and controller behavior function as expected.

## Caching

The weather data is cached for 30 minutes by ZIP code to optimize performance and reduce API calls. Redis is used as the caching layer, so ensure that Redis is running on your system. If Redis is not available, you may need to adjust the caching mechanism or handle errors related to Redis.

## API Details

The app fetches weather data using a third-party weather API (e.g., OpenWeatherMap or WeatherAPI). You need an API key from the service you choose. To obtain the API key:

1. Sign up at the weather API provider’s website.
2. Add the API key to your `.env` file as specified in the [Installation](#installation) section.

## Project Structure and Design

- **Controller**: `WeatherController#index` handles the address input, invokes `WeatherService` to retrieve the forecast, and displays the data.
- **Service**: `WeatherService` encapsulates logic for communicating with the weather API, handling caching, and parsing the API response.
- **Caching**: Implemented with Redis to store weather data for 30 minutes per ZIP code, reducing redundant API calls.
- **Views**: Display current temperature, high/low temperatures, and a 3-day forecast, along with a cache notification. A .erb file works fine for a small application like this. In production for anything larger I'd likely want to use React or some other javascript framework.

---
