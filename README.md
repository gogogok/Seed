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

## 📸 Screenshots

<p align="center">
  <img src="screens/onboarding.png" width="220">
  <img src="screens/habits.png" width="220">
  <img src="screens/doneHabits.png" width="220">
</p>

<p align="center">
  <img src="screens/create_habit.png" width="220">
  <img src="screens/stats.png" width="220">
  <img src="screens/settings.png" width="220">
</p>

---

## Architecture

Приложение построено с разделением ответственности:

- ViewController — UI
- Interactor — бизнес-логика
- Presenter — работа перед отображением
- Repository — хранение (CoreData)
- Model
- Protocols 
