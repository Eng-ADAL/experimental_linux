
# empty-trash

A small Bash utility that provides a safer and more visible workflow for managing the Linux trash folder.

Instead of blindly clearing the trash, `empty-trash` lets you inspect what is inside, check disk usage, and clean it interactively.

---

## Features

- Interactive trash dashboard
- View trash size and file count
- Tree view of trash contents
- Detailed disk usage view
- Safe trash cleanup
- Automation flags for scripting

---

## Requirements

The following packages are required:

- `trash-cli`
- `tree`

On Debian/Ubuntu systems you can install them with:

```bash
sudo apt install trash-cli tree
````

---

## Installation

Clone the repository:

```bash
git clone https://github.com/Eng-ADAL/experiemental_linux/empty-trash.git
cd empty-trash
```

Run the installer:

```bash
./install.sh
```

This will install the command globally as:

```
/usr/local/bin/empty-trash
```

---

## Usage

### Interactive dashboard

```
empty-trash
```

Example output:

```
==========================================
               TRASH DASHBOARD
==========================================
Trash size: 120M
Files: 32
----------------------------------
```

Options inside the dashboard:

```
y  → empty trash
t  → tree view
d  → detailed disk usage
other → exit
```

---

### List trash contents

```
empty-trash --list
```

---

### Empty trash directly

```
empty-trash --clean
```

---

### Show version

```
empty-trash --version
```

---

### Show help

```
empty-trash --help
```

---

## Why this project exists

Linux is powerful, but the command line assumes the user knows exactly what they are doing.

A single wrong command can permanently delete files.

This project adds a small safety layer and better visibility when managing the trash directory from the terminal.

It also serves as a simple example of how Bash scripting can improve everyday workflows.

---

## License

MIT License

```

