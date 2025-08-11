# Jsonline

<img alt="PyPI - License" src="https://img.shields.io/github/license/fsadannn/jsonline">

Jsonline is a Python library for efficiently working with [JSON Lines](https://jsonlines.org/) files. It allows you to access and append data without loading the entire file into memory, making it ideal for large datasets.

This library treats JSON Lines files as if they were read-only lists, but with an `append` method. It builds an index of the start and end positions of each JSON object in the file. When you access an element, Jsonline uses this index to read only the relevant line. The index is stored in a compressed gzip file with a `.jsonl.idx` extension for efficiency.

## Features

-   **Memory-efficient:** Reads only the data you need from the file.
-   **List-like access:** Access JSON objects by index (`data[i]`).
-   **Fast appends:** Efficiently append single or multiple objects.
-   **Automatic indexing:** Creates and manages an index file for you.
-   **LRU Cache:** Caches recently accessed objects in memory for faster retrieval.
-   **Context manager support:** Works with the `with` statement for automatic resource management.

## Installation

```bash
pip install jsonline
```

## Usage

### Opening a file

You can open a JSON Lines file using the `JsonLine` class or the `jsonline.open()` function. The `.jsonl` extension is not required in the file path.

```python
from jsonline import JsonLine

# Using the JsonLine class
data = JsonLine('my_file')

# Or using the open function
import jsonline
data = jsonline.open('my_file')
```

If the file does not exist, it will be created with a `.jsonl` extension.

### Appending data

You can append a single JSON object using the `append` method, or multiple objects using `extend`.

```python
# Append a single object
data.append({'test': 1})

# Append multiple objects
data.extend([{'test': 2}, {'another_test': 3}])
```

### Accessing data

You can access individual JSON objects by their index, just like a Python list.

```python
# Get the first object
first_item = data[0]

# Get the last object
last_item = data[-1]
```

You can also iterate over the entire dataset:

```python
for item in data:
    print(item)
```

### Context Manager

Jsonline supports the context manager protocol, which automatically closes the file for you.

```python
with JsonLine('my_file') as data:
    print(data[0])
```

## API Reference

### `jsonline.JsonLine(path, cache_size=10, string_keys=True)`

The main class for working with JSON Lines files.

-   **`path` (str or pathlib.Path):** Path to the JSON Lines file.
-   **`cache_size` (int, optional):** The number of items to store in the LRU cache. Defaults to `10`.
-   **`string_keys` (bool, optional):** If `False`, allows non-string keys in JSON objects (this is non-standard). Defaults to `True`.

#### Methods

-   **`append(data)`:** Appends a single JSON object to the end of the file.
-   **`extend(data)`:** Appends an iterable of JSON objects to the end of the file. This is more efficient than calling `append` in a loop.
-   **`get(index, default=None)`:** Retrieves an item by its index. If the index is out of bounds, it returns the `default` value.
-   **`close()`:** Closes the file handle.
-   **`rebuild_index()`:** Forces a rebuild of the index file. This can be useful if the file has been modified by another process.

### `jsonline.open(path, cache=10)`

A convenience function for creating a `JsonLine` object.

-   **`path` (str or pathlib.Path):** Path to the JSON Lines file.
-   **`cache` (int, optional):** The number of items to store in the LRU cache. Defaults to `10`.

### `jsonline.load(f, cache=10)`

Loads a `JsonLine` object from an existing file-like object.

-   **`f` (TextIO):** A file-like object opened in text mode. This function uses the `.name` attribute of the file-like object to open the file, so it will not work with in-memory objects like `io.StringIO`.
-   **`cache` (int, optional):** The number of items to store in the LRU cache. Defaults to `10`.

## How it Works

Jsonline creates an index file (`.jsonl.idx`) that stores the byte offset and length of each line in the JSON Lines file. This allows for fast lookups without reading the entire file. When you request an item at a specific index, Jsonline reads the index file to find the position of that item, then seeks to that position in the data file and reads only the necessary bytes.

The index is automatically updated when you use `append` or `extend`. If the index file gets out of sync with the data file (e.g., if the data file is modified externally), you can use the `rebuild_index()` method to regenerate it.
