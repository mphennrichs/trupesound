-- AlterTable
ALTER TABLE "Act" ADD COLUMN     "cues" JSONB NOT NULL DEFAULT '[]';

-- AlterTable
ALTER TABLE "AppConfig" ADD COLUMN     "storageAccessKey" TEXT,
ADD COLUMN     "storageEndpoint" TEXT,
ADD COLUMN     "storageSecretKey" TEXT;
