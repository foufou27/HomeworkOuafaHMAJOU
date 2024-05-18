#!/bin/bash

TASK_FILE="tasks.txt"
complete_tasks=()
incomplete_tasks=()

create_task() {
    while true; do
        read -p "Enter title (required): " title
        if [[ -n "$title" ]]; then
            break
        else
            echo "Title is required." >&2
        fi
    done

    read -p "Enter description: " description
    read -p "Enter location: " location
    
    while true; do
        read -p "Enter due date (YYYY-MM-DD) (required): " due_date
        if [[ -n "$due_date" && "$due_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            break
        else
            echo "Due date is required and must be in YYYY-MM-DD format." >&2
        fi
    done

    while true; do
        read -p "Enter time (HH:MM): " time
        if [[ -z "$time" || "$time" =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$ ]]; then
            break
        else
            echo "Invalid time format. Time must be in HH:MM format." >&2
        fi
    done

    while true; do
        read -p "Enter completion marker (1 for complete, 0 for incomplete): " completed
        if [[ "$completed" == "0" || "$completed" == "1" ]]; then
            break
        else
            echo "Invalid completion marker. Please enter 0 for incomplete or 1 for complete." >&2
        fi
    done

    task_id=$(($(wc -l < "$TASK_FILE") + 1))
    task="$task_id|$title|$description|$location|$due_date|$time|$completed"
    echo "$task" >> "$TASK_FILE"
    
    # Ajoutez la tâche à la liste appropriée en fonction du marqueur de complétion
    if [[ "$completed" == "1" ]]; then
        complete_tasks+=("$task")
    else
        incomplete_tasks+=("$task")
    fi
    
    echo "Task created with ID $task_id."
}

update_task() {
    read -p "Enter task ID to update: " task_id
    task=$(grep "^$task_id|" "$TASK_FILE")
    if [[ -z "$task" ]]; then
        echo "No task found with ID $task_id" >&2
        exit 1
    fi

    IFS='|' read -r id title description location due_date time completed <<< "$task"

    read -p "Enter new title [$title]: " new_title
    new_title=${new_title:-$title}

    read -p "Enter new description [$description]: " new_description
    new_description=${new_description:-$description}

    read -p "Enter new location [$location]: " new_location
    new_location=${new_location:-$location}

    while true; do
        read -p "Enter new due date (YYYY-MM-DD) [$due_date]: " new_due_date
        new_due_date=${new_due_date:-$due_date}
        if [[ -n "$new_due_date" && "$new_due_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            break
        else
            echo "Due date is required and must be in YYYY-MM-DD format." >&2
        fi
    done

    while true; do
        read -p "Enter new time (HH:MM) : " new_time
        if [[ -z "$new_time" || "$new_time" =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$ ]]; then
            break
        else
            echo "Invalid time format. Time must be in HH:MM format." >&2
        fi
    done

    while true; do
        read -p "Enter new completion marker (1 for complete, 0 for incomplete): " new_completed
        if [[ "$new_completed" == "0" || "$new_completed" == "1" ]]; then
            break
        else
            echo "Invalid completion marker. Please enter 0 for incomplete or 1 for complete." >&2
        fi
    done

    new_task="$task_id|$new_title|$new_description|$new_location|$new_due_date|$new_time|$new_completed"

    # Supprimer l'ancienne tâche du fichier
    sed -i "/^$task_id/d" "$TASK_FILE"
    # Ajouter la nouvelle tâche au fichier
    echo "$new_task" >> "$TASK_FILE"

    # Mettre à jour les listes de tâches
    if [[ "$completed" == "1" ]]; then
        complete_tasks=("${complete_tasks[@]/$task/}")
    else
        incomplete_tasks=("${incomplete_tasks[@]/$task/}")
    fi

    if [[ "$new_completed" == "1" ]]; then
        complete_tasks+=("$new_task")
    else
        incomplete_tasks+=("$new_task")
    fi

    echo "Task with ID $task_id updated."
}

delete_task() {
    read -p "Enter task ID to delete: " task_id
    task=$(grep "^$task_id|" "$TASK_FILE")
    if [[ -z "$task" ]]; then
        echo "No task found with ID $task_id" >&2
        exit 1
    fi
    
    IFS='|' read -r id title description location due_date time completed <<< "$task"

    if [[ "$completed" == "1" ]]; then
        complete_tasks=("${complete_tasks[@]/$task/}")
    else
        incomplete_tasks=("${incomplete_tasks[@]/$task/}")
    fi

    sed -i "/^$task_id|/d" "$TASK_FILE"
    echo "Task with ID $task_id deleted."
}

show_task() {
    read -p "Enter task ID to show: " task_id
    task=$(grep "^$task_id|" "$TASK_FILE")
    if [[ -z "$task" ]]; then
        echo "No task found with ID $task_id" >&2
        exit 1
    fi

    IFS='|' read -r id title description location due_date time completed <<< "$task"
    completed_text=$(if [[ "$completed" == "1" ]]; then echo "complete"; else echo "incomplete"; fi)
    echo "ID: $id"
    echo "Title: $title"
    echo "Description: $description"
    echo "Location: $location"
    echo "Due Date: $due_date"
    echo "Time: $time"
    echo "Completed: $completed_text"
}

list_tasks() {
    while true; do
        read -p "Enter date to list tasks (YYYY-MM-DD): " date
        if [[ -n "$date" && "$date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            break
        else
            echo "Date is required and must be in YYYY-MM-DD format." >&2
        fi
    done

    echo "Completed Tasks:"
    grep "|$date|.*|1$" "$TASK_FILE" | while IFS='|' read -r id title description location due_date time completed; do
        completed_text="complete"
        echo "ID: $id, Title: $title, Due Date: $due_date, Time: $time, Completed: $completed_text"
    done

    echo ""
    echo "Uncompleted Tasks:"
    grep "|$date|.*|0$" "$TASK_FILE" | while IFS='|' read -r id title description location due_date time completed; do
        completed_text="incomplete"
        echo "ID: $id, Title: $title, Due Date: $due_date, Time: $time, Completed: $completed_text"
    done
}

list_tasks_day() {
    local current_date=$(date '+%Y-%m-%d')
    echo "Completed Tasks for $current_date:"
    grep "|$current_date|.*|1$" "$TASK_FILE" | while IFS='|' read -r id title description location due_date time completed; do
        completed_text="complete"
        echo "ID: $id, Title: $title, Due Date: $due_date, Time: $time, Completed: $completed_text"
    done

    echo ""
    echo "Uncompleted Tasks for $current_date:"
    grep "|$current_date|.*|0$" "$TASK_FILE" | while IFS='|' read -r id title description location due_date time completed; do
        completed_text="incomplete"
        echo "ID: $id, Title: $title, Due Date: $due_date, Time: $time, Completed: $completed_text"
    done
}

search_tasks() {
    read -p "Enter title to search: " title
    if [[ -z "$title" ]]; then
        echo "Title is required." >&2
        exit 1
    fi

    grep "|$title|" "$TASK_FILE" | while IFS='|' read -r id title description location due_date time completed; do
        completed_text=$(if [[ "$completed" == "1" ]]; then echo "complete"; else echo "incomplete"; fi)
        echo "ID: $id, Title: $title, Due Date: $due_date, Time: $time, Completed: $completed_text"
    done
}


main() {
    if [[ ! -f "$TASK_FILE" ]]; then
        touch "$TASK_FILE"
    fi
    if [[ $# -eq 0 ]]; then
        # If no arguments provided, display tasks for the current day
        list_tasks_day
        
        exit 0
    fi

    case "$1" in
        create)
            create_task
            ;;
        update)
            update_task
            ;;
        delete)
            delete_task
            ;;
        show)
            show_task
            ;;
        list)
            list_tasks
            ;;
        search)
            search_tasks
            ;;
        *)
            
            exit 1
            ;;
    esac
}

main "$@"


