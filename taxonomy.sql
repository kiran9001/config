# create table topics!
create table topics (
    id int primary key auto_increment,
    name varchar(256),
    parent_id int null,
    type smallint not null,

    foreign key (parent_id) references topics(id),
    index(type)
);

# create table counters
create table counters (
    id char(8) primary key
);

# create table seed
create table seed (
    id int primary key
);

# insert 0 to 9
insert into seed values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

# amplify counters to have values from 0 to 999
INSERT into counters
SELECT CONCAT(s1.id, s2.id, s3.id) as n from seed as s1, seed as s2, seed as s3;

# inserting 50 categories
INSERT INTO topics(name, parent_id, type)
SELECT CONCAT("cat-", counter_id), NULL, 1
FROM (
    SELECT id as counter_id from counters limit 50
) t;

# inserting 50 * 100 sub-categories
INSERT INTO topics(name, parent_id, type)
SELECT CONCAT("subcat-", category_id, counter_id), category_id, 2
FROM (
    select categories.id as category_id, counters.id as counter_id FROM
        (
            (SELECT id from counters limit 100) counters,
            (SELECT id from topics where type = 1) categories
        )
) t;

# inserting 50 * 100 * 1000 topics
INSERT INTO topics(name, parent_id, type)
SELECT CONCAT("topic-", subcategory_id, counter_id), subcategory_id, 3
FROM (
    select subcategories.id as subcategory_id, counters.id as counter_id FROM
        (
            (SELECT id from counters limit 1000) counters,
            (SELECT id from topics where type = 2) subcategories
        )
) t;

select count(id) from topics;
select type, count(id) from topics group by type;
select type, min(parent_id), count(id) from topics group by type;
