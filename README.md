# Task Manager

This is a simple command-line task management script written in Bash. The script allows users to create, update, delete, show, list, and search tasks. Tasks are stored in a text file (`tasks.txt`), and each task includes a title, description, location, due date, time, and completion marker.

## Features

- **Create Task**: Add a new task with a title, description, location, due date, time, and completion marker.
- **Update Task**: Update the details of an existing task by its ID.
- **Delete Task**: Remove a task by its ID.
- **Show Task**: Display the details of a task by its ID.
- **List Tasks**: List all tasks for a specific date.
- **List Today's Tasks**: Display tasks due today.
- **Search Tasks**: Search tasks by title.

## Prerequisites

- Bash shell

## Getting Started

1. Clone the repository to your local machine:
    ```sh
    git clone https://github.com/foufou27/HomeworkOuafaHMAJOU.git
    cd HomeworkOuafaHMAJOU
    ```

2. Make the script executable:
    ```sh
    chmod +x todo.sh
    ```

3. Run the script:
    ```sh
    ./todo.sh
    ```

## Usage

The script can be run with various commands to perform different operations. Here are the available commands:

### Create Task

Create a new task with a title, description, location, due date, time, and completion marker.

```sh
./todo.sh create
```

### Update Task

Update an existing task by providing the task ID. You can change the title, description, location, due date, time, and completion marker.

```sh
./todo.sh update
```

### Delete Task

Delete a task by providing the task ID.

```sh
./todo.sh delete
```

### Show Task

Show the details of a task by providing the task ID.

```sh
./todo.sh show
```

### List Tasks

List all tasks for a specific date. 

```sh
./todo.sh list
```

### List Today's Tasks

Display tasks that are due today.

```sh
./todo.sh
```

### Search Tasks

Search for tasks by title.

```sh
./todo.sh search
```

## Task File Format

Tasks are stored in a text file named `tasks.txt`. Each task is recorded in a single line with fields separated by the `|` character. The fields are as follows:

1. Task ID
2. Title
3. Description
4. Location
5. Due Date (YYYY-MM-DD)
6. Time (HH:MM)
7. Completion Marker (1 for complete, 0 for incomplete)

Example:
```
1|Buy groceries|Buy milk, bread, and eggs|Supermarket|2024-05-20|14:00|0
```

## Detailed Script Functionality

### Functions

- **create_task**: Prompts the user for task details and adds the task to the `tasks.txt` file.
- **update_task**: Prompts the user to update details of an existing task identified by task ID.
- **delete_task**: Deletes a task from `tasks.txt` by task ID.
- **show_task**: Displays the details of a task by task ID.
- **list_tasks**: Lists all tasks for a specified date, showing completed and uncompleted tasks separately.
- **list_tasks_day**: Lists all tasks for the current day, showing completed and uncompleted tasks separately.
- **search_tasks**: Searches for tasks by title and displays matching tasks.

### Main Logic

- The script checks if the `tasks.txt` file exists and creates it if it doesn't.
- If no command-line arguments are provided, it lists tasks for the current day.
- Based on the command-line argument provided, it calls the respective function (create, update, delete, show, list, search).

## Contribution

Contributions are welcome! If you have any suggestions or improvements, please create a pull request or open an issue.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
```
