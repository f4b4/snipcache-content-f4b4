# Find large files

The twenty largest files below the current directory, sizes human-readable:

```sh
find . -xdev -type f -printf '%s\t%p\n' | sort -nr | head -20 | numfmt --to=iec --field=1
```

Disk usage per top-level folder, largest last:

```sh
du -xh --max-depth=1 . | sort -h
```
