CREATE TABLE password_tokens (
    token       TEXT
    , user_id   INTEGER
    , timestamp DATETIME
    , active    BOOLEAN
);
