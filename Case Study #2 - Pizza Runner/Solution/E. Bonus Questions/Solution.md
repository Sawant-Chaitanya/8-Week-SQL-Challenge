### If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu

---


### Expanding Pizza Range

To expand the range of pizzas to include a new Supreme pizza with all the toppings, the existing data design would need to be adjusted. Below are the steps required and an example INSERT statement to demonstrate adding the new pizza:

1. **pizza_names Table**: Insert a new row representing the Supreme pizza.

2. **pizza_recipes Table**: Add another row defining the toppings for the Supreme pizza.

3. **pizza_toppings Table**: If any new toppings are introduced specifically for the Supreme pizza, they should be added to the `pizza_toppings` table.

### Example INSERT Statement

```sql
-- Insert data for the new Supreme pizza into the pizza_names table
INSERT INTO pizza_names (pizza_id, pizza_name)
VALUES (3, 'Supreme');

-- Insert data for the new Supreme pizza into the pizza_recipes table
INSERT INTO pizza_recipes (pizza_id, toppings)
VALUES (3, '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12');
```

In this example, the Supreme pizza is assigned a `pizza_id` of 3 and includes all existing toppings available in the `pizza_toppings` table. Adjustments may be needed based on the specific requirements and toppings for the new pizza.
