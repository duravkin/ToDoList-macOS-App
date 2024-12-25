# ToDoList macOS App

Это приложение ToDo-лист для macOS, созданное с использованием Xcode, SwiftUI и CoreData. Оно позволяет добавлять, редактировать, удалять и отмечать задачи как выполненные.

## Используемое ПО

- Xcode 15.2
- macOS 13.6.7

## Установка

1. Склонируйте репозиторий на ваш компьютер.
2. Откройте проект в Xcode.
3. Выберите целевую платформу (macOS).
4. Построить и запустить приложение на симуляторе или на реальном устройстве.

## Основные шаги разработки проекта

1. **Создание проекта**: Используйте шаблон "macOS App" с интерфейсом на SwiftUI.
2. **Добавление CoreData**: Добавьте модель данных для задач и создайте сущности с атрибутами: id, title, isCompleted, creationDate.
3. **Реализация функционала**:
   - Добавление новых задач.
   - Редактирование задач.
   - Удаление задач.
   - Отметка задач как выполненных.

## Файлы проекта

- **ContentView.swift**: Основной интерфейс приложения с использованием SwiftUI.
- **CoreDataManager.swift**: Класс для работы с CoreData.
- **ToDoListViewModel.swift**: ViewModel для управления задачами.
- **ToDoItem.swift**: Модель данных для задачи.

## Использование

- Добавьте задачу через текстовое поле или с помощью кнопки "+".
- Отредактируйте задачу, нажав на иконку карандаша или ПКМ (в контекстном меню пункт Edit).
- Удалите задачу, нажав на иконку корзины или в ПКМ (в контекстном меню пункт Delete).
- Отметьте задачу как выполненную, кликнув на иконку с галочкой.

## Тестирование

- При запуске приложения отображается окно приложения и интерфейс взаимодействия:

![image](https://github.com/user-attachments/assets/9d7f54b4-0437-47ed-b0dd-5ece296af327)

- Добавление задач осуществляется через Enter или нажатие кнопки "плюс":

![image](https://github.com/user-attachments/assets/a969f77d-eceb-4c2a-938a-1f467e18a267)

- При нажатии кнопки изменения отображается окно редактирования задачи:

![image](https://github.com/user-attachments/assets/aa3fc87d-4373-4be2-8366-699eebfbcec8)

- В ходе взаимодействия можно увидеть результат работы приложения (были добавлены задачи, изменены, помечены как выполненные):

![image](https://github.com/user-attachments/assets/b90641dc-6d91-48a0-acb2-e098a29543f0)

