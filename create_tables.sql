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
--
-- CREATE TABLE question_replies(
--   id INTEGER PRIMARY KEY,
--   body TEXT NOT NULL,
--   FOREIGN KEY(subject) REFERENCES questions(id),
--   parent INTEGER
-- );
--
-- CREATE TABLE questions_actions(
--   FOREIGN KEY(question_id) REFERENCES questions(id),
--   type VARCHAR(6)
-- );
--
-- CREATE TABLE question_like(
--   FOREIGN KEY(user_id) REFERENCES users(id),
--   FOREIGN KEY(question_id) REFERENCES questions(id)
-- );

-- INSERTS BELOW HERE

INSERT INTO question_followers VALUES
(1,3),
(1,4),
(2,1),
(3,2)


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
