### Best Practices for Writing and Reading JSON in Modern C# (.NET Core 9)

#### 1. Use the Built-in `System.Text.Json` Library

-   It is fast, efficient, and optimized for .NET Core.
-   Replaces `Newtonsoft.Json` in most scenarios.
-   Supports features like serialization, deserialization, and property name customization.

```csharp
var jsonString = JsonSerializer.Serialize(myObject);
var myObject = JsonSerializer.Deserialize<MyObject>(jsonString);
```

#### 2. Leverage Strongly Typed Models

-   Define clear models for serialization/deserialization.
-   Use attributes like `[JsonPropertyName("property_name")]` for property mappings.

```csharp
public class MyObject
{
    [JsonPropertyName("custom_name")]
    public string MyProperty { get; set; }
}
```

#### 3. Take Advantage of JSON Source Generators

-   Use JSON source generation for better performance.
-   Add the `[JsonSerializable(typeof(MyObject))]` attribute to enable compile-time generation.

```csharp
[JsonSerializable(typeof(MyObject))]
public partial class MyJsonContext : JsonSerializerContext {}

var myObject = JsonSerializer.Deserialize<MyObject>(jsonString, MyJsonContext.Default.MyObject);
```

#### 4. Customize Serialization/Deserialization

-   Use `JsonSerializerOptions` to control behavior.

```csharp
var options = new JsonSerializerOptions
{
    PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
    WriteIndented = true,
    DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
};
var jsonString = JsonSerializer.Serialize(myObject, options);
```

-   Implement custom converters for specific types:

```csharp
public class DateTimeConverter : JsonConverter<DateTime>
{
    public override DateTime Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        => DateTime.Parse(reader.GetString());

    public override void Write(Utf8JsonWriter writer, DateTime value, JsonSerializerOptions options)
        => writer.WriteStringValue(value.ToString("yyyy-MM-dd"));
}

var options = new JsonSerializerOptions
{
    Converters = { new DateTimeConverter() }
};
```

#### 5. Handle Errors Gracefully

-   Wrap serialization/deserialization in try-catch blocks to catch `JsonException`.
-   Use `JsonDocument` for safe processing of unknown JSON structures.

```csharp
try
{
    var myObject = JsonSerializer.Deserialize<MyObject>(jsonString);
}
catch (JsonException ex)
{
    Console.WriteLine($"JSON error: {ex.Message}");
}
```

#### 6. Validate Input JSON

-   Ensure proper validation of input data before deserialization.
-   Use tools like `JsonSchema` for validating complex structures.

#### 7. Optimize Large Payloads

-   Use `Stream` for reading/writing large JSON files to avoid memory overhead.

```csharp
await using var stream = File.OpenRead("data.json");
var myObject = await JsonSerializer.DeserializeAsync<MyObject>(stream);
```

#### 8. Avoid Over-Serialization

-   Use `[JsonIgnore]` to exclude properties that don’t need serialization.

```csharp
public class MyObject
{
    public string Included { get; set; }

    [JsonIgnore]
    public string Excluded { get; set; }
}
```

#### 9. Keep JSON Configuration Centralized

-   Use reusable `JsonSerializerOptions` configurations to maintain consistency across the application.

```csharp
public static class JsonOptions
{
    public static JsonSerializerOptions Default => new JsonSerializerOptions
    {
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        WriteIndented = true
    };
}

var jsonString = JsonSerializer.Serialize(myObject, JsonOptions.Default);
```

#### 10. Document and Test JSON Handling

-   Write unit tests for serialization/deserialization logic.
-   Document the structure of JSON models to assist future developers.

#### 11. Serialize an Object to JSON

Use the JsonSerializer.Serialize method to convert an anonymous object to a JSON string.

```csharp
using System.Text.Json;

var obj = new
{
    Name = "John Doe",
    Age = 30,
    IsEmployed = true
};

string jsonString = JsonSerializer.Serialize(obj);
Console.WriteLine(jsonString);
```

#### 12. Reading JSON

##### 1. Deserialize JSON to an Object: Use the JsonSerializer.Deserialize method to convert a JSON string to an object.

```csharp
string jsonString = "{\"name\":\"John Doe\",\"age\":30,\"isEmployed\":true}";

var obj = JsonSerializer.Deserialize<Dictionary<string, object>>(jsonString);
Console.WriteLine(obj["name"]);
```

##### 2. Deserialize with Options: Customize the deserialization process using JsonSerializerOptions.

```csharp
var options = new JsonSerializerOptions
{
    PropertyNameCaseInsensitive = true // Ignore case when matching property names
};

var obj = JsonSerializer.Deserialize<Dictionary<string, object>>(jsonString, options);
Console.WriteLine(obj["name"]);
```
