

01. Connecto with the database

```bash
docker exec -it postgres-demo psql -U demo -d demo_db
```

02. List all databases


```sql
demo_db-# \l
                                               List of databases
     Name      | Owner | Encoding | Locale Provider | Collate | Ctype | Locale | ICU Rules | Access privileges 
---------------+-------+----------+-----------------+---------+-------+--------+-----------+-------------------
 company_db    | demo  | UTF8     | libc            | C       | C     |        |           | 
 demo_db       | demo  | UTF8     | libc            | C       | C     |        |           | 
 ecommerce_db  | demo  | UTF8     | libc            | C       | C     |        |           | 
 library_db    | demo  | UTF8     | libc            | C       | C     |        |           | 
 postgres      | demo  | UTF8     | libc            | C       | C     |        |           | 
 template0     | demo  | UTF8     | libc            | C       | C     |        |           | =c/demo          +
               |       |          |                 |         |       |        |           | demo=CTc/demo
 template1     | demo  | UTF8     | libc            | C       | C     |        |           | =c/demo          +
               |       |          |                 |         |       |        |           | demo=CTc/demo
 university_db | demo  | UTF8     | libc            | C       | C     |        |           | 
(8 rows)

demo_db-# 
```
