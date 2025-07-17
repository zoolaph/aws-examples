| Option | Meaning                                           | Example               |
| ------ | ------------------------------------------------- | --------------------- |
| `-f`   | True if the file exists and is a **regular file** | `[ -f filename.txt ]` |
| `-d`   | True if the file exists and is a **directory**    | `[ -d /path/to/dir ]` |
| `-e`   | True if the file or directory **exists**          | `[ -e somefile ]`     |
| `-s`   | True if file exists and is **not empty**          | `[ -s file.txt ]`     |
| `-r`   | True if file is **readable**                      | `[ -r file.txt ]`     |
| `-w`   | True if file is **writable**                      | `[ -w file.txt ]`     |
| `-x`   | True if file is **executable**                    | `[ -x script.sh ]`    |

# Essential jq Operations Reference
## Core Operations

| Operation | Description | Example | Result |
|-----------|-------------|---------|---------|
| `.` | Identity - returns input unchanged | `echo '{"name":"john"}' \| jq '.'` | `{"name":"john"}` |
| `.key` | Access object property | `echo '{"name":"john"}' \| jq '.name'` | `"john"` |
| `.key.subkey` | Access nested property | `echo '{"user":{"name":"john"}}' \| jq '.user.name'` | `"john"` |
| `.[0]` | Access array element by index | `echo '[1,2,3]' \| jq '.[0]'` | `1` |
| `.[]` | Iterate through array/object values | `echo '[1,2,3]' \| jq '.[]'` | `1` `2` `3` |

## Array Operations

| Operation | Description | Example | Result |
|-----------|-------------|---------|---------|
| `.[0:3]` | Array slice (indices 0-2) | `echo '[1,2,3,4,5]' \| jq '.[0:3]'` | `[1,2,3]` |
| `length` | Get array/object/string length | `echo '[1,2,3]' \| jq 'length'` | `3` |
| `reverse` | Reverse array order | `echo '[1,2,3]' \| jq 'reverse'` | `[3,2,1]` |
| `sort` | Sort array | `echo '[3,1,2]' \| jq 'sort'` | `[1,2,3]` |
| `sort_by(.key)` | Sort by object property | `echo '[{"age":30},{"age":20}]' \| jq 'sort_by(.age)'` | `[{"age":20},{"age":30}]` |
| `unique` | Remove duplicates | `echo '[1,2,2,3]' \| jq 'unique'` | `[1,2,3]` |
| `add` | Concatenate arrays or sum numbers | `echo '[[1,2],[3,4]]' \| jq 'add'` | `[1,2,3,4]` |

## Filtering & Selection

| Operation | Description | Example | Result |
|-----------|-------------|---------|---------|
| `select(.key == "value")` | Filter objects by condition | `echo '[{"type":"A"},{"type":"B"}]' \| jq '.[] \| select(.type == "A")'` | `{"type":"A"}` |
| `map(.key)` | Transform each element | `echo '[{"name":"john"},{"name":"jane"}]' \| jq 'map(.name)'` | `["john","jane"]` |
| `map(select(.key))` | Filter and transform | `echo '[{"active":true,"name":"john"},{"active":false,"name":"jane"}]' \| jq 'map(select(.active))'` | `[{"active":true,"name":"john"}]` |

## Useful Flags

| Flag | Description | Example | Effect |
|------|-------------|---------|---------|
| `-r` | Raw output (no quotes) | `echo '{"name":"john"}' \| jq -r '.name'` | `john` (instead of `"john"`) |
| `-c` | Compact output (no formatting) | `echo '{"name": "john"}' \| jq -c '.'` | `{"name":"john"}` |
| `-n` | Don't read input | `jq -n '{"created": now}'` | Creates new JSON |
| `-s` | Read entire input as array | `echo '1\n2' \| jq -s 'add'` | `3` |

## Conditional & Logic

| Operation | Description | Example | Result |
|-----------|-------------|---------|---------|
| `if-then-else` | Conditional logic | `echo '{"age":25}' \| jq 'if .age >= 18 then "adult" else "minor" end'` | `"adult"` |
| `//` | Alternative operator | `echo '{"name":null}' \| jq '.name // "unknown"'` | `"unknown"` |
| `and`, `or`, `not` | Boolean operations | `echo '{"a":true,"b":false}' \| jq '.a and .b'` | `false` |

## Advanced Operations

| Operation | Description | Example | Result |
|-----------|-------------|---------|---------|
| `group_by(.key)` | Group array by property | `echo '[{"type":"A","val":1},{"type":"A","val":2}]' \| jq 'group_by(.type)'` | Groups by type |
| `has("key")` | Check if key exists | `echo '{"name":"john"}' \| jq 'has("name")'` | `true` |
| `keys` | Get object keys or array indices | `echo '{"a":1,"b":2}' \| jq 'keys'` | `["a","b"]` |
| `values` | Get object values | `echo '{"a":1,"b":2}' \| jq '.[]'` | `1` `2` |
| `type` | Get value type | `echo '{"name":"john","age":30}' \| jq '.age \| type'` | `"number"` |

## String Operations

| Operation | Description | Example | Result |
|-----------|-------------|---------|---------|
| `tostring` | Convert to string | `echo '123' \| jq 'tostring'` | `"123"` |
| `tonumber` | Convert to number | `echo '"123"' \| jq 'tonumber'` | `123` |
| `split("delimiter")` | Split string | `echo '"a,b,c"' \| jq 'split(",")'` | `["a","b","c"]` |
| `join("delimiter")` | Join array to string | `echo '["a","b","c"]' \| jq 'join(",")'` | `"a,b,c"` |

## Common Patterns

| Pattern | Use Case | Example |
|---------|----------|---------|
| `.[] \| select(.key == "value") \| .otherkey` | Find and extract | Filter specific items and get their properties |
| `map(select(.active)) \| length` | Count filtered items | Count how many items meet criteria |
| `sort_by(.date) \| reverse \| .[0:5]` | Top N by date | Get 5 most recent items |
| `group_by(.category) \| map({category: .[0].category, count: length})` | Group and count | Summarize data by category |