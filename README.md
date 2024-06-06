# Design Document

By Luis Bernardo Awtani

Video overview: <https://www.youtube.com/watch?v=d3JO0jVYvKk>

## Scope

The scope of this database is to track warehouse operations such as keeping track of stock, finances and outstanding tasks to be completed in a warehouse

* The purpose is to help automate the process of keeping stock and assigning tasks to employees
* The scope of this database includes keeping track of items, orders and stock across multiple warehouse locations
* Out of scope are the employee management systems such as shift time management and payroll management


## Functional Requirements

With the help of the database, a user should be able to:
* Automate the process of keeping track of their businesses stock across warehouses
* Track orders and extract patterns from ongoing warehouse operations to drive business their decisions
Note that the employee management tools for managers are out of the scope fo the current version

## Representation

Entities are captured in SQLite tables with the following schema.
![image](ER_Diagram.png)

### Entities

The database includes the following entities:

#### items

The `items` table includes:

* `id`, which specifies the unique ID for the item as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `name`, which contains the name of the specified items as `TEXT`.

All columns are required and hence have the `NOT NULL` constraint applied where a `PRIMARY KEY` constraint is not.


#### stock

The `stock` table includes:

* `id`, which specifies the unique ID for the entry as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `item_id`, which contains the ID of the corresponding item as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied.
* `quantity`, which specifies the quantity of the given item that is currently being stored as an `INTEGER`. This column has the
`CHECK ('quantity' > 0)` constraint applied to ensure that an error is raised if an event (or order) would reduce the quantity below 0.
* `warehouse`, which specifies the warehouse location at which the stock entry is being kept as `TEXT`

All columns are required and hence have the `NOT NULL` constraint applied where a `PRIMARY KEY` or `FOREIGN KEY` constraint is not.


#### orders

The `orders` table includes:

* `id`, which specifies the unique ID for the entry as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `item_id`, which contains the ID of the corresponding item as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied.
* `quantity`, which specifies the quantity of the given item that has been ordered as an `INTEGER`. This column has the
`CHECK ('quantity' > 0)` constraint applied as an order must have a positive quantity
* `warehouse`, which specifies the warehouse location at which the stock entry is being kept as `TEXT`
* `purchase_type`, which refers to the kind of transaction specified by the order as `TEXT`, either a buy or a sell, which accounts for an increase or decrease in quantity at the warehouse. This column has the constraint `CHECK("purchase_type" IN ('Buy','Sell'))`, as those are the only two types
of transactions handled
* `amount_due`, which specifies the total amount paid or received for the order, as a `NUMERIC`. This data type was chosen to account for floating point values.
* `datetime`, which specifies the timestamp of when the order was received, as a `NUMERIC`.
* `shipped`, which specifies whether or not the order was "dealt with" already by employees, as an `INTEGER`. This data type was chosen as this column should always be 0 or 1. `shipped` has the default 0 condition, as all orders are initially not dealt with, and those orders that are not dealt with shop up in the `outstanding_tasks` view. The idea is that workers are abe to "check-off" tasks, thereby removing them from the `outstanding_tasks` view.

### Relationships

Entity relationship diagram
![image](ER_Diagram.png)

## Optimizations

* The view `outstanding_tasks` is created with the implementation of soft deletes on the orders table to show
if a sell has been shipped yet or a buy has been stocked properly, displaying a neat list of outstanding tasks for workers
* Three triggers have been created `task_complete`, `update_stock` and `new_item` to help automate the databases for the user

## Limitations

* One core limitation of the database is that it's not able to account for lost/stolen items
* Another limitation is that it is not a full-stop-shop for managing a warehouse as employee shifts,
productivity and payroll are not managed in this database.

