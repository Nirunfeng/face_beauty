
create table if not exists Image(
    id          int(3)              not null        primary key,
    path        mediumtext(1000)    not null
)engine=innodb auto_increment=100;
