# KDB Virtual Database (vdb)

In KDB/Q, it's common to isolate vendor datasets in different databases. The problem is KDB/Q only allows you to load one database into a process at a time. This becomes onerous for the user that wants to join on data across different databases. There would need to be a dedicated HDB process per database. The user queries each process, pulls the data over IPC, and then does the join on their process. There's serious performance penalties for doing this (ser/de, copy ipc, memory overhead).

The alternative is a VDB where multiple real databases can be collated to look and feel like a real one. Tables continue to be memory mapped in and native joins work as expected.

This project contains 2 scripts:
- `test.q` - used to create test databases
- `vdb.q` - creates the vdbs by scanning source databases and generates a shell script with a list of dated directories to create, symlinks to the symfiles, and symlinks to the partitioned tables.

Considerations:
- Sym files should have a unique name per real database.
- When a new date is added, the VDB needs to be updated as well.
- Databases have different date ranges, but kdb keeps only one 'date' vector. Consider squaring out the real databases to have the same start date.

## Test Database

```
q test.q -source ~/test_data/real
```

## Build VDB

```
q vdb.q -source ~/test_data/real -dest ~/test_data/vdb -exec 0
```

## Example

```
real
├── REF
│   ├── 2024.01.01
│   │   ├── calendar
│   │   ├── corp_actions
│   │   └── sec_master
│   ├── 2024.01.02
│   │   ├── calendar
│   │   ├── corp_actions
│   │   └── sec_master
..
│   └── sym_REF
└── TAQ
    ├── 2024.01.01
    │   ├── quote
    │   └── trade
    ├── 2024.01.02
    │   ├── quote
    │   └── trade
    ...
    └── sym_TAQ

```

The vdb utilizes symlinks to collate tables from various databases.

```
vdb
├── 2024.01.01
│   ├── calendar -> /home/jp/test_data/real/REF/2024.01.01/calendar
│   ├── corp_actions -> /home/jp/test_data/real/REF/2024.01.01/corp_actions
│   ├── quote -> /home/jp/test_data/real/TAQ/2024.01.01/quote
│   ├── sec_master -> /home/jp/test_data/real/REF/2024.01.01/sec_master
│   └── trade -> /home/jp/test_data/real/TAQ/2024.01.01/trade
├── 2024.01.02
│   ├── calendar -> /home/jp/test_data/real/REF/2024.01.02/calendar
│   ├── corp_actions -> /home/jp/test_data/real/REF/2024.01.02/corp_actions
│   ├── quote -> /home/jp/test_data/real/TAQ/2024.01.02/quote
│   ├── sec_master -> /home/jp/test_data/real/REF/2024.01.02/sec_master
│   └── trade -> /home/jp/test_data/real/TAQ/2024.01.02/trade
...
├── sym_REF -> /home/jp/test_data/real/REF/sym_REF
└── sym_TAQ -> /home/jp/test_data/real/TAQ/sym_TAQ
```
