# CSV Tools

A simple utility library and scripts to perform simple operations on CSV files.
At the moment, the following operations are supported:

 * Selecting specific columns (by index)
 * Filter rows, based on a specific field
 * Join two CSV files on a single column

## Installation


For now, `cd` to the root of this repo and run

```
rake install
```

## Examples

With the following data files

```sh
$ cat students.csv
student-id,name
1,Alice
2,Bob
3,Rob
4,Allie

$ cat marks.csv
student-id,Assignment 1,Assignment 2,Test
1,72,83,77
2,53,61,58
3,85,88,87
4,92,80,75
```

We can select specific columns

```sh
$ csv_select marks.csv 0 3
student-id,Test
1,77
2,58
3,87
4,75
```

Join two files

```sh
$ csv_join students.csv marks.csv student-id
student-id,name,Assignment 1,Assignment 2,Test
1,Alice,72,83,77
2,Bob,53,61,58
3,Rob,85,88,87
4,Allie,92,80,75
```

Let's save the output of the previous command in a file called `joined.csv`,
and keep only rows whose second column (i.e. at index 1) contains the string `ob`:

```sh
$ csv_join students.csv marks.csv student-id > joined.csv

$ csv_filter joined.csv 1 ob
student-id,name,Assignment 1,Assignment 2,Test
2,Bob,53,61,58
3,Rob,85,88,87
```
