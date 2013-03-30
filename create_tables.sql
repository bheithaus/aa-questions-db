--mshopsin very nicely laid out
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  is_instructor INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT_NULL,
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS question_followers (
  follower_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY(follower_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE IF NOT EXISTS question_replies(
  id INTEGER PRIMARY KEY,
  parent INTEGER,
  body TEXT NOT NULL,
  q_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(q_id) REFERENCES questions(id)
);

-- CREATE TABLE questions_actions(
--   FOREIGN KEY(question_id) REFERENCES questions(id),
--   type VARCHAR(6)
-- );
--
CREATE TABLE IF NOT EXISTS question_like(
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

-- INSERTS BELOW HERE

-- INSERT INTO question_like
-- VALUES
-- (1,1),
-- (1,3),
-- (1,2),
-- (2,1),
-- (2,4),
-- (3,4),
-- (5,4),
-- (5,4);



-- INSERT INTO question_replies
-- ('parent', 'body', 'q_id', 'user_id')
-- VALUES
-- (1,'testing',1,5)
-- (0,'This IS SQL, thanks for your detailed question',1,5),
-- (1,'are you sure this is sql?',1,3),
-- (0,'I dont have time for this!',3,5),
-- (0,'A good place to use self join is finding bus stops',4,5),
-- (4,'is that because you can match stops to other stops within the same table?',4,1)

-- INSERT INTO question_followers VALUES
-- (1,3),
-- (1,4),
-- (2,1),
-- (3,2)

-- INSERT INTO users
-- ('fname','lname','is_instructor')
-- VALUES
-- ('Brian','Heithaus','0'),
-- ('Dan','Tsui','0'),
-- ('Mark','Shopsin','0'),
-- ('Bill','Bill','0'),
-- ('Ned','Ruggeri','1');

-- INSERT INTO questions
-- ('title','body','user_id')
-- VALUES ('how to sql?','Hey, so how do I insert a value into a SQL table?','1'),
-- ('heap vs stack?','Whats the difference between a heap and a stack?','2'),
-- ('self join','What is an example use case of self join?','3');
