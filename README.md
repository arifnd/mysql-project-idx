# MySQL Server Management on Project IDX

This repository contains scripts for managing MySQL server instances on Project IDX workspaces. The provided scripts allow you to start and stop MySQL server easily.

## Getting Started

To use these scripts, follow the instructions below:

### Prerequisites

Before using these scripts, ensure you have the following installed:

- **MySQL Server**: Make sure MySQL server is installed on your system.

- **Git**: Install Git on your system to clone this repository.

### Installation

1. Install MySQL on Project IDX by editing the `dev.nix `file in the `.idx `folder, add `pkgs.mysql80` to the packages list:

    ```nix
    packages = [
        # other packages
        pkgs.mysql80
    ];
    ```

2. Clone this repository to your local machine:

    ```bash
    git clone https://github.com/arifnd/mysql-project-idx.git
    ```

### Usage

#### Starting MySQL Server

To start the MySQL server, run the following command:

```bash
./mysql/start.sh
```

If you want to force start the server, you can use the `--force` option:

```bash
./mysql/start.sh --force
```

#### Stopping MySQL Server

To stop the MySQL server, run the following command:

```bash
./mysql/stop.sh
```

>Running the command above will delete your MySQL data.

## Contributing

Contributions are welcome! If you have suggestions, improvements, or encounter any issues, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.