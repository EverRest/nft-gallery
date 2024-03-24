-- CreateEnum
CREATE TYPE "Auction" AS ENUM ('dutch', 'english', 'min_price', 'drop', 'lottery', 'free_spin');

-- CreateTable
CREATE TABLE "Collection" (
    "id" SERIAL NOT NULL,
    "slug" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "details" JSONB NOT NULL,

    CONSTRAINT "Collection_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Account" (
    "id" SERIAL NOT NULL,
    "userName" TEXT,
    "address" TEXT NOT NULL,
    "details" JSONB NOT NULL,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Asset" (
    "id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "collectionId" INTEGER NOT NULL,
    "description" TEXT NOT NULL,
    "contractDate" TIMESTAMP(3) NOT NULL,
    "url" TEXT NOT NULL,
    "imgUrl" TEXT NOT NULL,
    "ownerId" INTEGER NOT NULL,
    "details" JSONB NOT NULL,
    "categoryId" INTEGER NOT NULL,

    CONSTRAINT "Asset_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NftSale" (
    "id" INTEGER NOT NULL,
    "time" TIMESTAMP(3) NOT NULL,
    "assetId" INTEGER NOT NULL,
    "collectionId" INTEGER NOT NULL,
    "auctionType" "Auction" NOT NULL,
    "contractAddress" TEXT NOT NULL,
    "quantity" DOUBLE PRECISION NOT NULL,
    "paymentSymbol" TEXT NOT NULL,
    "totalPrice" DOUBLE PRECISION NOT NULL,
    "sellerAccountId" INTEGER NOT NULL,
    "fromAccountId" INTEGER NOT NULL,
    "toAccountId" INTEGER NOT NULL,
    "winnerAccountId" INTEGER NOT NULL,

    CONSTRAINT "NftSale_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Category" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Category_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Collection_slug_key" ON "Collection"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "Account_address_key" ON "Account"("address");

-- CreateIndex
CREATE UNIQUE INDEX "Asset_url_key" ON "Asset"("url");

-- AddForeignKey
ALTER TABLE "Asset" ADD CONSTRAINT "Asset_collectionId_fkey" FOREIGN KEY ("collectionId") REFERENCES "Collection"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Asset" ADD CONSTRAINT "Asset_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Asset" ADD CONSTRAINT "Asset_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NftSale" ADD CONSTRAINT "NftSale_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "Asset"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NftSale" ADD CONSTRAINT "NftSale_collectionId_fkey" FOREIGN KEY ("collectionId") REFERENCES "Collection"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NftSale" ADD CONSTRAINT "NftSale_sellerAccountId_fkey" FOREIGN KEY ("sellerAccountId") REFERENCES "Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NftSale" ADD CONSTRAINT "NftSale_fromAccountId_fkey" FOREIGN KEY ("fromAccountId") REFERENCES "Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NftSale" ADD CONSTRAINT "NftSale_toAccountId_fkey" FOREIGN KEY ("toAccountId") REFERENCES "Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NftSale" ADD CONSTRAINT "NftSale_winnerAccountId_fkey" FOREIGN KEY ("winnerAccountId") REFERENCES "Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
