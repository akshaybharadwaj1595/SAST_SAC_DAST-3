# DevSecOps CI/CD Pipeline
This project shows an end-to-end CI/CD pipeline where Jenkins is used as an orchestrator to perform SAST, DAST, Container Scanning, and Software Composition Analysis (SCA).

![image](https://github.com/Catheren/devsecops-jenkins-sast-sca-iac-cs-dast-e2e-repo-main/assets/94724571/f376b88a-7c63-4f12-889a-4336afd2a4b6)


This repository contains a Jenkins pipeline configuration for a DevSecOps CI/CD process. The pipeline includes stages for compiling code, running static and dynamic security analysis, building Docker images, and performing container security scans.

_**Note:**EasyBuggy is a broken web application to understand the behavior of bugs and vulnerabilities, for example, [memory leak, deadlock, JVM crash, SQL injection and so on](https://github.com/k-tamura/easybuggy#clock4-easybuggy-can-reproduce)._

## Table of Contents
1. [Prerequisites](#Prerequisites)
2. [Pipeline Stages](#Pipeline-Stages)
3. [Compile and Run Sonar Analysis](#Compile-and-Run-Sonar-Analysis)
4. [Build](#Build)
5. [Run Container Scan](#Run-Container-Scan)
6. [Run Snyk SCA](#Run-Snyk-SCA)
7. [Run DAST Using ZAP](#Run-DAST-Using-ZAP)
8. [Usage](#Usage)
9. [Credentials](#Credentials)


## Prerequisites
- Jenkins installed and configured
- Maven 3.8.7
- Docker, Docker Hub login
- SonarQube server, SonarCloud login
- Snyk CLI, Snyk login for Authentication
- OWASP ZAP
- AWS EC2 Instance to set up the EasBuggy application

## Pipeline Stages
**1. Compile and Run Sonar Analysis**

**Purpose**: Compile the code, run tests, and perform static code analysis using SonarQube.
    
**Details**: This stage uses Maven to compile the project and run SonarQube analysis, ignoring test failures. The results are sent to the configured SonarQube server.

**2. Build**

**Purpose**: Build a Docker image for the application.

**Details**: This stage logs into the [Docker registry](https://hub.docker.com/) and builds the Docker image using the application's Dockerfile.

**3. Run Container Scan**

**Purpose**: Scan the Docker image for vulnerabilities using Snyk.

**Details**: This stage uses Snyk to perform a security scan of the Docker image and reports any vulnerabilities found.

**4. Run Snyk SCA**

**Purpose**: Scan the application dependencies for vulnerabilities using Snyk's Software Composition Analysis (SCA) tool.

**Details**: This stage integrates Snyk with Maven to check for vulnerabilities in the project dependencies.


**5. Run DAST Using ZAP**

**Purpose**: Perform Dynamic Application Security Testing (DAST) using OWASP ZAP.

**Details**: This stage runs OWASP ZAP in command-line mode to scan the web application for vulnerabilities and outputs the results to an HTML file. I setup an ec2 instance in AWS to run the application so that ZAP can test it.

## Results
**1. The build result on Jenkins**
![image](https://github.com/Catheren/devsecops-jenkins-sast-sca-iac-cs-dast-e2e-repo-main/assets/94724571/4b557095-0f24-478f-8d5e-6a3187a51d5a)


**2. SonarQube Output**
![image](https://github.com/Catheren/devsecops-jenkins-sast-sca-iac-cs-dast-e2e-repo-main/assets/94724571/c2beb9df-651b-4a9a-9d6d-74767210b1c5)

**3. ZAP Output can be found [here](ZAPOutput.html)**
![image](https://github.com/Catheren/End-to-end-Devsecops-Pipeline/assets/94724571/3414e32c-ca2f-4c64-a99d-102726fdc662)


**4. Jenkins Console Output can be found [here.](JenkinsConsoleOutput)**






## Usage

To use this pipeline, follow these steps:
1. **Set up Jenkins**: Ensure Jenkins is installed and configured with the required plugins(Docker Pipeline) and tools .
2. **Configure Credentials**: Add the necessary credentials in Jenkins for [SonarQube[](https://sonarcloud.io/login) (SONAR_TOKEN), [Docker](https://hub.docker.com/), and [Snyk](https://snyk.io/)(SNYK_TOKEN).
3. **Set up the Repository**: Clone this repository and configure it as a Jenkins pipeline.
4. **Run the Pipeline**: Trigger the pipeline from Jenkins to start the CI/CD process.

## Credentials

Ensure the following credentials are configured in Jenkins:

- SONAR_TOKEN: Token for authenticating with SonarQube.
- dockerlogin: Docker registry login credentials.
- SNYK_TOKEN: Token for authenticating with Snyk.




EasyBuggy Vulnerable Web App Modified 
=

EasyBuggy is a broken web application in order to understand behavior of bugs and vulnerabilities, for example, [memory leak, deadlock, JVM crash, SQL injection and so on](https://github.com/k-tamura/easybuggy#clock4-easybuggy-can-reproduce).


:clock4: Quick Start
To run EasyBuggy, perform the following steps:
-

    $ mvn clean install

( or ``` java -jar easybuggy.jar ``` or deploy ROOT.war on your servlet container with [the JVM options](https://github.com/k-tamura/easybuggy/blob/master/pom.xml#L204). )

Access to

    http://localhost:8080

:clock4: Quick Start(Docker)
-

    $ docker build . -t easybuggy:local # Build container image
    $ docker run -p 8080:8080 easybuggy:local # Start easybuggy

Access to

    http://localhost:8080

### To stop:

  Use <kbd>CTRL</kbd>+<kbd>C</kbd> ( or access to: http://localhost:8080/exit )



:clock4: EasyBuggy can reproduce:
-

* Troubles

  * Memory Leak (Java heap space)
  * Memory Leak (PermGen space)
  * Memory Leak (C heap space)
  * Deadlock (Java)
  * Deadlock (SQL)
  * Endless Waiting Process
  * Infinite Loop
  * Redirect Loop
  * Forward Loop
  * JVM Crash
  * Network Socket Leak
  * Database Connection Leak
  * File Descriptor Leak 
  * Thread Leak 
  * Mojibake
  * Integer Overflow
  * Round Off Error
  * Truncation Error
  * Loss of Trailing Digits

* Vulnerabilities

  * XSS (Cross-Site Scripting)
  * SQL Injection
  * LDAP Injection
  * Code Injection
  * OS Command Injection (OGNL Expression Injection)
  * Mail Header Injection
  * Null Byte Injection
  * Extension Unrestricted File Upload
  * Size Unrestricted File Upload
  * Open Redirect
  * Brute-force Attack
  * Session Fixation Attacks
  * Verbose Login Error Messages
  * Dangerous File Inclusion
  * Directory Traversal
  * Unintended File Disclosure
  * CSRF (Cross-Site Request Forgery)
  * XEE (XML Entity Expansion)
  * XXE (XML eXternal Entity)
  * Clickjacking

* Performance Degradation

  * Slow Regular Expression Parsing
  * Delay of creating string due to +(plus) operator
  * Delay due to unnecessary object creation

* Errors

  * AssertionError
  * ExceptionInInitializerError
  * FactoryConfigurationError
  * GenericSignatureFormatError
  * NoClassDefFoundError
  * OutOfMemoryError (Java heap space) 
  * OutOfMemoryError (Requested array size exceeds VM limit)
  * OutOfMemoryError (unable to create new native thread)
  * OutOfMemoryError (GC overhead limit exceeded)
  * OutOfMemoryError (PermGen space)
  * OutOfMemoryError (Direct buffer memory)
  * StackOverflowError
  * TransformerFactoryConfigurationError
  * UnsatisfiedLinkError

