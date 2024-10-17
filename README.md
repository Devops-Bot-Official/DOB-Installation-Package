# **DevOps-Bot Installation and Usage Guide**

Welcome to the **DevOps-Bot** repository! This guide will help you set up and use the DevOps-Bot tool for automating your DevOps workflows.

---

## **Table of Contents**
1. [Overview](#overview)
2. [Features](#features)
3. [Prerequisites](#prerequisites)
4. [Installation](#installation)
5. [Usage](#usage)
6. [Configuration](#configuration)
7. [FAQ](#faq)
8. [Contributing](#contributing)
9. [License](#license)

---

## **Overview**
The **DevOps-Bot** is an Infrastructure-as-a-Service (IaaS) automation tool designed to streamline the management of cloud resources, configuration management, and orchestration of services across multiple cloud providers.

It combines the capabilities of **Terraform** for infrastructure provisioning and **Ansible** for configuration management, providing a unified interface for managing DevOps workflows.

---

## **Features**
- **Multi-cloud support**: Manage resources on AWS, GCP, and Azure.
- **Infrastructure provisioning**: Create and manage VPCs, EC2 instances, Kubernetes clusters, and more.
- **Configuration management**: Automate server configuration and application deployment.
- **State management**: Track and update infrastructure state similar to Terraform.
- **Scriptable workflows**: Use YAML files to define and execute tasks.

---

## **Prerequisites**
Before you begin, ensure you have met the following requirements:

- Operating System: Linux or macOS (Windows support coming soon)
- Python 3.7 or higher installed
- Git installed for version control
- SSH keys configured for GitHub (for cloning and pushing changes)
- `wget` and `unzip` installed (for downloading and extracting installation packages)

---

## **Installation**

### 1. **Download the Precompiled Binary**
You can download the precompiled binary from the GitHub repository releases:

```bash
wget https://github.com/Deeeye/DOB-Installation-Package/raw/main/dob.zip -O dob.zip
```

### 2. **Extract the Archive**
Unzip the downloaded `dob.zip` file:

```bash
unzip dob.zip
```

If you prefer to use the tar file, download and extract the tar archive:

```bash
wget https://github.com/Deeeye/DOB-Installation-Package/raw/main/dob.tar.gz -O dob.tar.gz
tar -xzvf dob.tar.gz
```

### 3. **Move the Executable to a Directory in Your $PATH**
(Optional) You can move the `dob` executable to a directory in your system's `$PATH` so that it can be accessed from anywhere:

```bash
sudo mv dob /usr/local/bin/
```

### 4. **Run the Binary**
After extracting the binary, navigate to the extracted folder and run the tool:

```bash
./dob --help
```

This will show a list of available commands and options for the DevOps-Bot tool.

---

## **Usage**
Once installed, you can use the `dob` command to see the available options and commands:

```bash
dob --help
```

To view the version of DevOps-Bot:

```bash
dob --version
```

### **Common Commands**

- **View Help**:

  ```bash
  dob --help
  ```

- **Execute a Sample Command**:

  ```bash
  dob sample-command
  ```

---

## **Configuration**
Configuration details will be added soon. Stay tuned!

---
## Loop and Conditions

This document explains how to use loops and conditions within the `DevOps-Bot` configuration YAML file. Loops allow you to create multiple instances or resources dynamically, while conditions allow you to control whether certain resources are provisioned based on variables or other logic.

### Table of Contents

1. [Loops](#loops)
2. [Conditions](#conditions)
3. [Combined Loops and Conditions](#combined-loops-and-conditions)
4. [Advanced Loops and Indexing](#advanced-loops-and-indexing)
5. [Retry Mechanism in Loops](#retry-mechanism-in-loops)

---

## Loops

Loops allow you to dynamically create multiple resources by defining variations within each loop item.

### Example 1: Looping Through EC2 Instances

```yaml
resources:
  ec2_instances:
    - name: "EC2-Instance"
      instance_type: "t2.micro"
      ami_id: "ami-12345678"
      key_name: "my-key"
      security_group: "sg-12345"
      subnet_id: "subnet-12345"
      loop:
        - { name_suffix: "dev", instance_type: "t2.micro" }
        - { name_suffix: "prod", instance_type: "t2.small" }
        - { name_suffix: "stage", instance_type: "t2.medium" }
```

**How it works**:
- The loop iterates through the three different configurations (`dev`, `prod`, and `stage`).
- The resulting instance names will be `EC2-Instance-dev`, `EC2-Instance-prod`, and `EC2-Instance-stage`, with their respective instance types.
  
**Result**:
- Creates 3 EC2 instances with different instance types and names.

---

## Conditions

Conditions allow you to control whether specific resources are created based on the evaluation of variables or logic.

### Example 2: Conditional Resource Provisioning

```yaml
resources:
  ec2_instances:
    - name: "EC2-Prod-Instance"
      instance_type: "t2.large"
      ami_id: "ami-0987654321"
      key_name: "prod-key"
      security_group: "sg-67890"
      subnet_id: "subnet-67890"
      condition: 'variables["env"] == "prod"'
```

**How it works**:
- The `condition` field checks if the environment variable (`env`) is set to `prod`.
- If `env` is not `prod`, this EC2 instance will not be created.

**Result**:
- This resource is only created when the condition `variables["env"] == "prod"` is true.

---

## Combined Loops and Conditions

You can combine loops and conditions to make your configuration more dynamic.

### Example 3: Loop with Conditions

```yaml
resources:
  ec2_instances:
    - name: "EC2-Instance"
      instance_type: "t2.micro"
      ami_id: "ami-12345678"
      key_name: "my-key"
      security_group: "sg-12345"
      subnet_id: "subnet-12345"
      loop:
        - { name_suffix: "dev", instance_type: "t2.micro", condition: 'variables["env"] == "dev"' }
        - { name_suffix: "prod", instance_type: "t2.large", condition: 'variables["env"] == "prod"' }
        - { name_suffix: "stage", instance_type: "t2.medium", condition: 'variables["env"] == "stage"' }
```

**How it works**:
- Each loop item has its own condition.
- Only the instances whose conditions evaluate to `true` will be created.
  
**Result**:
- If `env` is set to `prod`, only the `prod` instance will be created.
- If `env` is set to `stage`, only the `stage` instance will be created, and so on.

---

## Advanced Loops and Indexing

You can add advanced features to loops like index values for each iteration, which can be useful for naming or other dynamic configurations.

### Example 4: Loop with Index

```yaml
resources:
  ec2_instances:
    - name: "EC2-Instance"
      instance_type: "t2.micro"
      ami_id: "ami-12345678"
      key_name: "my-key"
      security_group: "sg-12345"
      subnet_id: "subnet-12345"
      loop:
        - { name_suffix: "A", instance_type: "t2.micro" }
        - { name_suffix: "B", instance_type: "t2.small" }
        - { name_suffix: "C", instance_type: "t2.medium" }
        - { name_suffix: "D", instance_type: "t2.large", loop_index: 1 }
```

**How it works**:
- You can manually add `loop_index` or other custom keys inside the loop item to differentiate resources.
- This allows custom naming patterns or other dynamic properties based on the index.

**Result**:
- The resources will be named `EC2-Instance-A`, `EC2-Instance-B`, `EC2-Instance-C`, and `EC2-Instance-D`.

---

## Retry Mechanism in Loops

You can add a retry mechanism to handle failures in loop iterations, allowing for a more resilient resource creation process.

### Example 5: Retry in Loops

```yaml
resources:
  ec2_instances:
    - name: "EC2-Instance"
      instance_type: "t2.micro"
      ami_id: "ami-12345678"
      key_name: "my-key"
      security_group: "sg-12345"
      subnet_id: "subnet-12345"
      loop:
        - { name_suffix: "dev", instance_type: "t2.micro", retry: 3 }
        - { name_suffix: "prod", instance_type: "t2.large", retry: 2 }
        - { name_suffix: "stage", instance_type: "t2.medium", retry: 5 }
```

**How it works**:
- Each loop iteration has a retry mechanism built in, defined by the `retry` field.
- If a resource fails to be created, the system will retry up to the specified number of attempts (`retry`).

**Result**:
- If creating the `dev` instance fails, it will retry up to 3 times before giving up.
- The `prod` instance will retry 2 times, and the `stage` instance will retry 5 times.

---

## Full Example

### Example 6: Full YAML Configuration with Loops and Conditions

```yaml
variables:
  env: "prod"

resources:
  vpcs:
    - name: "Prod-VPC"
      cidr_block: "10.0.0.0/16"
      condition: 'variables["env"] == "prod"'

  ec2_instances:
    - name: "EC2-Instance"
      instance_type: "t2.micro"
      ami_id: "ami-12345678"
      key_name: "my-key"
      security_group: "sg-12345"
      subnet_id: "subnet-12345"
      loop:
        - { name_suffix: "dev", instance_type: "t2.micro", condition: 'variables["env"] == "dev"', retry: 2 }
        - { name_suffix: "prod", instance_type: "t2.large", condition: 'variables["env"] == "prod"', retry: 3 }
        - { name_suffix: "stage", instance_type: "t2.medium", condition: 'variables["env"] == "stage"', retry: 4 }

tasks:
  - name: "Install Nginx"
    action: "INSTALL"
    package: "nginx"
    loop:
      - { server: "server1" }
      - { server: "server2" }
```

**Explanation**:
- This full example creates a VPC only if the `env` variable is set to `prod`.
- It also loops through EC2 instances with different configurations (`dev`, `prod`, `stage`), using conditions to decide which instance to create.
- The `tasks` section loops through servers to install a package (`nginx`) on each one.

---
## Host Management Functions

#### Parameters:
- **`user_id`**: The unique identifier for the host (e.g., instance name).
- **`private_ip`**: The private IP address of the host.
- **`category`**: (Optional) A category or section under which the entry will be saved, such as `dev`, `prod`, or `ops`. If not provided, the entry is saved in the default section.
```

#### Hosts File Example:
If an entry is added with the category `dev`, the hosts file will look like this:
```plaintext
## This is the default section ##
192.168.0.100 webserver1
192.168.0.101 webserver2

## This is the dev section ##
[dev]
192.168.0.1 jenkins-server

## This is the prod section ##
[prod]
192.168.0.2 prod-db-server
```

---

```

#### Parameters:
- **`identifier`**: The unique identifier of the host to retrieve.
- **`category`**: (Optional) The category under which to search for the host. If not provided, it searches globally.

#### Example Usage:
```bash
private_ip, user_id = get_host_entry('jenkins-server', 'dev')
```

---

## Task Execution in Screenplay

The `tasks` section in your screenplay allows you to define specific actions to be executed on remote servers. You can categorize your tasks based on environments, such as `dev`, `prod`, or `ops`, and target specific servers or entire categories of servers.

### Task Structure:

Each task consists of the following fields:
- **`name`**: The name of the task.
- **`action`**: The type of action to perform, such as `RUN`, `TRANSFER`, `INSTALL`, etc.
- **`command`**: The command to be executed on the remote server.
- **`src`**: The source path (for file transfers).
- **`dest`**: The destination path (for file transfers).
- **`direction`**: Whether to upload or download files.
- **`identifiers`**: The specific server or `ALL` for all servers within the category.
- **`category`**: The category where the task will run. Defaults to `ALL`.

### Example YAML Configuration for Tasks:
```yaml
# This is the main configuration file for the screenplay execution

remote-server:
  - identifiers: "dev-server1"
    username: "ubuntu"
    category: "dev"
  
  - identifiers: "prod-server1"
    username: "ec2-user"
    category: "prod"

tasks:
  - name: "Update Dev Servers"
    action: "RUN"
    command: "sudo apt-get update -y"
    identifiers: "ALL"
    category: "dev"  # Run on all servers under 'dev' category

  - name: "Restart Nginx"
    action: "RUN"
    command: "sudo systemctl restart nginx"
    identifiers: "prod-server1"
    category: "prod"  # Run only on 'prod-server1'

  - name: "Transfer Backup Script"
    action: "TRANSFER"
    src: "/local/path/backup.sh"
    dest: "/remote/path/backup.sh"
    direction: "upload"
    identifiers: "ALL"
    category: "ops"  # Transfer script to all servers in 'ops' category
```

### Explanation of Task Execution:

1. **Category-Based Execution**: You can target specific servers within a category or run the task on all servers in that category. For example, setting `category: dev` and `identifiers: ALL` will run the task on all `dev` servers.
2. **Specific Host Targeting**: You can target individual hosts within a category by specifying both the `identifiers` and `category`.
3. **Transfer and Run Commands**: Tasks support various actions, including file transfers and command execution on remote servers.

### Example of Hosts File with Tasks:
After saving a host entry using `add_host_entry` and running tasks, the hosts file might look like this:
```plaintext
## Default Section ##
192.168.0.100 webserver1

[dev]
192.168.0.1 dev-server1

[prod]
192.168.0.2 prod-server1
```

---

## Conclusion:

- The `add_host_entry` and `get_host_entry` functions allow you to organize, retrieve, and work with categorized host entries in your DevOps environment.
- The `tasks` feature in your screenplay allows for flexible execution of commands and file transfers, either globally or on a category-specific level.


---
## Overview
The `tasks` function in DevOps-Bot allows users to execute a variety of actions on remote servers or cloud instances. Tasks can range from running shell commands to copying files, downloading resources, managing system services, and more. This functionality is highly flexible and enables users to automate their operations efficiently.

The tasks are defined in a YAML configuration file and support both specifying a particular server or executing actions across multiple servers that belong to a specific category.

### Structure of Task Configuration
The task configuration resides under the `tasks` section in the YAML file. Each task can have several fields, and they should be defined with the following parameters:

### Parameters
- **name** (Required): The name of the task. This helps in identifying tasks in logs and tables.
- **action** (Required): The type of action to perform. Available actions include:
  - **RUN**: Execute a command on the remote server.
  - **COPY**: Copy files from one location to another.
  - **DOWNLOAD**: Download a file from a URL to a specified location.
  - **CREATE**: Create a directory on the remote server.
  - **MOVE**: Move files from one location to another.
  - **DELETE**: Delete files or directories.
  - **LINK**: Open a specified URL.
  - **TRANSFER**: Transfer files (upload or download).
  - **ATTACH**: Attach an AWS volume to an instance.
  - **DETACH**: Detach an AWS volume from an instance.
  - **INSTALL**: Install a package.
  - **START_SERVICE**: Start a system service.
  - **STOP_SERVICE**: Stop a system service.
  - **CHECK_SERVICE**: Check the status of a system service.
- **identifiers** (Optional): A specific server identifier. Use `ALL` to execute the task across all servers or provide the server name.
- **command** (Optional): The shell command to execute. This is applicable when `action` is set to **RUN**.
- **package** (Optional): The name of the package to install, applicable when `action` is **INSTALL**.
- **service** (Optional): The name of the service to start, stop, or check, applicable when using **START_SERVICE**, **STOP_SERVICE**, or **CHECK_SERVICE**.
- **category** (Optional): The category of servers (e.g., `dev`, `prod`) on which the task should be executed.

### Example YAML Configuration
Below is an example of a YAML configuration that uses the `tasks` functionality:

```yaml
version: "1.0"

remote-server:
  - identifiers: "opp-server"
    username: "root"
    category: "dev"

tasks:
  - name: Determine OS type
    action: RUN
    command: |
      if [ -f /etc/debian_version ]; then
        echo "Ubuntu" > /etc/os_type
      elif [ -f /etc/redhat-release ]; then
        echo "CentOS" > /etc/os_type
      fi
    identifiers: "opp-server"
    category: "dev"

  - name: Create Directory
    action: CREATE
    path: /tmp/new_directory
    identifiers: "ALL"
    category: "dev"

  - name: Install Curl
    action: INSTALL
    package: curl
    identifiers: "opp-server"
    category: "dev"

  - name: Start Apache Service
    action: START_SERVICE
    service: apache2
    identifiers: "opp-server"
    category: "dev"
```

### Execution Overview
- **Task Name**: This is displayed in logs, which makes it easy for users to track what each task is doing.
- **Actions**: This field specifies what kind of operation is to be performed.
- **Identifiers and Categories**: These fields help in determining the target servers on which actions should be taken. This allows users to execute tasks either across all servers in a category or on specific servers.

### Example Task Review Table
When executing a task configuration, a table similar to the following will be displayed for review before proceeding:

```
+----+---------------+---------------------------------------+
|    | Task Name     | Determine OS type                     |
+====+===============+=======================================+
| +  | Action        | RUN                                   |
+----+---------------+---------------------------------------+
| +  | Identifiers   | opp-server                            |
+----+---------------+---------------------------------------+
| +  | Category      | dev                                   |
+----+---------------+---------------------------------------+
| +  | Command       | if [ -f /etc/debian_version ]; then   |
|    |               | echo "Ubuntu" > /etc/os_type         |
|    |               | elif [ -f /etc/redhat-release ]; then |
|    |               | echo "CentOS" > /etc/os_type         |
|    |               | fi                                    |
+----+---------------+---------------------------------------+
```

### Available Actions and Usage
1. **RUN**: Execute a command on a server.
   ```yaml
   - name: Run Diagnostics
     action: RUN
     command: "df -h"
     identifiers: "opp-server"
     category: "dev"
   ```

2. **CREATE**: Create a directory.
   ```yaml
   - name: Create Temp Directory
     action: CREATE
     path: /tmp/test_dir
     identifiers: "ALL"
     category: "dev"
   ```

3. **START_SERVICE / STOP_SERVICE**: Start or stop a service.
   ```yaml
   - name: Start Apache Server
     action: START_SERVICE
     service: apache2
     identifiers: "opp-server"
     category: "prod"
   ```

4. **INSTALL**: Install a package.
   ```yaml
   - name: Install Git
     action: INSTALL
     package: git
     identifiers: "ALL"
     category: "dev"
   ```

### Notes on Usage
- **Category Matching**: If `category` is specified, the action is only executed on servers within that category.
- **Error Handling**: If an error occurs (e.g., if the identifier is not found), the system will print an error message, and the execution for that specific task will be skipped.
- **Task Review Table**: The review table ensures that the user gets an overview of all tasks, actions, and targets before confirming the execution, which prevents mistakes.


## **FAQ**
### 1. **What is DevOps-Bot?**
DevOps-Bot is an automation tool for managing cloud infrastructure and services across multiple providers using YAML-based configurations.

### 2. **Which cloud providers does it support?**
DevOps-Bot currently supports AWS, GCP, and Azure.

---

## **Contributing**
Currently, I am running a trial version of this tool. Contributions are not yet open to the public, but I welcome your reviews and feedback. 

If you are interested in creating YouTube tutorials or DevOps content using this tool, feel free to reach out to me. You can connect with me on [LinkedIn](linkedin.com/in/mohamed-sesay-323902302) for more information and collaboration opportunities.

---
![dob-logo](IMG_2055.png)
---

## **License**
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.




