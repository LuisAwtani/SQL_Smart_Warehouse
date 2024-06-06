--See list of all types of items in the database
SELECT *
FROM "items";

--Add a new item
INSERT INTO "items"("name")
VALUES
('toy'),
('stick'),
('boat'),
('bottle');

--Add a new order
INSERT INTO "orders"("item_id", "quantity", "warehouse", "purchase_type", "amount_due", "datetime")
SELECT "id", 12, 'Texas', 'Buy', 87.62, CURRENT_TIMESTAMP
FROM "items"
WHERE "name" = 'toy';

--See all outstanding tasks for workers in Connecticut Warehouse
SELECT *
FROM "outstanding_tasks"
WHERE "warehouse" = 'Connecticut';

--See all items currently being stored in Texas warehouse
SELECT "name","quantity"
FROM "stock"
JOIN "items" ON "stock"."item_id" = "items"."id"
WHERE "warehouse" = 'Texas'
AND "quantity" > 0;


--See list of items that were sold this year, as well as the quantity, sorted from most sold to least
SELECT "name",
SUM("quantity") AS "Quantity sold this year"
FROM "orders"
JOIN "items" ON "orders"."item_id" = "items"."id"
WHERE "datetime" > '2024-01-01'
AND "purchase_type" = 'Buy'
GROUP BY "name"
ORDER BY "Quantity sold this year" DESC;
