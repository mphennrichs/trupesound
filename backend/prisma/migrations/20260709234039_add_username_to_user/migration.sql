-- AlterTable: add username as nullable first, backfill, then enforce NOT NULL + UNIQUE
ALTER TABLE "User" ADD COLUMN "username" TEXT;

-- Backfill: derive from the email local-part, sanitized to [a-z0-9._],
-- deduplicated with a numeric suffix on collision.
DO $$
DECLARE
  rec RECORD;
  base_username TEXT;
  candidate TEXT;
  suffix INT;
BEGIN
  FOR rec IN SELECT "id", "email" FROM "User" ORDER BY "id" LOOP
    base_username := lower(split_part(rec."email", '@', 1));
    base_username := regexp_replace(base_username, '[^a-z0-9._]', '', 'g');
    IF base_username = '' OR base_username IS NULL THEN
      base_username := 'user' || rec."id";
    END IF;

    candidate := base_username;
    suffix := 1;
    WHILE EXISTS (SELECT 1 FROM "User" WHERE "username" = candidate) LOOP
      suffix := suffix + 1;
      candidate := base_username || suffix;
    END LOOP;

    UPDATE "User" SET "username" = candidate WHERE "id" = rec."id";
  END LOOP;
END $$;

-- Enforce constraints now that every row has a value
ALTER TABLE "User" ALTER COLUMN "username" SET NOT NULL;
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");
