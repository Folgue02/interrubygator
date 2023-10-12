# Interrubygator

A small project made mainly to learn Ruby. Asks questions to the user as if it was a test. Made with the purpose
to be a tool for studying.

## 1. Use

### 1.1 `.qstns` file

Interrubygator reads a file containing questions and answers. That file should have the following format:

```
Question no.1?
 Answer1
 Answer2
 @Right answer

Question no.2?
 Answer1
 @Right answer
 Answer3
```

(*This file would contain two questions*)


### 1.2 Prompt the whole file to the user

The following command would prompt the user all the questions listed in that file.
```sh
interrubygator -f questions.qstns
```

In the case of wanting to get those questions prompted in a random order use the `-s` flag.
```sh
interrubygator -f questions.qstns -s
```

## 2. Installation

To install Interrubygator use `rake install` as sudo (*NOTE: this Rakefile script only works on unix 
based systems*)

### 2.1 Requirements

- The ruby interpreter installed
- The rake gem (*comes preinstalled with the interpreter*)
