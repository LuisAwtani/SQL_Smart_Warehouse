CREATE TABLE "items" (
    "id" INTEGER,
    "name" TEXT UNIQUE NOT NULL,
    PRIMARY KEY("id")
);


CREATE TABLE "stock" (
    "id" INTEGER,
    "item_id" INTEGER,
    "quantity" INTEGER CHECK ("quantity" >= 0),
    "warehouse" TEXT NOT NULL CHECK("warehouse" IN ('Boston', 'Texas', 'Florida', 'Connecticut')), --Multiple warehouse locations
    PRIMARY KEY("id"),
    FOREIGN KEY("item_id") REFERENCES "items"("id")
);

CREATE TABLE "orders" (
    "id" INTEGER,
    "item_id" INTEGER,
    "quantity" INTEGER CHECK ("quantity" >= 0),,
    "warehouse" TEXT NOT NULL CHECK("warehouse" IN ('Boston', 'Texas', 'Florida', 'Connecticut')), --Which warehouse is being bought/sold from
    "purchase_type" TEXT CHECK("purchase_type" IN ('Buy','Sell')),
    "amount_due" NUMERIC NOT NULL, --Total price paid
    "datetime" NUMERIC,
    "shipped" INTEGER NOT NULL DEFAULT 0, --Check if order has been shipped, that is, if it is still an outstanding task for employees
    PRIMARY KEY("id"),
    FOREIGN KEY("item_id") REFERENCES "items"("id")
);

CREATE VIEW "outstanding_tasks" AS
SELECT "orders"."id" AS "order ID", "name" AS "item","purchase_type","quantity","warehouse" FROM "orders"
JOIN "items" ON "orders"."item_id" = "items"."id"
WHERE "shipped" = 0;

CREATE TRIGGER "task_complete"
INSTEAD OF DELETE ON "outstanding_tasks"
FOR EACH ROW
BEGIN
    UPDATE "orders" SET "shipped" = 1
    WHERE "id" = OLD."order ID";
END;

CREATE TRIGGER "new_item" --Trigger that adds new items to the stock database with an initial quantity of 0
AFTER INSERT ON "items"
FOR EACH ROW
BEGIN
    INSERT INTO "stock"("item_id","quantity","warehouse") VALUES (NEW.id,0,'Boston');
    INSERT INTO "stock"("item_id","quantity","warehouse") VALUES (NEW.id,0,'Texas');
    INSERT INTO "stock"("item_id","quantity","warehouse") VALUES (NEW.id,0,'Florida');
    INSERT INTO "stock"("item_id","quantity","warehouse") VALUES (NEW.id,0,'Connecticut');
END;

-- Updates stock table when items are bought/sold
CREATE TRIGGER "update_stock"
AFTER INSERT ON "orders"
FOR EACH ROW
BEGIN
UPDATE "stock"
    SET "quantity" = "quantity" +
        CASE
            WHEN NEW.purchase_type = 'Buy' THEN NEW.quantity
            ELSE -NEW.quantity
        END
    WHERE "item_id" = NEW."item_id" AND "warehouse" = NEW."warehouse";
END;

--index to optimize item search by name
CREATE INDEX "item_name_index" on "items"("name");
