# Jsonline

<img alt="PyPI - License" src="https://img.shields.io/github/license/fsadannn/expressive_regex"> <img alt="PyPI - License" src="https://travis-ci.org/fsadannn/expressive_regex.svg"> <img alt="Codecov" src="https://img.shields.io/codecov/c/github/fsadannn/expressive_regex.svg">

Jsonline is intend to use to explore and work with json lines files and avoid keep the entire data in memory or constantly read the whole file.This library handle json lines files as it was a read only list, but with `append` too. This library build and index with the position of the being and end of each json in the file. When an element is accessed we use the mentioned index to read only the line with the requested json. This index is efficient handled and store in gzip format with extension `.json.idx`.

## Example

```Python
from jsonline impor jsonLine

# the extension .json is't necessary
data = jsonLine('my_file')

data.append({'test': 1})

# extend is an efficient way to append several elements
data.extend([{'test': 1}, {'another_test': 2}])

print(data[1]) # random access

for i in data:
    print(i)

data.close() # close whe finish using data

# also support context manager
with jsonLine('my_file') as data:
    print(data[0])
```
