# Seed – Habit Tracker App

iOS приложение для отслеживания привычек и прогресса с минималистичным дизайном и аналитикой

---

## Features

- Создание привычек
- Статистика выполнения задач
- Настройки уведомлений
- Отслеживание дней захода в приложение

---

## Tech Stack

- Swift
- UIKit
- CoreData
- Модифицированный VIPER
- UserDefaults

---

## Screenshots

### Onboarding
![Onboarding](screens/onboarding.png)

### Habits list
![Statistics](screens/habits.png)

### Done habits list
![Statistics](screens/doneHabits.png)

### Create Habit
![Create Habit](screens/create_habit.png)

### Statistics
![Statistics](screens/stats.png)

### Settings
![Statistics](screens/settings.png)

---

## Architecture

Приложение построено с разделением ответственности:

- ViewController — UI
- Interactor — бизнес-логика
- Presenter — работа перед отображением
- Repository — хранение (CoreData)
- Model
- Protocols 
