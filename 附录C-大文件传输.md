- gzip + scp

  ```
  server1$ gzip -c /backup/mydb/mytable.MYD > mytable.MYD.gz
  server1$ scp mytable.MYD.gz root@server2:/var/lib/myql/mydb/
  server2$ gunzip /var/lib/mysql/mydb/mytable.MYD.gz
  ```

- gzip + ssh

  `server1$ gzip -c /backup/mydb/mytable.MYD | ssh root@server2"gunzip -c - > /var/lib/mysql/mydb/mytable.MYD"`

- nc + gzip

  ```
  server2$ nc -l -p 12345 | gunzip -c - > /var/lib/mysql/mydb/mytable.MYD
  server1$ gzip -c - /var/lib/mysql/mydb/mytable.MYD | nc -q 1 server2 12345
  ```

- nc + tar

  tar 可以处理文件名和目录

  ```
  server2$ nc -l -p 12345 | tar xvzf -
  server1$ tar cvzf - /var/lib/mysql/mydb/mytable.MYD | nc -q 1 server2 12345
  ```

- rsync

  校验文件完整性，使用md5sum 或者其它方法，但是完整扫描非常昂贵，而压缩文件至少包括一个循环冗余检测（CRC），它应该可以发现任何错误，一般不需要做错误检测。