import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class TodoAppSample {

    private static final String BASE_URL = "https://api.nstack.in/v1/todos";

    private Todo createNewTodo() {
        return new Todo("New Todo", "Description");
    }

    public static void main(String[] args) {
        // Create an instance of TodoAppSample to access non-static members
        TodoAppSample todoAppSample = new TodoAppSample();

        // Now you can create a Todo instance
        Todo newTodo = todoAppSample.createNewTodo();
        // Fetch and display todos
        fetchTodos();

        // Create a new todo
        newTodo = new TodoAppSample().createNewTodo();
        createTodo(newTodo);

        // Fetch and display todos after creation
        fetchTodos();

        // Update the todo
        newTodo.setTitle("Updated Todo");
        newTodo.setDescription("Updated Description");
        updateTodo(newTodo);

        // Fetch and display todos after update
        fetchTodos();

        // Delete the todo
        deleteTodo(newTodo.getId());

        // Fetch and display todos after deletion
        fetchTodos();
    }

    private static void fetchTodos() {
        try {
            URL url = new URL("https", "api.nstack.in", "/v1/todos");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");

            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                String line;
                StringBuilder response = new StringBuilder();

                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                reader.close();

                System.out.println("Todos:");
                System.out.println(response.toString());
                System.out.println();
            } else {
                System.out.println("Failed to fetch todos. HTTP Response Code: " + responseCode);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void createTodo(Todo todo) {
        try {
            URL url = new URL("https", "api.nstack.in", "/v1/todos");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setDoOutput(true);

            String jsonInputString = "{\"title\":\"" + todo.getTitle() + "\",\"description\":\"" + todo.getDescription() + "\"}";

            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = jsonInputString.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_CREATED) {
                System.out.println("Todo created successfully.");
            } else {
                System.out.println("Failed to create todo. HTTP Response Code: " + responseCode);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void updateTodo(Todo todo) {
        try {
            URL url = new URL(BASE_URL + "/" + todo.getId());
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("PUT");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setDoOutput(true);

            String jsonInputString = "{\"title\":\"" + todo.getTitle() + "\",\"description\":\"" + todo.getDescription() + "\"}";

            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = jsonInputString.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                System.out.println("Todo updated successfully.");
            } else {
                System.out.println("Failed to update todo. HTTP Response Code: " + responseCode);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void deleteTodo(String todoId) {
        try {
            URL url = new URL("https", "api.nstack.in", "/v1/todos/" + todoId);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("DELETE");

            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                System.out.println("Todo deleted successfully.");
            } else {
                System.out.println("Failed to delete todo. HTTP Response Code: " + responseCode);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public class Todo {
        private String id;
        private String title;
        private String description;

        public Todo(String title, String description) {
            this.title = title;
            this.description = description;
        }

        public String getId() {
            return id;
        }

        public String getTitle() {
            return title;
        }

        public String getDescription() {
            return description;
        }

        public void setId(String id) {
            this.id = id;
        }

        // Added setter methods
        public void setTitle(String title) {
            this.title = title;
        }

        public void setDescription(String description) {
            this.description = description;
        }
    }
}
