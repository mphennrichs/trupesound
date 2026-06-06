-- CreateTable
CREATE TABLE "AppConfig" (
    "id" INTEGER NOT NULL DEFAULT 1,
    "appId" TEXT NOT NULL,

    CONSTRAINT "AppConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Play" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "author" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "createdBy" INTEGER,
    "lastUpdatedAt" TIMESTAMP(3),
    "lastUpdatedBy" INTEGER,

    CONSTRAINT "Play_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Act" (
    "id" SERIAL NOT NULL,
    "playId" INTEGER NOT NULL,
    "number" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "script" JSONB NOT NULL DEFAULT '[]',
    "createdAt" TIMESTAMP(3) NOT NULL,
    "createdBy" INTEGER,
    "lastUpdatedAt" TIMESTAMP(3),
    "lastUpdatedBy" INTEGER,

    CONSTRAINT "Act_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "AppConfig_appId_key" ON "AppConfig"("appId");

-- AddForeignKey
ALTER TABLE "Act" ADD CONSTRAINT "Act_playId_fkey" FOREIGN KEY ("playId") REFERENCES "Play"("id") ON DELETE CASCADE ON UPDATE CASCADE;
