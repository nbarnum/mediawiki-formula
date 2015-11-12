mediawiki:
  pkg.installed:
    - name: mediawiki119
  file.managed:
    - name: /etc/httpd/conf.d/mediawiki.conf
    - source: salt://mediawiki/mediawiki.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - require:
      - pkg: mediawiki

mediawiki-config:
  file.managed:
    - source: salt://mediawiki/LocalSettings.php
    - name: /var/www/mediawiki119/LocalSettings.php
    - template: jinja
    - require:
      - file: mediawiki

apache:
  pkg.installed:
    - name: httpd
  service.running:
    - name: httpd
    - enable: True
    - require:
      - pkg: apache
      - service: mysql

mysql:
  pkg.installed:
    - name: mysql-server
  service.running:
    - name: mysqld
    - enable: True
    - require:
      - pkg: mysql

mysql-python:
  pkg.installed:
    - name: MySQL-python

mediawiki-schema:
  file.managed:
    - name: /root/mediawiki.sql
    - source: salt://mediawiki/mediawiki.sql

mediawiki-users-schema:
  file.managed:
    - name: /root/mediawiki-users.sql
    - source: salt://mediawiki/mediawiki-users.sql
    - template: jinja

mediawiki-db:
  mysql_database.present:
    - name: my_wiki

mediawiki-tables:
  cmd.run:
    - name: mysql -u root my_wiki < /root/mediawiki.sql
    - unless: 'test -e /var/lib/mysql/my_wiki/page.frm'
    - require:
      - file: mediawiki-schema
      - mysql_database: mediawiki-db

mediawiki-users:
  cmd.run:
    - name: mysql -u root my_wiki < /root/mediawiki-users.sql
    - unless: 'test -e /var/lib/mysql/my_wiki/user.frm'
    - require:
      - cmd: mediawiki-tables
      - file: mediawiki-users-schema
      - mysql_database: mediawiki-db
